function [ undistorted ] = fix_distortion( images, focal_length, k1, k2 )
%fix_distortion Summary of this function goes here
%   Detailed explanation goes here

xc = size(images,3)/2;
yc = size(images,2)/2;

undistorted = zeros(size(images,1),size(images,2),size(images,3),size(images,4));

for y=1:size(images,2)
    for x=1:size(images,3)

        xn = (x-xc)/focal_length;
        yn = (y-yc)/focal_length;
        
        r = sqrt((xn)^2 + (yn)^2);
                
        xcorrected = ceil(focal_length*xn*(1 + k1*r^2 + k2*r^4)) + xc;
        ycorrected = ceil(focal_length*yn*(1 + k1*r^2 + k2*r^4)) + yc;
        
        undistorted(:,y,x,:) = images(:,ycorrected,xcorrected,:);
    end
end

end