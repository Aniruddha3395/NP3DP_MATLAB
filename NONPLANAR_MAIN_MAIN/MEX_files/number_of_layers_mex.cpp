#include "mex.h"
#include "matrix.h"
#include <iostream>
#include "string.h"
#include </usr/local/include/eigen3/Eigen/Eigen>
#include <stdio.h>
#include <vector>

int number_of_layers(Eigen::MatrixXd, Eigen::MatrixXd, Eigen::MatrixXd, double);
std::vector<int> ismember(Eigen::MatrixXd, Eigen::MatrixXd);
std::vector<int> find_idx(std::vector<int>);
double median(std::vector<double>);
Eigen::VectorXd linsp(double, double, double);

void mexFunction (int _OutArgs, mxArray *MatlabOut[], int _InArgs, const mxArray *MatlabIn[] )
{
    // Define Input
    unsigned int v_cols = 3;
    unsigned int f_cols = 3;
    unsigned int n_cols = 3;
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> v (mxGetPr(MatlabIn[0]), mxGetNumberOfElements(MatlabIn[0])/v_cols, v_cols); 
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> f (mxGetPr(MatlabIn[1]), mxGetNumberOfElements(MatlabIn[1])/f_cols, f_cols); 
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> n (mxGetPr(MatlabIn[2]), mxGetNumberOfElements(MatlabIn[2])/n_cols, n_cols); 
    double *ptr_pathgap_z;
    ptr_pathgap_z = mxGetDoubles(MatlabIn[3]);
    double pathgap_z = *ptr_pathgap_z;

    // Method 
    int num = number_of_layers( v, f, n, pathgap_z);

    // Define Output
    MatlabOut[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    Eigen::Map<Eigen::ArrayXXd,Eigen::Aligned> M0 ( mxGetPr(MatlabOut[0]), 1, 1 );
    M0 << num;  
}

int number_of_layers(Eigen::MatrixXd v, Eigen::MatrixXd f, Eigen::MatrixXd n, double pathgap_z)
{
    Eigen::MatrixXd n_new(n.rows(),4);
    n_new.block(0,0,n_new.rows(),3) = (((n.array()*100.0).cast<int>()).cast<double>().array()/100.0);
    n_new.block(0,3,n_new.rows(),1) = linsp(0,n_new.rows()-1,1); 
    
    // sorting normals for top and bottom face
    Eigen::MatrixXd nn_i = Eigen::MatrixXd::Constant(n_new.rows(),n_new.cols(),0);
    Eigen::MatrixXd np_i = Eigen::MatrixXd::Constant(n_new.rows(),n_new.cols(),0);
    long int nn_idx = 0;
    long int np_idx = 0;
    for (long int i=0;i<n_new.rows();++i)
    {
        if (n_new(i,2)<0)
        {
            nn_i.row(nn_idx) = n_new.row(i);
            ++nn_idx;
        }
        else if (n_new(i,2)>0)
        {
            np_i.row(np_idx) = n_new.row(i);
            ++np_idx;
        }
    }
    Eigen::MatrixXd nn = nn_i.block(0,0,nn_idx,nn_i.cols());
    Eigen::MatrixXd np = np_i.block(0,0,np_idx,np_i.cols());

    // getting normals which are opposite ot each other and forming pairs of parallel faces 
    Eigen::MatrixXd p11(1,3);
    Eigen::MatrixXd p12(1,3);
    Eigen::MatrixXd p13(1,3);
    Eigen::MatrixXd p21(1,3);
    Eigen::MatrixXd nn_row(1,3);
    double a = 0;
    double b = 0;
    double c = 0;
    double d = 0;
    std::vector<double> t;
    for (long int i=0;i<nn.rows();++i)
    {
        nn_row = -nn.block(i,0,1,3);
        std::vector<int> idx = ismember(np.block(0,0,np.rows(),3),nn_row);
        std::vector<int> store_idx = find_idx(idx);
        if (store_idx.size()!=0)
        {
            // calculating the gap between parallel faces by plane to plane distance formaula
            long int pair[2];
            pair[0] = np(store_idx[0],3);
            pair[1] = nn(i,3);
            p11 = v.row(f(pair[0],0)-1);
            p12 = v.row(f(pair[0],1)-1);
            p13 = v.row(f(pair[0],2)-1);
            p21 = v.row(f(pair[1],0)-1);
            a = ((p12(0,1)-p11(0,1))*(p13(0,2)-p11(0,2)))-((p13(0,1)-p11(0,1))*(p12(0,2)-p11(0,2)));
            b = ((p12(0,2)-p11(0,2))*(p13(0,0)-p11(0,0)))-((p13(0,2)-p11(0,2))*(p12(0,0)-p11(0,0)));
            c = ((p12(0,0)-p11(0,0))*(p13(0,1)-p11(0,1)))-((p13(0,0)-p11(0,0))*(p12(0,1)-p11(0,1)));
            d = -(a*p11(0,0))-(b*p11(0,1))-(c*p11(0,2));
            t.push_back(fabs((a*p21(0,0)+b*p21(0,1)+c*p21(0,2)+d)/sqrt((a*a)+(b*b)+(c*c))));
        }
    }
    double t_f = median(t);
    int num_of_layers = round(t_f/pathgap_z);
    if (num_of_layers==0)
    {
        num_of_layers=1;
    }
    return num_of_layers;
}

std::vector<int> ismember(Eigen::MatrixXd mat, Eigen::MatrixXd row_vec)
{
    std::vector<int> v;
    for (long int i=0;i<mat.rows();++i)
    {
        if (mat.row(i)==row_vec)
        {
            v.push_back(1);
        }
        else
        {
            v.push_back(0);
        }
    }
    return v;
}

std::vector<int> find_idx(std::vector<int> vec)
{
    std::vector<int> idx;
    for (int i=0;i<vec.size();++i)
    {
        if (vec[i]!=0)
        {
            idx.push_back(i);   
        }
    }
    return idx;
}

double median(std::vector<double> vec)
{
    std::sort(vec.begin(),vec.end());
    if (vec.size()%2==1)    // odd
    {
        return vec[vec.size()/2];
    }
    else                    // even
    {
        return (vec[(vec.size()/2)-1]+vec[vec.size()/2])/2; 
    }
}

Eigen::VectorXd linsp(double strt, double end, double stp)
{
    int sz;
    if (strt<=end && stp>0 || strt>=end && stp<0)
    {
        sz = int((end-strt)/stp)+1;
    }
    else
    {
        if (strt>=end)
        {
            std::cerr << "start value is greater than the end value for incement!" << std::endl;
            std::terminate();   
        }
        else
        {
            std::cerr << "start value is less than the end value for decrement!" << std::endl;
            std::terminate();   
        }
    }
    return Eigen::VectorXd::LinSpaced(sz,strt,strt+stp*(sz-1));
}