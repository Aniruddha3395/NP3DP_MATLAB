from __future__ import absolute_import, division, print_function
__metaclass__ = type

import os
import itertools
import numpy as np
import transformations as tf
import math
import pandas as pd

def T_from_xyzabc(x,y,z,a,b,c):
    translate = [ x, y, z ] # x,y,z
    angles = [ math.radians(a), math.radians(b), math.radians(c) ] # x,y,z
    T = tf.compose_matrix(
                        scale=None, shear=None, 
                        angles=angles, translate=translate,
                        perspective=None
                        )
    return T    

def xyzabc_from_T(T):
    R = T[0:3,0:3]
    t = T[:,3]
    euler = tf.euler_from_matrix(R, 'rxyz')
    xyz = [t[0],t[1],t[2]]
    abc = [math.degrees(euler[0]), math.degrees(euler[1]), math.degrees(euler[2])]
    return xyz, abc

def point_pairs_tf(A,B):
    centroid_A = np.mean(A, axis = 0).reshape((1,3))
    centroid_B = np.mean(B, axis = 0).reshape((1,3))
    A = A - centroid_A
    B = B - centroid_B


    H = np.matmul( np.transpose(A), B )
    U, S, Vt = np.linalg.svd(H)
    R = np.matmul( Vt.T, U.T )

    # special reflection case
    if np.linalg.det(R) < 0:
       # print ("Reflection detected")
       Vt[2,:] *= -1
       R = np.matmul( Vt.T, U.T )

    t = - np.matmul( R, centroid_A.T ) + centroid_B.T
    return R, t

def compute_calibration_mat(ip_A, ip_B):
    R, t = point_pairs_tf(ip_A,ip_B)
    euler = tf.euler_from_matrix(R, 'rxyz')
    xyz = [t[0][0],t[1][0],t[2][0]]
    abc = [math.degrees(euler[0]), math.degrees(euler[1]), math.degrees(euler[2])]
    CR_T_HR = np.empty((4,4))*0
    CR_T_HR [0:3,0:3] = R
    CR_T_HR [0,3] = xyz[0]
    CR_T_HR [1,3] = xyz[1]
    CR_T_HR [2,3] = xyz[2]
    CR_T_HR [3,3] = 1

    return CR_T_HR

def manual_robot_point_pairs():
    ## Samples of HR Robot
    A_mat = np.array([
                [203.2,0,0],
                [0, 0, 0],
                [0, 203.2, 0 ],
                [203.2, 203.2, 0]
                ])

    ## Corresponding Samples of CR Robot
    B_mat = np.array([
                [217.55, -125.14, 357.75],
                [228.41, 62.57, 285.33],
                [429.84, 52.60, 288.29],
                [419.30, -135.32, 361.07]
                ])

    ## Test Points
    HRP_rand1 = np.array ( [ [203.2], [0], [-4], [1] ] )
    CRP_rand1 = np.array ( [ [219.22], [-119.90], [357.06], [1] ] )

    HRP_rand2 = np.array ( [ [0], [0], [-4], [1] ] ) ## x,y,z
    CRP_rand2 = np.array ( [ [229.33], [60.44], [282.77], [1] ] )

    HRP_rand3 = np.array ( [ [0], [203.2], [-4], [1] ] )
    CRP_rand3 = np.array ( [ [426.30], [50.44], [285.63], [1] ] )

    HRP_rand4 = np.array ( [ [203.2], [203.2], [-4], [1] ] ) ## x,y,z
    CRP_rand4 = np.array ( [ [417.51], [-132.37], [356.93], [1] ] )

    HRP_rand = np.concatenate((HRP_rand1, HRP_rand2, HRP_rand3, HRP_rand4), axis=1)
    CRP_rand = np.concatenate((CRP_rand1, CRP_rand2, CRP_rand3, CRP_rand4), axis=1)
    
    return A_mat, B_mat, HRP_rand, CRP_rand

def calibrate_CR_HR():
    ###############################################
    ########## Find TF between CR and HR ##########
    ########## done by touching each robot ########
    ########## with pointy tool at 4 points #######
    ###############     in space         ##########
    ###############################################
   
    A_mat, B_mat, HRP_rand, CRP_rand = manual_robot_point_pairs()
    HRP_rand1, CRP_rand1 = HRP_rand[:,0], CRP_rand[:,0]
    HRP_rand2, CRP_rand2 = HRP_rand[:,1], CRP_rand[:,1]
    HRP_rand3, CRP_rand3 = HRP_rand[:,2], CRP_rand[:,2]
    HRP_rand4, CRP_rand4 = HRP_rand[:,3], CRP_rand[:,3]

    least_error_ids = []
    min_error = 9999

    for id1 in range(len(A_mat)):
        for id2 in range(len(A_mat)):
            for id3 in range(len(A_mat)):
                for id4 in range(len(A_mat)):
                    if id1 != id2 and id1 != id3 and id1 != id4:
                        if id2 != id3 and id2 != id4:
                            if id3 != id4:
                                curr_A =  np.array ([A_mat[id1], A_mat[id2], A_mat[id3], A_mat[id4]])
                                curr_B =  np.array ([B_mat[id1], B_mat[id2], B_mat[id3], B_mat[id4]])

                                computed_CR_T_HR = compute_calibration_mat(curr_A, curr_B)

                                error1 = np.linalg.norm (np.matmul( computed_CR_T_HR, HRP_rand1 ) - CRP_rand1 ) 
                                error2 = np.linalg.norm (np.matmul( computed_CR_T_HR, HRP_rand2 ) - CRP_rand2 )
                                error3 = np.linalg.norm (np.matmul( computed_CR_T_HR, HRP_rand3 ) - CRP_rand3 ) 
                                error4 = np.linalg.norm (np.matmul( computed_CR_T_HR, HRP_rand4 ) - CRP_rand4 )
                                # print (error1, error2, error3, error4)
                                if error1 < min_error and error2 < min_error and error3 < min_error and error4 < min_error:
                                # if error3 < min_error and error4 < min_error:
                                    min_error = min(error3, error4)
                                    least_error_ids = [id1, id2, id3, id4]
                                    print("ERROR:  ", min_error)
                                    print("IDs:  ", least_error_ids)
    final_HR_values = np.array ([A_mat[least_error_ids[0]], A_mat[least_error_ids[1]], A_mat[least_error_ids[2]], A_mat[least_error_ids[3]]])
    final_CR_values = np.array ([B_mat[least_error_ids[0]], B_mat[least_error_ids[1]], B_mat[least_error_ids[2]], B_mat[least_error_ids[3]]])
    # print(final_HR_values)
    # print(final_CR_values)
    return compute_calibration_mat(final_HR_values, final_CR_values)

def basic_trans():
    A_mat = np.array([
                [203.2,0,0],
                [0, 0, 0],
                [0, 203.2, 0 ],
                [203.2, 203.2, 0],
                [203.2,0,-4],
                [0, 0, -4],
                [0, 203.2, -4 ],
                [203.2, 203.2, -4],
                ])

    ## Corresponding Samples of CR Robot
    B_mat = np.array([
                [217.55, -125.14, 357.75],
                [228.41, 62.57, 285.33],
                [429.84, 52.60, 288.29],
                [419.30, -135.32, 361.07],
                [219.22, -119.90, 357.06],
                [229.33, 60.44, 282.77],
                [426.30, 50.44, 285.63],
                [417.51, -132.37, 356.93]                
                ])
    return compute_calibration_mat(A_mat, B_mat)    

def main():
    # CR_T_HR = calibrate_CR_HR()
    CR_T_HR = basic_trans()
    print (CR_T_HR)
    q = tf.quaternion_from_matrix(CR_T_HR)       
    print (q)
    abc = tf.euler_from_quaternion(q, axes='sxyz')
    print (abc[0]*180/math.pi, abc[1]*180/math.pi, abc[2]*180/math.pi)

if __name__ == "__main__":
    main()    