#include "mex.h"
#include "matrix.h"
#include <iostream>
#include "string.h"
#include </usr/local/include/eigen3/Eigen/Eigen>
#include <stdio.h>
#include <vector>

Eigen::MatrixXd rotate_pts(Eigen::MatrixXd, double, double, double);
Eigen::MatrixXd apply_transformation(Eigen::MatrixXd, Eigen::Matrix4d);
Eigen::Matrix4d hom_T(Eigen::Vector3d, Eigen::Matrix3d);
Eigen::Matrix3d rot_z(double);

void mexFunction (int _OutArgs, mxArray *MatlabOut[], int _InArgs, const mxArray *MatlabIn[] )
{
    // Define Input
    unsigned int pts_cols = 2; 
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> pts (mxGetPr(MatlabIn[0]), mxGetNumberOfElements(MatlabIn[0])/pts_cols, pts_cols); 
    double *ptr_theta;
    double *ptr_x_avg;
    double *ptr_y_avg;
    ptr_theta = mxGetDoubles(MatlabIn[1]);
    ptr_x_avg = mxGetDoubles(MatlabIn[2]);
    ptr_y_avg = mxGetDoubles(MatlabIn[3]);
    double theta = (*ptr_theta)*3.14159/180;
    double x_avg = *ptr_x_avg;
    double y_avg = *ptr_y_avg;
    
    // Method 
    Eigen::MatrixXd pts_rotated = rotate_pts(pts, theta, x_avg, y_avg);
    
    // Define Output
    MatlabOut[0] = mxCreateDoubleMatrix(pts_rotated.rows(), pts_rotated.cols(), mxREAL);
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> M0 ( mxGetPr(MatlabOut[0]), pts_rotated.rows(), pts_rotated.cols() );
    M0 = pts_rotated.array();   
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