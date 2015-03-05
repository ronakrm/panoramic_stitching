function [ pano, offsetX, cumY, start_height ] = align_and_stitch( mapped_images )
%align_and_stitch Summary of this function goes here
%   Detailed explanation goes here

drift_multiplier = 1.2;
alpha = 0.5;

N = size(mapped_images,1);
height = size(mapped_images,2);
width = size(mapped_images,3);
pano_size = round(0.75*width*N);

start_height = round((drift_multiplier-1)*height/2.0);
start_width = 1;

pano = zeros(round(height*drift_multiplier), ...
             pano_size, ...
             size(mapped_images,4));
         
pano(start_height:start_height+height-1,start_width:width,:) = squeeze(mapped_images(1,:,:,:));

offsetX = 1;
offsetY = start_height;

for i=1:N-1
    dispp = sprintf('Aligning image %d', i);
    disp(dispp);

    scan = pano(:,offsetX:size(pano,2),:);
    prev_image = uint8(squeeze(mapped_images(i,:,:,:)));
    next_image = uint8(squeeze(mapped_images(i+1,:,:,:)));
      
    Ia = single(rgb2gray(uint8(scan)));
    Ib = single(rgb2gray(next_image));

    [fa, da] = vl_sift(Ia);
    [fb, db] = vl_sift(Ib);

    [m, s] = vl_ubcmatch(da, db, 5);
    size(m)
    figure;image(uint8(scan));
    ha = vl_plotframe(fa(:,m(1,:)));
    
    figure;image(uint8(next_image));
    hb = vl_plotframe(fb(:,m(2,:)));
    
    old_offsetX = offsetX;
    old_offsetY = offsetY;
    
    round(mean(fa(1,m(1,:)) - fb(1,m(2,:))))
    round(mean(fa(2,m(1,:)) - fb(2,m(2,:))))
    
    [offsetX, offsetY] = RANSAC(fa(:,m(1,:)), fb(:,m(2,:)))
    
    offsetX = round(offsetX) + old_offsetX;
    offsetY = round(offsetY) + 1;
    
    %offsetX = old_offsetX + round(mean(fa(1,m(1,:)) - fb(1,m(2,:))))
    %offsetY = round(mean(fa(2,m(1,:)) - fb(2,m(2,:)))) + 1
    %compute interesting pixels
    
    % paste new image into pano
    pano(offsetY:offsetY+height-1,offsetX:offsetX+width-1,:) = next_image;
    
    %[indY, indX] = find(Ib);
    %pano(indY+offsetY, indX+offsetX, :) = mapped_images(i+1, indY, indX, :);
    
    pano_startY = max(offsetY, old_offsetY);
    
    old_startX = offsetX - old_offsetX + 1;
    old_startY = max(offsetY-old_offsetY+1,1);
    
    new_startX = 1;
    new_startY = max(old_offsetY-offsetY+1, 1);
    
    scanwidth = old_offsetX + width - offsetX;
    scanheight = min(offsetY+height-old_offsetY,old_offsetY+height-offsetY);
    
    % loop over overlap and do intelligent thigns
    for x=1:scanwidth
        new_weight = 1;%((x-1)/(scanwidth-1));
        old_weight = 1 - new_weight;
        for y=1:scanheight
            old_pixel = prev_image(old_startY+y-1,old_startX+x-1,:);
            new_pixel = next_image(new_startY+y-1,new_startX+x-1,:);
            if (sum(new_pixel) == 0)
                pano(y+pano_startY-1,x+offsetX-1,:) = uint8(old_pixel);
            elseif (sum(old_pixel == 0))
                pano(y+pano_startY-1,x+offsetX-1,:) = uint8(new_pixel);    
            else
                pano(y+pano_startY-1,x+offsetX-1,:) = uint8(round(new_weight*new_pixel)) + uint8(round(old_weight*old_pixel));
            end
        end
    end
end

cumY = offsetY - start_height;