%PANORAMER Takes a set of images and makes a panorama
%   Below is panorama code. works 100% of the time all the time

%% Import SIFT things
run('../vlfeat-0.9.20/toolbox/vl_setup');

%% TIMER
tic; %start stopwatch
%% Set Parameters
filename = 'inputs/tiltInfo.txt';
%filename = 'inputs/bestInfo.txt';
%filename = 'inputs/BBInfo.txt';
%filename = 'inputs/testingImagesInfo.txt';

%% File Setup
disp('Beginning Panorama image construction from images in ./');
disp(filename);

% read in the input info file
%textread is depcrecated, but textscan returns a cell array and I don't
%understand them well enough to make it work
[info] = textread(filename, '%s');
direc = cell2mat(info(1));
focal_length = str2num(cell2mat(info(2)));
k1 = str2num(cell2mat(info(3)));
k2 = str2num(cell2mat(info(4)));
width = str2num(cell2mat(info(5)));
height = str2num(cell2mat(info(6)));
is360 = str2num(cell2mat(info(7)));
N = str2num(cell2mat(info(8)));

disp('Image info acquired.');

%% Read in images to MATLAB memory

%Initialize memory needed for all images
images = uint8(zeros(N, height, width, 3));

imagefiles = dir(strcat('inputs/',direc,'/*.JPG'));

disp('Reading images into matrix memory...');
for i = 1:N
    
    %append file directory location
    imageloc = strcat('inputs/',direc,'/',imagefiles(i).name);
    
    %read in this image
    imgmatrix = uint8(imread(char(imageloc)));
    
    %store in big images matrix
    images(N-i+1,:,:,:) = uint8(imgmatrix);

    imageloc %display most recently read-in image
end

toc %time reading in and scaling
disp('All images read into memory.');

%% Fix radial distortion
undistorted = fix_distortion(images, focal_length, k1, k2);

%% Map to cylindrical projection
disp('Mapping images to cylinder.');
mapped_images = mapCylindrical(undistorted, focal_length);
%figure;image(squeeze(uint8(mapped_images(1,:,:,:))));

%% Align and stitch mapped images
disp('Aligning and stitching images.');
[pano, offsetX, cumY, start_height] = align_and_stitch(mapped_images);
figure; image(uint8(pano));

%% Get drift
[a, pano_end] = get_drift(mapped_images, offsetX, cumY, is360);

%% Crop and Correct Drift
final_pano = harvest(pano, a, start_height, pano_end, size(mapped_images,2));

%% Display final image
figure; image(uint8(final_pano));
