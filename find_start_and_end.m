function [start_vectors,end_vectors] = find_start_and_end(worksheet_address)
%FIND_START_AND_END from a taken picture this returns the start and end
%vectors for blocks for robot arm to move to and from.
%   start_vectors is the xC,yC,Zc in relation to the base frame where it
%   robot should go to pick up a object before moving to the related
%   end_vector of the same size.
start_vectors = zeros(3,1,3);
end_vectors = zeros(3,1,3);
colour_thershold = 80;
%% Process given image to find the related size and color of starting and ending blobs
imWork = imread(worksheet_address);
%dimensions of image
[rows,columns] = size(imWork);
%the desired starting and ending points will be in the top 20% of the
%picture
img_cutoff = rows*.25;
%spilt worksheet into start_end_vectors and worksheet
worksheet = imWork(img_cutoff:end,:,:);
start_end_shapes = imWork(1:img_cutoff,:,:);
%get all green shapes and red shapes from worksheet
% then clear all noise pixels , under thershold
green_shapes_w = worksheet(:,:,1) > colour_thershold;
red_shapes_w = worksheet(:,:,2) > colour_thershold;
%get all blobs dectected to work out what is small and what is large
green_blobs = iblobs(green_shapes_w,'area',[100,99999999]);
red_blobs = iblobs(red_shapes_w,'area',[100,99999999]);
%remove the background elements from blobs
green_blobs = green_blobs(1:end-1);
red_blobs = red_blobs(1:end-1);
mean_size = mean([mean(green_blobs.area),mean(red_blobs.area)])
end

