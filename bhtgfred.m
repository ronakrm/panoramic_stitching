function [ trimmed ] = trimm( mapped_images )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

img = squeeze(mapped_images(1,:,:,:));
for i=1:size(img,3)
    aver = mean(img(:,1,:));
    if(aver > 0)
        break;
    end
end

for j = 1:size(

end

