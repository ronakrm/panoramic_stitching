function [ homography ] = calc_homography( fa, fb )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%init homography
homography = zeros(3);
homography(3,3) = 1;

A = zeros(3*size(fa,2), 8);

%fa is target coordinate frame
b = zeros(3*size(fa,2),1);

for i=1:size(fa,2)
    A(3*(i-1)+1,1) = fb(1,i);
    A(3*(i-1)+1,2) = fb(2,i);
    A(3*(i-1)+1,3) = 1;

    A(3*(i-1)+2,4) = fb(1,i);
    A(3*(i-1)+2,5) = fb(2,i);
    A(3*(i-1)+2,6) = 1;

    A(3*(i-1)+3,7) = fb(1,i);
    A(3*(i-1)+3,8) = fb(2,i);
    
    b(3*(i-1)+1) = fa(1,i);
    b(3*(i-1)+2) = fa(2,i);
    b(3*(i-1)+3) = 1;
end

ht = A\b;

homography(1,:) = ht(1:3);
homography(2,:) = ht(4:6);
homography(3,1:2) = ht(7:8);

end

