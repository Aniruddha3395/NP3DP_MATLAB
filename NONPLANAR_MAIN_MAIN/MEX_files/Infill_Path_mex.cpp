#include "mex.h"
#include "matrix.h"
#include <iostream>
#include "string.h"
#include </usr/local/include/eigen3/Eigen/Eigen>
#include <stdio.h>
#include <vector>
#include <cmath>

Eigen::MatrixXd Infill_Path(Eigen::MatrixXd, double, double, double, double, double);
std::vector<std::vector<double> > mat_to_vec(Eigen::MatrixXd);
std::vector<std::vector<double> > SortRows(std::vector<std::vector<double> >, int);
Eigen::MatrixXd vec_to_mat(std::vector<std::vector<double> >);
Eigen::MatrixXd rotate_pts(Eigen::MatrixXd, double, double, double);
Eigen::MatrixXd apply_transformation(Eigen::MatrixXd, Eigen::Matrix4d);
Eigen::Matrix4d hom_T(Eigen::Vector3d, Eigen::Matrix3d);
Eigen::Matrix3d rot_z(double);

void mexFunction (int _OutArgs, mxArray *MatlabOut[], int _InArgs, const mxArray *MatlabIn[] )
{
    // Define Input
    unsigned int fillpts_cols = 6;
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> fillpts (mxGetPr(MatlabIn[0]), mxGetNumberOfElements(MatlabIn[0])/fillpts_cols, fillpts_cols); 
    double *ptr_FlipTravel;
    double *ptr_space;
    double *ptr_hatch_angle;
    double *ptr_x_avg;
    double *ptr_y_avg;
    ptr_FlipTravel = mxGetDoubles(MatlabIn[1]);
    ptr_space = mxGetDoubles(MatlabIn[2]);
    ptr_hatch_angle = mxGetDoubles(MatlabIn[3]);
    ptr_x_avg = mxGetDoubles(MatlabIn[4]);
    ptr_y_avg = mxGetDoubles(MatlabIn[5]);
    double FlipTravel = *ptr_FlipTravel;
    double space = *ptr_space;
    double hatch_angle = (*ptr_hatch_angle)*3.14159/180;
    double x_avg = *ptr_x_avg;
    double y_avg = *ptr_y_avg;
    
    // Method 
    Eigen::MatrixXd tool_path = Infill_Path(fillpts, FlipTravel, space, hatch_angle, x_avg, y_avg);

    // Define Output
    MatlabOut[0] = mxCreateDoubleMatrix(tool_path.rows(), tool_path.cols(), mxREAL);
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> M0 ( mxGetPr(MatlabOut[0]), tool_path.rows(), tool_path.cols() );
    M0 = tool_path.array();  
}

Eigen::MatrixXd Infill_Path(Eigen::MatrixXd fillpts, double FlipTravel, double space, double hatch_angle, double x_avg, double y_avg)
{
    // function for creating path from projected points for tcp travel along x direction
    // INPUT: projected points on the surface (equally spaced along x and y axes)
    // OUTPUT: points arranged along 0 degree path with their Rx and Ry value

    int dir1 = 1;
    int dir2 = 0;
    Eigen::MatrixXd allpts = fillpts;
    std::vector<std::vector<double> > allpts_vec;
    allpts_vec = mat_to_vec(allpts);
    allpts_vec = SortRows(allpts_vec, dir1);
    allpts = vec_to_mat(allpts_vec);
    int flip  = 0;
    Eigen::MatrixXd storeset = Eigen::MatrixXd::Constant(allpts.rows(),allpts.cols(),0);
    Eigen::MatrixXd storesort = Eigen::MatrixXd::Constant(allpts.rows(),allpts.cols(),0);
    long int storesort_strt = 0;
    long int storeset_idx = 0;
    for (long int i=0;i<allpts.rows()-1;++i)
    {
        if (std::fabs(allpts(i,dir1)-allpts(i+1,dir1))<0.0001)
        {
            storeset.row(storeset_idx) = allpts.row(i);
            ++storeset_idx;
        }   
        else
        {
            storeset.row(storeset_idx) = allpts.row(i);
            Eigen::MatrixXd storeset_nz(storeset_idx+1,storeset.cols());
            storeset_nz = storeset.block(0,0,storeset_idx+1,storeset.cols());
            std::vector<std::vector<double> > storeset_nz_vec;
            storeset_nz_vec = mat_to_vec(storeset_nz);
            storeset_nz_vec = SortRows(storeset_nz_vec,dir2);
            storeset_nz = vec_to_mat(storeset_nz_vec);
            if (double(flip)/2==round(double(flip)/2))
            {
                Eigen::MatrixXd storeset_nz_rev(storeset_nz.rows(),storeset_nz.cols()); 
                storeset_nz_rev = storeset_nz.colwise().reverse();
                storeset_nz = storeset_nz_rev;
            }
            flip++;
            storesort.block(storesort_strt,0,storeset_nz.rows(),storeset_nz.cols()) = storeset_nz;
            storesort_strt = storesort_strt + storeset_idx+1;
            storeset_idx = 0;
        }       
    }
    storeset.row(storeset_idx) = allpts.row(allpts.rows()-1);
    Eigen::MatrixXd storeset_nz(storeset_idx+1,storeset.cols());
    storeset_nz = storeset.block(0,0,storeset_idx+1,storeset.cols());
    std::vector<std::vector<double> > storeset_nz_vec;
    storeset_nz_vec = mat_to_vec(storeset_nz);
    storeset_nz_vec = SortRows(storeset_nz_vec,dir2);
    storeset_nz = vec_to_mat(storeset_nz_vec);

    // this is to get the direction of last line travel
    if (double(flip)/2==round(double(flip)/2))
    {
        Eigen::MatrixXd storeset_nz_rev(storeset_nz.rows(),storeset_nz.cols()); 
        storeset_nz_rev = storeset_nz.colwise().reverse();
        storeset_nz = storeset_nz_rev;
    }
    storesort.block(storesort_strt,0,storeset_nz.rows(),storeset_nz.cols()) = storeset_nz;  

    Eigen::VectorXd Rx = -atan(storesort.block(0,4,storesort.rows(),1).array()/storesort.block(0,5,storesort.rows(),1).array())*(180/3.14159);
    Eigen::VectorXd Ry = atan(storesort.block(0,3,storesort.rows(),1).array()/storesort.block(0,5,storesort.rows(),1).array())*(180/3.14159);
    Eigen::MatrixXd storesort0x1(storesort.rows(),5);
    storesort0x1.block(0,0,storesort.rows(),3) = storesort.block(0,0,storesort.rows(),3);
    storesort0x1.block(0,3,storesort.rows(),1) = Rx;
    storesort0x1.block(0,4,storesort.rows(),1) = Ry;

    // storing every n'th point to smoothen out the path 
    int count = 0;
    Eigen::MatrixXd store_spaced_pt = Eigen::MatrixXd::Constant(storesort0x1.rows(),storesort0x1.cols(),0); 
    store_spaced_pt.row(0) = storesort0x1.row(0);
    long int store_spaced_pt_idx = 0;
    int flagg = 0;
    for (long int i=1;i<storesort0x1.rows()-1;++i)
    {
        if (flagg==1)
        {
            flagg=0;
            continue;
        }
        if (storesort0x1(i,1)==storesort0x1(i+1,1))
        {
            ++count;
            if (double(count)/space == round(count/space))
            {
                ++store_spaced_pt_idx;
                store_spaced_pt.row(store_spaced_pt_idx) = storesort0x1.row(i);
                count = 0;
            }
        }
        else
        {
            ++store_spaced_pt_idx;
            store_spaced_pt.row(store_spaced_pt_idx) = storesort0x1.row(i);
            ++store_spaced_pt_idx;
            store_spaced_pt.row(store_spaced_pt_idx) = storesort0x1.row(i+1);
            flagg = 1;  
        }
    }

    // adding the last point
    store_spaced_pt.row(store_spaced_pt_idx) = storesort0x1.row(storesort0x1.rows()-1);
    Eigen::MatrixXd storesort0x1tp = store_spaced_pt.block(0,0,store_spaced_pt_idx+1,store_spaced_pt.cols());

    // flip the direction of travel
    if (FlipTravel==1)
    {
        Eigen::MatrixXd storesort0x1tp_rev(storesort0x1tp.rows(),storesort0x1tp.cols());
        storesort0x1tp_rev = storesort0x1tp.colwise().reverse();
        storesort0x1tp = storesort0x1tp_rev;
    }

    //apply hatching angle
    Eigen::MatrixXd storesort0x1tp_new = rotate_pts(storesort0x1tp.block(0,0,storesort0x1tp.rows(),2),hatch_angle,x_avg,y_avg);
    storesort0x1tp.block(0,0,storesort0x1tp.rows(),2) = storesort0x1tp_new;
    return storesort0x1tp;
}

std::vector<std::vector<double> > mat_to_vec(Eigen::MatrixXd mat)
{
    std::vector<std::vector<double> > vec;
    for (long int i = 0; i < mat.rows(); ++i)
    {
        std::vector<double> vec_row;
        for (long int j = 0; j < mat.cols(); ++j)
        {
            vec_row.push_back(mat(i,j));
        }
        vec.push_back(vec_row);
    }
    return vec;
}

std::vector<std::vector<double> > SortRows(std::vector<std::vector<double> > input, int col)
{
    for (long int i=0;i<input.size();++i)
    {
        double temp = input[i][0];
        input[i][0] = input[i][col];
        input[i][col] = temp; 
    }
    std::sort(input.begin(), input.end());
    for (long int i=0;i<input.size();++i)
    {
        double temp = input[i][0];
        input[i][0] = input[i][col];
        input[i][col] = temp; 
    }
    return input;   
}

Eigen::MatrixXd vec_to_mat(std::vector<std::vector<double> > vec)
{
    Eigen::MatrixXd mat(vec.size(), vec[0].size());
    for (long int i = 0; i < vec.size(); ++i)
        mat.row(i) = Eigen::VectorXd::Map(&vec[i][0], vec[0].size());
    return mat;
}

Eigen::MatrixXd rotate_pts(Eigen::MatrixXd pts, double theta, double x_avg, double y_avg)
{
    // Function for applying rotation to points about their centroid
    // INPUT : xyz points, rotation angle, x-avg and y-avg
    // OUTPUT : rotated points about their centroid

    // translate points so that origin matches with the centroid
    pts.block(0,0,pts.rows(),1) = pts.block(0,0,pts.rows(),1).array() - x_avg;
    pts.block(0,1,pts.rows(),1) = pts.block(0,1,pts.rows(),1).array() - y_avg;

    // rotate points about centroid
    Eigen::Matrix3d r = rot_z(theta);
    Eigen::Vector3d t;
    t << 0,0,0;
    Eigen::Matrix4d T = hom_T(t, r);
    Eigen::MatrixXd pts_before_T(pts.rows(),pts.cols()+1);
    pts_before_T << pts,Eigen::MatrixXd::Constant(pts.rows(),1,0);
    Eigen::MatrixXd pts_T = apply_transformation(pts_before_T, T); 

    // translate points back to the original position
    pts_T.block(0,0,pts_T.rows(),1) = pts_T.block(0,0,pts_T.rows(),1).array() + x_avg;
    pts_T.block(0,1,pts_T.rows(),1) = pts_T.block(0,1,pts_T.rows(),1).array() + y_avg;
    return pts_T.block(0,0,pts_T.rows(),2);
}

Eigen::MatrixXd apply_transformation(Eigen::MatrixXd data, Eigen::Matrix4d T_mat)
{
    //NOTE: Homogeneous Tranformation Matrix (4x4)

    // putting data in [x, y, z, 1]' format
    Eigen::MatrixXd data_with_fourth_row(data.cols()+1,data.rows());
    Eigen::VectorXd ones_vec = Eigen::VectorXd::Constant(data.rows(),1);
    data_with_fourth_row.block(0,0,data.cols(),data.rows()) = data.transpose();
    data_with_fourth_row.block(data.cols(),0,1,data.rows()) = ones_vec.transpose();
    Eigen::MatrixXd transformed_data = T_mat*data_with_fourth_row;
    Eigen::MatrixXd transformed_data_mat(transformed_data.rows()-1,transformed_data.cols());
    transformed_data_mat = transformed_data.block(0,0,transformed_data.rows()-1,transformed_data.cols());
    return transformed_data_mat.transpose();
}

Eigen::Matrix4d hom_T(Eigen::Vector3d t, Eigen::Matrix3d r)
{
    Eigen::Matrix4d T;
    T.block(0,3,3,1) << t;
    T.block(0,0,3,3) << r;
    T.block(3,0,1,4) << 0,0,0,1;
    return T;
}

Eigen::Matrix3d rot_z(double t)
{
    Eigen::Matrix3d rz;
    rz << cos(t),-sin(t),   0,
          sin(t), cos(t),   0,
               0,      0,   1;
    return rz;  
}