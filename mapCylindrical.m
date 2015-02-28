function [ mapped ] = mapCylindrical( images, focal_length )
%mapCylindrical Summary of this function goes here
%   Detailed explanation goes here
xc = 192;
yc = 256;

s = focal_length;

mapped = zeros(size(images,1),size(images,2),size(images,3),size(images,4));

fsq = focal_length*focal_length;

for y=1:size(images,2)
    for x=1:size(images,3)
        
        theta = atan((x-xc)/focal_length);
        h = (y-yc)/sqrt((x-xc)^2 + fsq);
        
        x_squiggly = round(s*theta + xc);
        y_squiggly = round(s*h + yc);
        
        mapped(:,y_squiggly,x_squiggly,:) = images(:,y,x,:);
    end
end

mapped = uint8(mapped);

end
