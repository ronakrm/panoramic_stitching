function [ undistorted ] = fix_distortion( images, focal_length, k1, k2 )
%fix_distortion undo's radial distortion caused by camera barrel
%   focal_length of camera necessary for normalization, k1 and k2
%   parameters given by camera (manufacturer)

%set center of image for radii calculations
xc = size(images,3)/2;
yc = size(images,2)/2;

%initialize memory
undistorted = zeros(size(images,1),size(images,2),size(images,3),size(images,4));

for y=1:size(images,2)
    for x=1:size(images,3)

        %normalized coordinates
        xn = (x-xc)/focal_length;
        yn = (y-yc)/focal_length;
        
        %radius to normalized point
        r = sqrt((xn)^2 + (yn)^2);
                
        %calculate old pixel to get for this pixel
        x_old = ceil(focal_length*xn*(1 + k1*r^2 + k2*r^4)) + xc;
        y_old = ceil(focal_length*yn*(1 + k1*r^2 + k2*r^4)) + yc;
        
        undistorted(:,y,x,:) = images(:,y_old,x_old,:);
    end
end

end