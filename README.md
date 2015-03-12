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


## Cylindrical Mapping


## Feature Detection: SIFT


## Homographies and Homography Mapping


## Alpha Blending

## Drift Correction and Cropping
