function [ a, pano_end ] = get_drift( mapped_images, offsetX, cumY )
%get_drift Summary of this function goes here
%   Detailed explanation goes here

N = size(mapped_images, 1);

Ia = single(rgb2gray(squeeze(mapped_images(N,:,:,:))));
Ib = single(rgb2gray(squeeze(mapped_images(1,:,:,:))));

[fa, da] = vl_sift(Ia);
[fb, db] = vl_sift(Ib);

[m, s] = vl_ubcmatch(da, db, 10);

pano_end = offsetX + round(mean(fa(1,m(1,:)) - fb(1,m(2,:))))
cumY = cumY + round(mean(fa(2,m(1,:)) - fb(2,m(2,:))))

a = cumY/pano_end;


end

