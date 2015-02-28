function [ m, s, fa, fb ] = align_and_stich( mapped_images )
%align_and_stich Summary of this function goes here
%   Detailed explanation goes here

N = size(mapped_images,1);
height = size(mapped_images,2);
width = size(mapped_images,3);

pano = zeros(height*2, ...
             width*N, ...
             size(mapped_images,4));
         
pano(round(height/2.0):round(height/2.0)+height-1,1:width,:) = squeeze(mapped_images(1,:,:,:));

for i=1:N-1

    Ia = single(rgb2gray(pano));
    Ib = single(rgb2gray(squeeze(mapped_images(i+1,:,:,:))));

    [fa, da] = vl_sift(Ia);
    [fb, db] = vl_sift(Ib);

    [m, s] = vl_ubcmatch(da, db);
    
    [offsetx, offsety] = mean(fb(1:2,m(2,:)) - fa(1:2,m(1,:)));

    
end

