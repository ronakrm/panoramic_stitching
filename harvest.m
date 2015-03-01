function [ final_pano ] = harvest( pano, a, start_height, pano_end, height )
%Harvest Summary of this function goes here
%   Detailed explanation goes here

final_pano = zeros(height, ...
             pano_end, ...
             3);
         


for x=1:pano_end
    x
    to_grab = round(start_height+a*x)
    final_pano(:,x,:) = pano(to_grab:to_grab+height-1,x,:);
end



%final_pano(:,:,:) = pano(start_width:pano_end,start_height+a*(start_width:pano_end),:);



end

