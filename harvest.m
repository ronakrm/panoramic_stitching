function [ final_pano ] = harvest( pano, a, start_height, pano_end, height )
%Harvest Summary of this function goes here
%   Detailed explanation goes here

almost_pano = zeros(height, ...
             pano_end, ...
             3);
         

% column by column, shift up to correct height based on drift a
for x=1:pano_end
    to_grab = ceil(start_height+a*x);
    almost_pano(:,x,:) = pano(to_grab:to_grab+height-1,x,:);
end

final_pano = zeros(ceil(height*0.9), pano_end, 3);

final_pano(:,:,:) = almost_pano(ceil(height*0.05):floor(height*0.95),:,:);

end

