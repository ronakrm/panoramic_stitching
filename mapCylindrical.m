function [ mapped ] = mapCylindrical( images, focal_length )
%mapCylindrical Map images to cylindrical coordinates
%   focal length used to determine field of view for each image, image is
%   mapped to that field of view

% get center of image for calculations
xc = size(images,3)/2;
yc = size(images,2)/2;

s = focal_length;

mapped = zeros(size(images,1),size(images,2),size(images,3),size(images,4));

fsq = focal_length*focal_length;

for y=1:size(images,2)
    for x=1:size(images,3)
        
        %calculate cylindrical coordinate for this xy-coord
        theta = atan((x - xc)/focal_length);
        h = (y - yc)/sqrt((x - xc)^2 + fsq);
        
        %get point in new image to map old xy to
        x_squiggly = round(s*theta + xc);
        y_squiggly = round(s*h + yc);

%         theta = (x - xc)/focal_length;
%         h = (y - yc)/focal_length;
%         
%         xhat = sin(theta);
%         yhat = h;
%         zhat = cos(theta);
%         
%         x_squiggly = ceil(focal_length*(xhat/zhat) + xc);
%         y_squiggly = ceil(focal_length*(yhat/zhat) + yc);
        
        mapped(:,y_squiggly,x_squiggly,:) = images(:,y,x,:);
    end
end

mapped = uint8(mapped);

end
