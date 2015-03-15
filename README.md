# CS 766 Panorama Creation Implementation

## Setup
Create a directory in the "inputs" with all of the images to be stitched.
Create a text file in "inputs" that contains information about the panorama, as follows:

    Line 1: local folder location
    Line 2: focal length
    Line 3: radial distortion parameter 1
    Line 4: radial distortion parameter 2
    Line 5: individual image widths
    Line 6: individual image heights
    Line 7: Boolean (1 if images form 360 viewing angle, 0 otherwise)
    Line 8: Number of images to stitch
    
  
Below is an example of such a file:

    Line 1: tilt
    Line 2: 663.3665
    Line 3: -0.19447
    Line 4: 0.23382
    Line 5: 480
    Line 6: 640
    Line 7: 0
    Line 8: 9

Finally, in Panoramer.m, add the filename of the above text file in the relevant code location as below:

    filename = 'inputs/my_panoInfo.txt';

Panoramer can then be run, and the final panorama will be displayed. MATLAB's imwrite function can be used to save out the final image.

## Radial Distortion
To ensure _excellent_ alignment when stitching the input images into a panorama, we correct for the camera's radial distortion before mapping the images to cylindrical coordinates. This process requires the focal length for the given resolution and the parameters k~1~ and k~2~ from the radial distortion function F(r) given radius r: F(r) = r(1 + k~1~r^2^ + k~2~r^4^ + ...). The use of a camera calibration toolkit can be used to obtain precise measurements for these parameters.

## Cylindrical Mapping
The real secret to creating truly beautiful panoramas is to warp each input image into cylindrical coordinates prior to attempting to properly align them. Naturally, this is what our method does. We compute the rotation theta and height h of each pixel in the image and transform the original (x,y) into a new (x',y'). This technique simplifies alignment dramatically by reducing the problem to simply "sliding" two adjacent images along the cylinder's surface, which requires only translation calculations.

## Feature Detection: SIFT
Once each image is mapped to our unit cylinder, we must align them. This requires figuring out the offset between an image and its neighbor. To do this, we use SIFT (Scale Invariant Feature Transform) features to uniquely identify key points in each image. Once these features are identified in each image, they are compared to one another. Matches are determined by determining which two features in each image explain the offset the best. Once these matches have been determined, The offset can be calculated by selecting the few matches that are most representative of the image offset, and averaging. This allows us to mitigate the issue of overfitting by potentially bad matches or matches that do not explain the most overlap.

## Homographies and Homography Mapping
To calculate the best offset from a selection of matches, we use homographies. Each match gives us a 1-to-1 correspondence between one image and another. This correspondence acts as a contraint on potential mappings between the two, and with at least 4 we can perfectly constrain this mapping. 

Homographies also allow for any potential mapping to be created from any two different perspectives. These mappings can be used to determine projections between two different spaces, reconstruct alternative views, and create overhead maps with forward-facing cameras. Below, we immplement an interesting application of homographies: inserting one image into another in the receiving image's perspective. By manually creating correspondences between both images, we constrain a homography which we then use to map the rest of the image.

![alt tag](https://raw.github.com/ronakrm/panoramic_stitching/master/homography/Lab.jpg)
![alt tag](https://raw.github.com/ronakrm/panoramic_stitching/master/homography/homography_fun.jpg)

You can see that while the homography method does put the source images into the specified destination locations, there are many image manipulation methods that may be applied following their placement to enhance the effect. Lighting plays a strong role in the "authenticity" of the image, and blending edges may make the image appear more natural.

## Alpha Blending
For panoramas, we use alpha blending to create a more seamless picture. Alpha blending entails using parts of both images to smooth out their overlap. Here, we determine the extent of the overlap, and use a progressive blending of the two images within that space. At the extremes, we use 100% of the respective image, and progressively transition across the overlap to 0%. At the midpoint of the overlap, 50% of each original image is used. The final pixel value at each point is calculated as a weighted average of the two contributions from each image. Below is an example of the significant effect that alpha blending can have.

## Drift Correction and Cropping
After the stitching and blending is complete, the final step in the panorama generation process is to correct for drift and to crop the final panoramic image. Given a 360 degree panorama, we again use SIFT and feature matching to determine the proper offset between the first and last image. Using this information, we then compute the total vertical drift between the images and crop the final image such that it seams perfectly with the first image. Finally, given this total vertical drift slope m, a simple warp of the form y = y+mx is performed on the panorama to correct for drift. The four sides are then cropped of empty pixels, and the final panorama is displayed. MATLAB's imwrite function can be used to save out the final image.
