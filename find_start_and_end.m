function [start_vectors,end_vectors] = find_start_and_end(worksheet_address)
%FIND_START_AND_END from a taken picture this returns the start and end
%vectors for blocks for robot arm to move to and from.
%   start_vectors is the xC,yC,Zc in relation to the base frame where it
%   robot should go to pick up a object before moving to the related
%   end_vector of the same size.
start_vectors = zeros(3,1,3);
end_vectors = zeros(3,1,3);
colour_thershold = .7;
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
green_blobs = iblobs(Chrome_Img(:,:,1)>colour_thershold,'area',[50,10000],'connect',8);
red_blobs = iblobs(Chrome_Img(:,:,2)>colour_thershold,'area',[50,10000],'connect',8);
%remove the background elements from blobs
% green_blobs = green_blobs;
% red_blobs = red_blobs;
mean_size_r = mean(red_blobs.area);
mean_size_g = mean(green_blobs.area);
mean_size = ((mean_size_r+mean_size_g)/2)*.8;

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
desired.green = iblobs(Chrome_start_shapes(:,:,2)>colour_thershold,'boundary','connect',8,'area',[50,10000]);  
desired.red = iblobs(Chrome_start_shapes(:,:,1)>colour_thershold,'boundary','connect',8,'area',[50,10000]);
idisp(Chrome_start_shapes(:,:,1));
desired.green.plot_box('g')
desired.red.plot_box('r')
disp('contiue with shape dectection')
pause;
desired.shapeG.large = desired.green(desired.green.area >= mean_size);
desired.shapeR.large = desired.red(desired.red.area >= mean_size);
idisp(Chrome_start_shapes(:,:,1));
desired.shapeG.large.plot_box('g');
desired.shapeR.large.plot_box('r');

%% spilt into start and end blobs 

desired.start = desired.red(desired.red.uc < columns*.5);
temp_regions = desired.green(desired.green.uc < columns*.5);
desired.start(end+1:end+length(temp_regions)) = temp_regions;

desired.end = desired.green(desired.green.uc > columns*.5);
temp_regions = desired.red(desired.red.uc > columns*.5);
desired.end(end+1:end+length(temp_regions)) = temp_regions;

idisp(Chrome_start_shapes);
desired.start.plot_box('r');
desired.start(desired.start.uc == min(desired.start.uc)).plot_box('y');

desired.end.plot_box('g');
desired.end(desired.end.uc == min(desired.end.uc)).plot_box('y');

%% split out table for starting and ending vectors
shape_counter = 1;
sort_uc = sort(desired.start.uc);
for idx = 1:length(desired.start)
   shape = desired.start(desired.start.uc == sort_uc(shape_counter));
   idisp(Chrome_start_shapes);
   fprintf('start point shape:%d , ',shape_counter)
   for red = desired.red(desired.red.uc < columns*.5)
    if (shape.uc == red.uc)
        fprintf('colour : red, ')
    end
   end
   for green = desired.green(desired.green.uc < columns*.5)
       if (shape.uc == green.uc)
        fprintf('colour : green, ')
       end
   end
   if shape.area > mean_size
      fprintf('size : large, ')
   else
       fprintf('size : small,')
   end
   
   fprintf('\n')
   shape_counter = shape_counter+1;
   shape.plot_box('y')
   pause;
end
sort_uc = sort(desired.end.uc);
for idx = 1:length(desired.start)
   shape = desired.end(desired.end.uc == sort_uc(shape_counter-3));
   idisp(Chrome_start_shapes);
   fprintf('finish point shape:%d , ',shape_counter-3)
   for red = desired.red(desired.red.uc > columns*.5)
    if (shape.uc == red.uc)
        fprintf('colour : red, ')
    end
   end
   for green = desired.green(desired.green.uc > columns*.5)
       if (shape.uc == green.uc)
        fprintf('colour : green, ')
       end
   end
   if shape.area > mean_size
      fprintf('size : large, ')
   else
       fprintf('size : small,')
   end
   
   fprintf('\n')
   shape_counter = shape_counter+1;
   shape.plot_box('y')
   pause;
end
end

