# CS 766 Panorama Creation Implementation

## Setup
Create a directory in the "inputs" with all of the images to be stitched.
Create a text file in "inputs" that contains information about the panorama, as follows:

    Line 1: 
    Line 2: 
    Line X: 
  
Below is an example of such a file:



Finally, in Panoramer.m, add the filename of the above text file in the relevant code location as below:

    filename = 'inputs/my_panoInfo.txt';

Panoramer can then be run, and the final panorama will be displayed. MATLAB's imwrite function can be used to save out the final image.

## Radial Distortion
To ensure _excellent_ alignment when stitching the input images into a panorama, we correct for the camera's radial distortion before mapping the images to cylindrical coordinates. This process requires the focal length for the given resolution and the parameters k~1~ and k~2~ from the radial distortion function F(r) given radius r: F(r) = r(1 + k~1~r^2^ + k~2~r^4^ + ...). The use of a camera calibration toolkit can be used to obtain precise measurements for these parameters.

## Cylindrical Mapping
The real secret to creating truly beautiful panoramas is to warp each input image into cylindrical coordinates prior to attempting to properly align them. Naturally, this is what our method does. We compute the rotation theta and height h of each pixel in the image and transform the original (x,y) into a new (x',y'). This technique simplifies alignment dramatically by reducing the problem to simply "sliding" two adjacent images along the cylinder's surface, which requires only translation calculations.

## Feature Detection: SIFT


## Homographies and Homography Mapping


## Alpha Blending

## Drift Correction and Cropping
After the stitching and blending is complete, the final step in the panorama generation process is to correct for drift and to crop the final panoramic image. Given a 360 degree panorama, we again use SIFT and feature matching to determine the proper offset between the first and last image. Using this information, we then compute the total vertical drift between the images and crop the final image such that it seams perfectly with the first image. Finally, given this total vertical drift slope m, a simple warp of the form y = y+mx is performed on the panorama to correct for drift. The four sides are then cropped of empty pixels, and the final panorama is displayed. MATLAB's imwrite function can be used to save out the final image.