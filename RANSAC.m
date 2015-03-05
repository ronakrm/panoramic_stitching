function [ offsetX, offsetY ] = RANSAC( fa, fb )
%RANSAC Summary of this function goes here
%   Detailed explanation goes here

P = 0.99;
p = 0.5;
n = 4;
k = log(1-P)/log(1-p^n);

N = size(fa,2);

indices = linspace(1,N,N);

max_score = -2;

for i=1:k
    subset = random('unid', N-1, 1, n);
    
    subX = mean(fa(1,subset) - fb(1,subset));
    subY = mean(fa(2,subset) - fb(2,subset));
    
    score = 0;
    
    for j=1:N
        if (size(find(subset == j),1) == 0)
            candX = fa(1,j) - fb(1,j);
            candY = fa(2,j) - fb(2,j);
            
            if (abs(candX-subX)<T && abs(candY-subY)<T)
                score = score + 1;
            end
        end
    end
    
    if (score > max_score)
        max_score = score;
        offsetX = subX;
        offsetY = subY;
    end
end


end

