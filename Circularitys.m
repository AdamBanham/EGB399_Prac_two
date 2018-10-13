function [ Shapes ] = Circularitys( blobs )
%CIRCULARITY performs circularity testing to find out if a blob is a
%triangle , square or circle 
%   takes a blob structure 
%   outputs a Shapes structure with square , triangle , circle set
Shapes = struct;
%find circles
circleIndex = find(blobs.circularity > .875);
Circle = blobs(circleIndex);
%find squares
squareIndex = find((blobs.circularity < .875) & (blobs.circularity > .71) );
Square = blobs(squareIndex);
%find triangles
triIndex = find(blobs.circularity < .71 & blobs.circularity > .6);
Triangle = blobs(triIndex);
%store in return struct
Shapes.circle = Circle;
Shapes.square = Square;
Shapes.triangle = Triangle;


