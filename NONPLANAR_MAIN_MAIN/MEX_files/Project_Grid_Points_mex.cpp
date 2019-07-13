#include "mex.h"
#include "matrix.h"
#include <iostream>
#include "string.h"
#include </usr/local/include/eigen3/Eigen/Eigen>
#include <stdio.h>
#include <vector>
#include <cmath>

Eigen::MatrixXd project_grid_points(const Eigen::MatrixXd&, const Eigen::MatrixXd&, const Eigen::MatrixXd&, double, double, double);
void InPoly(const Eigen::MatrixXd& q, const Eigen::MatrixXd& p, Eigen::VectorXd& );
bool lines_intersect(double l1[2][2], double l2[2][2]);
std::vector<int> find_idx(const Eigen::VectorXd& vec);
Eigen::MatrixXd rotate_pts(Eigen::MatrixXd, double, double, double);
Eigen::MatrixXd apply_transformation(Eigen::MatrixXd, Eigen::Matrix4d);
Eigen::Matrix4d hom_T(Eigen::Vector3d, Eigen::Matrix3d);
Eigen::Matrix3d rot_z(double);

void mexFunction (int _OutArgs, mxArray *MatlabOut[], int _InArgs, const mxArray *MatlabIn[] )
{
    // Define Input
    unsigned int fnew_cols = 3;
    unsigned int v_cols = 3;
    unsigned int pts_cols = 2;
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> fnew (mxGetPr(MatlabIn[0]), mxGetNumberOfElements(MatlabIn[0])/fnew_cols, fnew_cols); 
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> v (mxGetPr(MatlabIn[1]), mxGetNumberOfElements(MatlabIn[1])/v_cols, v_cols); 
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> pts (mxGetPr(MatlabIn[2]), mxGetNumberOfElements(MatlabIn[2])/pts_cols, pts_cols); 
    double *ptr_hatch_angle;
    double *ptr_x_avg;
    double *ptr_y_avg;
    ptr_hatch_angle = mxGetDoubles(MatlabIn[3]);
    ptr_x_avg = mxGetDoubles(MatlabIn[4]);
    ptr_y_avg = mxGetDoubles(MatlabIn[5]);
    double hatch_angle = (*ptr_hatch_angle)*3.14159/180;
    double x_avg = *ptr_x_avg;
    double y_avg = *ptr_y_avg;
    
    // Method 
    Eigen::MatrixXd fillpts = project_grid_points(fnew, v, pts, hatch_angle, x_avg, y_avg);

    // Define Output
    MatlabOut[0] = mxCreateDoubleMatrix(fillpts.rows(), fillpts.cols(), mxREAL);
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> M0 ( mxGetPr(MatlabOut[0]), fillpts.rows(), fillpts.cols() );
    M0 = fillpts.array();  
}

Eigen::MatrixXd project_grid_points(const Eigen::MatrixXd& fnew, const Eigen::MatrixXd& v, const Eigen::MatrixXd& pts, double hatch_angle, double x_avg, double y_avg)
{
    Eigen::MatrixXd p1(1,v.cols());
    Eigen::MatrixXd p2(1,v.cols());
    Eigen::MatrixXd p3(1,v.cols());
    Eigen::MatrixXd tri(3,v.cols());
    Eigen::MatrixXd fillpts = Eigen::MatrixXd::Constant(int(1.5*pts.rows()),6,0);
    double a, b, c, d, zval;
    long int fillpts_idx = 0;
    for (long int i=0;i<fnew.rows();++i)
    {
        // vertices for each triangle
        p1 = v.row(fnew(i,0)-1);
        p2 = v.row(fnew(i,1)-1);
        p3 = v.row(fnew(i,2)-1);

        // forming the face with vertices
        tri.block(0,0,1,p1.cols()) = p1;
        tri.block(1,0,1,p1.cols()) = p2;
        tri.block(2,0,1,p1.cols()) = p3;

        // projecting triagles on to the xy plane and 
        // storing all grid points which are inside triangle
        Eigen::VectorXd in = Eigen::VectorXd::Constant(pts.rows(),1,0);
        InPoly(pts, tri, in);
        std::vector<int> loc = find_idx(in);
        Eigen::MatrixXd store(loc.size(),pts.cols());
        Eigen::VectorXd storez(loc.size(),1);
        for (int loc_i=0;loc_i<loc.size();++loc_i)
        {
            store.row(loc_i) = pts.row(loc[loc_i]);
        }   
        if (store.rows()!=0)
        {
            // creating plane eqaution to get z value of stored points
            a = ((p2(0,1)-p1(0,1))*(p3(0,2)-p1(0,2)))-((p3(0,1)-p1(0,1))*(p2(0,2)-p1(0,2)));
            b = ((p2(0,2)-p1(0,2))*(p3(0,0)-p1(0,0)))-((p3(0,2)-p1(0,2))*(p2(0,0)-p1(0,0)));
            c = ((p2(0,0)-p1(0,0))*(p3(0,1)-p1(0,1)))-((p3(0,0)-p1(0,0))*(p2(0,1)-p1(0,1)));
            d = -(a*p1(0,0))-(b*p1(0,1))-(c*p1(0,2));
            for (int store_i=0;store_i<store.rows();++store_i)
            {
                zval = (-d-(a*store(store_i,0))-(b*store(store_i,1)))/c;
                if (zval<0)
                {
                    storez(store_i,0) = 0;
                }
                else
                {
                    storez(store_i,0) = zval;   
                }
            }

            // along with points, storing unit normal 
            // associated with each point from which, tcp orientation is calculated.
            Eigen::MatrixXd n = Eigen::MatrixXd::Constant(store.rows(),3,1);
            n.col(0) = n.col(0).array()*(a/sqrt((a*a)+(b*b)+(c*c)));
            n.col(1) = n.col(1).array()*(b/sqrt((a*a)+(b*b)+(c*c)));
            n.col(2) = n.col(2).array()*(c/sqrt((a*a)+(b*b)+(c*c)));
            fillpts.block(fillpts_idx,0,store.rows(),2) = store;
            fillpts.block(fillpts_idx,2,store.rows(),1) = storez;
            fillpts.block(fillpts_idx,3,store.rows(),3) = -n;
            fillpts_idx = fillpts_idx + store.rows();           
        }
    }   

    // giving negative of hatching angle to make points aligned along reference axes
    Eigen::MatrixXd fillpts_final(fillpts_idx,fillpts.cols());  
    fillpts_final = fillpts.block(0,0,fillpts_idx,fillpts.cols());
    Eigen::MatrixXd fillpts_new = rotate_pts(fillpts_final.block(0,0,fillpts_final.rows(),2),-hatch_angle,x_avg,y_avg);
    fillpts_final.col(0) = fillpts_new.col(0);
    fillpts_final.col(1) = fillpts_new.col(1);
    return fillpts_final; 
}

void InPoly(const Eigen::MatrixXd& q, const Eigen::MatrixXd& p, Eigen::VectorXd& in)
{
	double l1[2][2];
	double l2[2][2];

	double xmin = p.col(0).minCoeff();
	double xmax = p.col(0).maxCoeff();
	double ymin = p.col(1).minCoeff();
	double ymax = p.col(1).maxCoeff();

	for (long i=0;i<q.rows();++i)
	{
		// bounding box test
		if (q(i,0)<xmin || q(i,0)>xmax || q(i,1)<ymin || q(i,1)>ymax)
		{
			continue;
		}
		int intersection_count = 0;
		Eigen::MatrixXd cont_lines = Eigen::MatrixXd::Constant(p.rows(),1,0);
		for (int j=0;j<p.rows();++j)
		{
			if (j==0)
			{
				l1[0][0] = q(i,0);l1[0][1] = q(i,1);
				l1[1][0] = xmax;l1[1][1] = q(i,1);
				l2[0][0] = p(p.rows()-1,0);l2[0][1] = p(p.rows()-1,1);
				l2[1][0] = p(j,0);l2[1][1] = p(j,1);
				if (lines_intersect(l1,l2))
				{
					intersection_count++;
					cont_lines(j,0) = 1;
				}	
			}
			else
			{
				l1[0][0] = q(i,0);l1[0][1] = q(i,1);
				l1[1][0] = xmax;l1[1][1] = q(i,1);
				l2[0][0] = p(j,0);l2[0][1] = p(j,1);
				l2[1][0] = p(j-1,0);l2[1][1] = p(j-1,1);
				if (lines_intersect(l1,l2))
				{
					intersection_count++;
					cont_lines(j,0) = 1;
					if (cont_lines(j-1,0)==1)
					{
						if (p(j-1,1)==q(i,1))
						{
							if (j-1==0)
							{
								if (!((p(p.rows()-1,1)<p(j-1,1) && p(j,1)<p(j-1,1)) || (p(p.rows()-1,1)>p(j-1,1) && p(j,1)>p(j-1,1))))
								{
									intersection_count--;
								}
							}
							else
							{
								if (!((p(j-2,1)<p(j-1,1) && p(j,1)<p(j-1,1)) || (p(j-2,1)>p(j-1,1) && p(j,1)>p(j-1,1))))
								{
									intersection_count--;
								}
							}
						}
					}
				}
			}
		}
		if (intersection_count%2==1)
		{
			in(i,0) = 1;
		}
	}
}

bool lines_intersect(double l1[2][2], double l2[2][2])
{
	// l1 for horizontal ray line...slope is always zero

	// checking if other slope is zero
	if (l2[0][1]==l2[1][1])
	{
    	return false;
	}
	else
	{
		// checking both pts of second line above first line
		if ((l2[0][1]>l1[0][1] && l2[1][1]>l1[0][1]) || (l2[0][1]<l1[0][1] && l2[1][1]<l1[0][1]))
		{
			return false;
		}
		else
		{
			// checking both pts of second line either on right or on left of fist line
			if ((l2[0][0]<l1[0][0] && l2[1][0]<l1[0][0]) || (l2[0][0]>l1[1][0] && l2[1][0]>l1[1][0]))
			{
				return false;
			}
			else
			{
				// checking if other line is vertical
				if (l2[0][0]== l2[1][0])
				{
					return true;
				}
				else
				{
					// getting intersection point
					double m2 = (l2[1][1]-l2[0][1])/(l2[1][0]-l2[0][0]);		
					double x = (l1[0][1]+m2*l2[0][0]-l2[0][1])/m2;
					// checking if intersection point lies on the first line
					if ((x>l1[0][0] || std::abs(x-l1[0][0])<1e-9) && (x<l1[1][0] || std::abs(x-l1[1][0])<1e-9))
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
		}
	} 
	return false;
}

std::vector<int> find_idx(const Eigen::VectorXd& vec)
{
    std::vector<int> idx;
    for (int i=0;i<vec.rows();++i)
    {
        if (vec(i,0)!=0)
        {
            idx.push_back(i);   
        }
    }
    return idx;
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