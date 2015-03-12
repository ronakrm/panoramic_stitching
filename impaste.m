%IMPASTE put image in other image
%   Below is panorama code. works 100% of the time all the time

%% Set Parameters
filename = 'impasteInfo.txt';

%% File Setup
disp(filename);

% read in the input info file
%textread is depcrecated, but textscan returns a cell array and I don't
%understand them well enough to make it work
[info] = textread(filename, '%s');

destfile = cell2mat(info(1));
destwidth = str2num(cell2mat(info(2)));
destheight = str2num(cell2mat(info(3)));

sourcefile = cell2mat(info(4));
sourcewidth = str2num(cell2mat(info(5)));
sourceheight = str2num(cell2mat(info(6)));

numwindows = str2num(cell2mat(info(7)));

windows = zeros(2, 4, numwindows);

headercnt = 7;

for i=0:numwindows-1
   for j=0:3
       
       windowline = headercnt+i*8+1;
       
       windows(1,j+1,i+1) = str2num(cell2mat(info(windowline+2*j)));
       windows(2,j+1,i+1) = str2num(cell2mat(info(windowline+2*j+1)));
   end
end
    
disp('Image info acquired.');

%% Read in images to MATLAB memory

source = uint8(imread(char(sourcefile)));
dest = uint8(imread(char(destfile)));

%% Homographize

output = uint8(zeros(destheight, destwidth, 3));
output = dest;

for i=1:numwindows
    
    theMap = containers.Map('KeyType', 'int64', 'ValueType', 'any');
        
    infos = zeros(5,1);
   
    %setup matrix for source
    sourcepts = [1, sourcewidth, 1, sourcewidth; 1, 1, sourceheight, sourceheight];
    
    h = calc_homography(windows(:,:,i), sourcepts);
    
    tic;
    for y=1:sourceheight
        for x=1:sourcewidth
            loc = h*[x;y;1];
            
            locX = ceil(loc(1));%/loc(3));
            locY = ceil(loc(2));%/loc(3));
            
            infos = {source(y,x,1), source(y,x,2), source(y,x,3)};
            
            thekey = (locY-1)*sourcewidth + locX;
            
            if isKey(theMap, thekey) % we have used this key before
                   % concatenate the entry
                   current = theMap(thekey);
                   entries = size(current,1);
                   
                   current(entries+1,1:3) = infos;
                   theMap(thekey) = current;                   
            
            else % this is a new key
                theMap(locX) = infos;
            end
        end
        disp(y);
    end
    
    toc;
    tic;
        for j = 1:size(theMap.keys,2)
           % get our maps
           key = theMap.keys(j);
           
           %get our pixelssss
           values = theMap(key);
                
           meann = uint8(ceil(mean(cell2mat(r))));
           
           x = mod(key, sourcewidth);
           y = ceil(key/sourcewidth);
           output(y,x,:) = meann;
       end
    toc;
end

%% Display final image
figure; image(uint8(output));