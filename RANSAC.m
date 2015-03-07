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

%number of random 'restarts'
%dependent on above
k = log(1-P)/log(1-p^n)

% number of matches
N = size(fa,2);

max_score = -1;

for i=1:k
    %random sampling of n matches to create test shift
    subset = random('unid', N-1, 1, n);
    
    %test shift is average of differences between selected matches
    subX = mean(fa(1,subset) - fb(1,subset));
    subY = mean(fa(2,subset) - fb(2,subset));
    
    score = 0;
    
    %calculate score of this subset by "distance" between test shift
    %and shift of all other matches
    for j=1:N
        if (size(find(subset == j),1) == 0)
            candX = fa(1,j) - fb(1,j);
            candY = fa(2,j) - fb(2,j);
            
            if (abs(candX-subX)<T && abs(candY-subY)<T)
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


end

