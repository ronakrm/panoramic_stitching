function [ pano ] = align_and_stich( mapped_images )
%align_and_stich Summary of this function goes here
%   Detailed explanation goes here

N = size(mapped_images,1);
height = size(mapped_images,2);
width = size(mapped_images,3);

start_height = round(height/2.0);
start_width = 1;

pano = zeros(height*2, ...
             width*N, ...
             size(mapped_images,4));
         
pano(start_height:start_height+height-1,start_width:width,:) = squeeze(mapped_images(1,:,:,:));

i=1;
%for i=1:N-1

    Ia = single(rgb2gray(uint8(pano)));
    Ib = single(rgb2gray(squeeze(mapped_images(i+1,:,:,:))));

    [fa, da] = vl_sift(Ia);
    [fb, db] = vl_sift(Ib);

    [m, s] = vl_ubcmatch(da, db, 10);
    
    offsetx = round(mean(fa(1,m(1,:)) - fb(1,m(2,:))));
    offsety = round(mean(fa(2,m(1,:)) - fb(2,m(2,:))));

    %compute interesting pixels
    indxs = find(Ib);
    pano(offsety:height-1+offsety,offsetx:width-1+offsetx,:) = squeeze(mapped_images(i+1,:,:,:));
    
%end

