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
green_blobs = iblobs(Chrome_Img(:,:,1)>colour_thershold,'area',[50,10000],'boundary');
red_blobs = iblobs(Chrome_Img(:,:,2)>colour_thershold,'area',[50,10000],'boundary');
%remove the background elements from blobs
% green_blobs = green_blobs;
% red_blobs = red_blobs;
mean_size = [1,2,3] ;
shapes = Circularitys(iblobs( ((Chrome_Img(:,:,1)>colour_thershold)+Chrome_Img(:,:,2)>colour_thershold),...
                             'area',[50,10000],'boundary'));
mean_size(1) = mean(shapes.circle.area);
mean_size(2) = mean(shapes.square.area);
mean_size(3) = mean(shapes.triangle.area);

%% test section A - check that shapes are only detected
% idisp(Chrome_Img(:,:,2))
% green_blobs.plot_box('g')
% disp('contiue to red')
% pause;
% idisp(Chrome_Img(:,:,1))
% red_blobs.plot_box('r')
% disp('continue to size detection?')
% pause;
% %detect only large sized shapes
% idisp(Chrome_Img(:,:,1))
% for blob = green_blobs
%     if blob.area > mean_size(Circularity(blob))
%         blob.plot_box('g')
%     end
% end
% disp('contiue to red')
% pause;
% idisp(Chrome_Img(:,:,2))
% for blob = red_blobs
%     if blob.area > mean_size(Circularity(blob))
%         blob.plot_box('r')
%     end
% end
% disp('contiue to desired shapes')
% pause;
%% find similar shapes and store choices
Chrome_start_shapes = Chromactiy( start_end_shapes , colour_thershold );
desired.green = iblobs(Chrome_start_shapes(:,:,1)>colour_thershold,'boundary','area',[50,10000]);  
desired.red = iblobs(Chrome_start_shapes(:,:,2)>colour_thershold,'boundary','area',[50,10000]);

%% Test section B - check sizing detection works
% idisp(start_end_shapes);
% desired.green.plot_box('g')
% desired.red.plot_box('r')
% disp('contiue with shape dectection')
% pause;
% idisp(start_end_shapes);
% disp('displaying large shapes')
% for blob = desired.green
%     if blob.area > mean_size(Circularity(blob))
%         blob.plot_box('y')
%     end
% end
% for blob = desired.red
%     if blob.area > mean_size(Circularity(blob))
%         blob.plot_box('y')
%     end
% end
% disp('continue to matching testing?')
% pause;
%% spilt into start and end blobs 
desired.start = desired.red(desired.red.uc < columns*.5);
temp_regions = desired.green(desired.green.uc < columns*.5);
desired.start(end+1:end+length(temp_regions)) = temp_regions;

desired.end = desired.green(desired.green.uc > columns*.5);
temp_regions = desired.red(desired.red.uc > columns*.5);
desired.end(end+1:end+length(temp_regions)) = temp_regions;
%% Test Section C - can we find the order of shapes correctly 
% matching start 1 to  end 1
% idisp(start_end_shapes);
% desired.start.plot_box('r');
% desired.start(desired.start.uc == min(desired.start.uc)).plot_box('y');
% 
% desired.end.plot_box('g');
% desired.end(desired.end.uc == min(desired.end.uc)).plot_box('y');
% disp('showing start 1 matched with end 1')
% disp('continue to table?')
% pause;
%% Create table results about desired start and end shapes
shape_counter = 1;
sort_uc = sort(desired.start.uc);
for idx = 1:length(desired.start)
   shape = desired.start(desired.start.uc == sort_uc(shape_counter));
   idisp(start_end_shapes);
   fprintf('start point shape:%d , ',shape_counter)
   %print the shape
   switch (Circularity(shape))
       case 1
           fprintf('shape : circle, ')
       case 2
           fprintf('shape : square, ')
       case 3
           fprintf('shape : triangle, ')
   end
   %print the colour
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
   %print the size
   if shape.area > mean_size(Circularity(shape))
      fprintf('size : large, ')
   else
       fprintf('size : small,')
   end
   %plot box and move to next line
   fprintf('\n')
   shape_counter = shape_counter+1;
   shape.plot_box('y')
   pause;
end
sort_uc = sort(desired.end.uc);
for idx = 1:length(desired.start)
   shape = desired.end(desired.end.uc == sort_uc(shape_counter-3));
   idisp(start_end_shapes);
   fprintf('finish point shape:%d , ',shape_counter-3)
   %print the shape
   switch (Circularity(shape))
       case 1
           fprintf('shape : circle, ')
       case 2
           fprintf('shape : square, ')
       case 3
           fprintf('shape : circle, ')
   end   
   %print the colour
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
   %print the size
   if shape.area > mean_size(Circularity(shape))
      fprintf('size : large, ')
   else
       fprintf('size : small,')
   end
   
   %plot box and move to next line
   fprintf('\n')
   shape_counter = shape_counter+1;
   shape.plot_box('y')
   pause;
end
end

