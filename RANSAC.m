function [ offsetX, offsetY ] = RANSAC( fa, fb )
%RANSAC Computes best shift between two image feature matches
%   fa and fb are the SIFT features that matched the given threshold
%   fa(x) should be the feature that matched fb(x)

%confidence desired for best shift
P = 0.9999;
%measure of 'badness' of outliers
p = 0.5;
%number of matches to create test shift
n = 4;

%threshold for inlier
T = 0.8;

%number of random 'restarts'
%dependent on above
k = log(1-P)/log(1-p^n);

% number of matches
N = size(fa,2);

max_score = -1;

warning('off','MATLAB:rankDeficientMatrix');

for i=1:k
    %random sampling of n matches to create test shift
    subset = random('unid', N-1, 1, n);
    
    h = calc_homography(fa(1:2,subset), fb(1:2,subset));
    
    subX = h(1,3);
    subY = h(2,3);
    
    %test shift is average of differences between selected matches
    %subX = mean(fa(1,subset) - fb(1,subset));
    %subY = mean(fa(2,subset) - fb(2,subset));
    
    score = 0;
    
    %calculate score of this subset by "distance" between test shift
    %and shift of all other matches
    for j=1:N
        if (size(find(subset == j),2) == 0)
            thang = ones(3,1);
            thang(1) = fb(1,j);
            thang(2) = fb(2,j);
            
            cand = h*thang;
            candX = cand(1);%/cand(3);
            candY = cand(2);%/cand(3);
            
            if (abs(candX-fa(1,j))< T && abs(candY-fa(2,j))< T)
                score = score + 1;
            end
        end
    end
    
    %update best shift if score is better than last
    if (score > max_score)
        max_score = score;
        offsetX = subX;
        offsetY = subY;
    end
end


warning('on','MATLAB:rankDeficientMatrix');

end