function [start_vectors,end_vectors] = find_start_and_end(worksheet_address)
%FIND_START_AND_END from a taken picture this returns the start and end
%vectors for blocks for robot arm to move to and from.
%   start_vectors is the xC,yC,Zc in relation to the base frame where it
%   robot should go to pick up a object before moving to the related
%   end_vector of the same size.
start_vectors = zeros(3,1,3);
end_vectors = zeros(3,1,3);
colour_thershold = .8;
%% Process given image to find the related size and color of starting and ending blobs
imWork = imread(worksheet_address);
%dimensions of image
[rows,columns] = size(imWork(:,:,1));
%the desired starting and ending points will be in the top 20% of the
%picture
img_cutoff = rows*.25;
%spilt worksheet into start_end_vectors and worksheet
worksheet = imWork(img_cutoff:end,:,:);
start_end_shapes = imWork(1:img_cutoff,:,:);
%get all green shapes and red shapes from worksheet
% then clear all noise pixels , under thershold
Chrome_Img = Chromactiy( worksheet , colour_thershold );
%get all blobs dectected to work out what is small and what is large
green_blobs = iblobs(Chrome_Img(:,:,1),'area',[50,100000]);
red_blobs = iblobs(Chrome_Img(:,:,2),'area',[50,100000]);
%remove the background elements from blobs
green_blobs = green_blobs;
red_blobs = red_blobs;
mean_size_r = mean(red_blobs.area)*.8
mean_size_g = mean(green_blobs.area)*.8
mean_size = (mean_size_r+mean_size_g)/2;

%% test section A - check that shapes are only detected
idisp(Chrome_Img(:,:,1))
green_blobs.plot_box('g')
disp('contiue to red')
pause;
idisp(Chrome_Img(:,:,2))
red_blobs.plot_box('r')
disp('continue to size detection?')
pause;
%detect only large sized shapes
idisp(Chrome_Img(:,:,1))
green_blobs(green_blobs.area >  mean_size).plot_box('g')
disp('contiue to red')
pause;
idisp(Chrome_Img(:,:,2))
red_blobs(red_blobs.area > mean_size).plot_box('r')
disp('contiue to desired shapes')
pause;
%% find similar shapes and store choices
Chrome_start_shapes = Chromactiy( start_end_shapes , colour_thershold );
desired.green = iblobs(Chrome_start_shapes(:,:,1),'area',[50,100000],'boundary','connect',8);  
desired.red = iblobs(Chrome_start_shapes(:,:,2),'area',[50,100000],'boundary','connect',8);
idisp(Chrome_start_shapes(:,:,1))
desired.green.plot_box('g')
desired.red.plot_box('r')
disp('contiue with shape dectection')
pause;
desired.shapeG.large = desired.green(desired.green.area >= mean_size);
desired.shapeR.large = desired.red(desired.red.area >= mean_size);
idisp(Chrome_start_shapes(:,:,1))
desired.shapeG.large.plot_box('g')
desired.shapeR.large.plot_box('r')
end

