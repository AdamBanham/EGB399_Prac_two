function [ Shape ] = Circularity( blob )
%CIRCULARITY performs circularity testing to find out if a blob is a
%triangle , square or circle 
%   takes a region feature from iblobs function
%   outputs a Shapes id with values of 1 to 3 (circle , square , triangle)
circularity = (4*pi*blob.moments.m00)/blob.perimeter^2;
if circularity >= .88
    Shape = 1;
end
if (circularity < .88 && circularity > .71)
    Shape = 2;
end
if circularity < .71 
    Shape = 3;
end
