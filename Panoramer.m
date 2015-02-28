%PANORAMER Takes a set of images and makes a panorama
%   Below is panorama code. works 100% of the time all the time

%% TIMER
tic; %start stopwatch
%% Set Parameters

%% File Setup
disp('Beginning Panorama image construction from images in ./');

filename = 'inputs/testingImagesInfo.txt';

disp(filename);

% read in the input info file
%textread is depcrecated, but textscan returns a cell array and I don't
%understand them well enough to make it work
[info] = textread(filename, '%s');
direc = cell2mat(info(1));
focal_length = str2num(cell2mat(info(2)));
width = str2num(cell2mat(info(3)));
height = str2num(cell2mat(info(4)));
N = str2num(cell2mat(info(5)));

disp('Image info acquired.');

%% Read in images to MATLAB memory, set up sampling of scaled calibration points

%Initialize memory needed for all images
images = uint8(zeros(N, height, width, 3));

imagefiles = dir(strcat('inputs/',direc,'/*.jpg'));

disp('Reading images into matrix memory...');
for i = 1:N
    
    %append file directory location
    imageloc = strcat('inputs/',direc,'/',imagefiles(i).name);
    
    %read in this image
    imgmatrix = uint8(imread(char(imageloc)));
    
    %store in big images matrix
    images(i,:,:,:) = uint8(imgmatrix);

    imageloc %display most recently read-in image
end

toc %time reading in and scaling
disp('All images read into memory.');

%% Map to cylindrical projection
mapped_images = mapCylindrical(images, focal_length);
figure;image(squeeze(uint8(mapped_images(1,:,:,:))));

bigim = zeros(size(images,2),size(images,3)*N,3);
for i=1:N
    bigim(1:512,1+(384*(i-1)):384*i,:) = mapped_images(N-i+1,1:512,1:384,:);
end

figure;image(uint8(bigim));

%% Align and stitch mapped images
cylinder = align_and_stich(mapped_images);

%% Unwrap cylinder
%output = unwrap(cylinder);

%% Display final image
%image(output);