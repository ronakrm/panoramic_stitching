function [ pano, offsetX, cumY, start_height ] = align_and_stitch( mapped_images )
%align_and_stitch Summary of this function goes here
%   Detailed explanation goes here

alpha = 0.5;

N = size(mapped_images,1);
height = size(mapped_images,2);
width = size(mapped_images,3);

start_height = round(height/2.0);
start_width = 1;

pano = zeros(height*2, ...
             width*N, ...
             size(mapped_images,4));
         
pano(start_height:start_height+height-1,start_width:width,:) = squeeze(mapped_images(1,:,:,:));

% TODO off by 1 
offsetX = 1;
offsetY = 1;
cumY = offsetY;

for i=1:N-1
    dispp = sprintf('Aligning image %d', i);
    disp(dispp);
    
    scan = pano(:,offsetX:size(pano,2),:);
    
    Ia = single(rgb2gray(uint8(scan)));
    Ib = single(rgb2gray(squeeze(mapped_images(i+1,:,:,:))));

    [fa, da] = vl_sift(Ia);
    [fb, db] = vl_sift(Ib);

    [m, s] = vl_ubcmatch(da, db, 10);
    
    offsetX = offsetX + round(mean(fa(1,m(1,:)) - fb(1,m(2,:))));
    offsetY = round(mean(fa(2,m(1,:)) - fb(2,m(2,:))));
    %compute interesting pixels
    
    %[indY, indX] = find(Ib);
    %pano(indY+offsetY, indX+offsetX, :) = mapped_images(i+1, indY, indX, :);
    
    for y=1:height
        for x=1:width
            pixel = squeeze(mapped_images(i+1,y,x,:));
            if (sum(pixel) ~= 0)
                pano(y+offsetY,x+offsetX,:) = uint8(round(alpha*pixel)) + uint8(squeeze(round((1-alpha)*pano(y+offsetY,x+offsetX,:))));
            end
        end
    end
end

cumY = offsetY - start_height;