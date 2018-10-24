function [start_vectors,end_vectors] = find_start_and_end(worksheet_address)
%FIND_START_AND_END from a taken picture this returns the start and end
%vectors for blocks for robot arm to move to and from.
%   start_vectors is the xC,yC,Zc in relation to the base frame where it
%   robot should go to pick up a object before moving to the related
%   end_vector of the same size.
start_vectors = zeros(3,1,3);
end_vectors = zeros(3,1,3);
colour_thershold = .7;
robot_frame_x = 100;
robot_frame_y = 290;
block_height = 53;
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

%% Create Homography matrix to find real world measurements
%find blue blobs on the worksheet
blue_blobs = iblobs(Chrome_Img(:,:,3)>colour_thershold,'boundary','area',[50,10000]);
idisp(worksheet)
% for i = 1:length(blue_blobs)
%     blue_blobs(i).plot_box('r')
%     pause
% end
%work out homography matrix
[uc_max,vc_max,~] = size(worksheet);
disp(uc_max)
disp(vc_max)
pause;
H = calc_hom(blue_blobs,uc_max,vc_max);
%% Create table results about desired start and end shapes
%Start points
shape_counter = 1;
sort_uc = sort(desired.start.uc);
for idx = 1:length(desired.start)
   disp('*------------------------------*')
   shape = desired.start(desired.start.uc == sort_uc(shape_counter));
   idisp(start_end_shapes);
   fprintf('start point shape: %d\n',shape_counter)
   %print the shape
   switch (Circularity(shape))
       case 1
           fprintf('SHAPE : circle\n')
       case 2
           fprintf('SHAPE : square\n')
       case 3
           fprintf('SHAPE : triangle\n')
   end
   %print the colour
   for red = desired.red(desired.red.uc < columns*.5)
       if (shape.uc == red.uc)
            fprintf('COLOUR : red\n')
            %find the corsponding worksheet shape
            for work_shape = red_blobs
                if abs(work_shape.area - shape.area) < 2000
                    if Circularity(work_shape) == Circularity(shape)
                         worksheet_shape = work_shape;
                    end
                end
           end
        end
   end
   for green = desired.green(desired.green.uc < columns*.5)
       if (shape.uc == green.uc)
           fprintf('COLOUR : green\n')
           %find the corsponding worksheet shape
           for work_shape = green_blobs
                if abs(work_shape.area - shape.area) < 2000
                    if Circularity(work_shape) == Circularity(shape)
                         worksheet_shape = work_shape;
                    end
                end
           end
       end
   end
   %print the size
   if shape.area > mean_size(Circularity(shape))
      fprintf('SIZE : large\n')
   else
       fprintf('SIZE : small\n')
   end
   %print the real world coordinates
   p = [worksheet_shape.uc worksheet_shape.vc];
   disp(p')
   disp(H);
   q = homtrans(H,p');
   fprintf('real world coordinates (x,y) : %fmm , %fmm', q(1) , q(2))
   %plot box and move to next line
   fprintf('\n')
   shape.plot_box('y')
   %store in end vector with respect to the robot work frame
   start_vectors(1,1,shape_counter) = (q(2)-robot_frame_y)*.9;
   start_vectors(2,1,shape_counter) = (q(1)-robot_frame_x)*.9;
   start_vectors(3,1,shape_counter) = block_height;
   fprintf('In relation to robot frame, real world coordinates (x,y) : %fmm , %fmm\n', ...
       start_vectors(1,1,shape_counter),...
       start_vectors(2,1,shape_counter) )  
   disp('*------------------------------*')
   pause;
   shape_counter = shape_counter+1;
end

%% Destination points
sort_uc = sort(desired.end.uc);
for idx = 1:length(desired.start)
   disp('*------------------------------*')
   shape = desired.end(desired.end.uc == sort_uc(shape_counter-3));
   idisp(start_end_shapes);
   fprintf('finish point shape: %d \n',shape_counter-3)
   %print the shape
   switch (Circularity(shape))
       case 1
           fprintf('SHAPE : circle\n')
       case 2
           fprintf('SHAPE : square\n')
       case 3
           fprintf('SHAPE : triangle\n')
   end   
   %print the colour
   for red = desired.red(desired.red.uc > columns*.5)
       if (shape.uc == red.uc)
            fprintf('COLOUR : red\n')
            %find the corsponding worksheet shape
            for work_shape = red_blobs
                if abs(work_shape.area - shape.area) < 2000
                    if Circularity(work_shape) == Circularity(shape)
                         worksheet_shape = work_shape;
                    end
                end
            end        
       end
   end
   for green = desired.green(desired.green.uc > columns*.5)
       if (shape.uc == green.uc)
           fprintf('COLOUR : green\n')
           %find the corsponding worksheet shape
           for work_shape = green_blobs
                if abs(work_shape.area - shape.area) < 2000
                    if Circularity(work_shape) == Circularity(shape)
                         worksheet_shape = work_shape;
                    end
                end
           end
       end
   end
   %print the size
   if shape.area > mean_size(Circularity(shape))
      fprintf('SIZE : large\n')
   else
       fprintf('SIZE : small\n')
   end
   %print the real world coordinates
   p = [worksheet_shape.uc worksheet_shape.vc];
   q = homtrans(H,p');
   fprintf('real world coordinates (x,y) : %fmm , %fmm', q(1) , q(2))
   %plot box and move to next line
   fprintf('\n')
   shape.plot_box('y')
   %store in end vector with respect to the robot work frame
   end_vectors(1,1,shape_counter-3) = (q(2)-robot_frame_y)*.9;
   end_vectors(2,1,shape_counter-3) = (q(1)-robot_frame_x)*.9;
%   end_vectors(1,1,shape_counter-3)=  (end_vectors(1,1,shape_counter-3)) - 20;
%    if(end_vectors(1,1,shape_counter-3)) > 0 
%        (end_vectors(1,1,shape_counter-3))=  (end_vectors(1,1,shape_counter-3)) + 20
%    elseif((end_vectors(1,1,shape_counter-3)) <0
%        
%    end
   end_vectors(3,1,shape_counter-3) = block_height;
   fprintf('In relation to robot frame, real world coordinates (x,y) : %fmm , %fmm\n', ...
       end_vectors(1,1,shape_counter-3),...
       end_vectors(2,1,shape_counter-3) ) 
   disp('*------------------------------*')
   shape_counter = shape_counter+1;
   pause;
end
end_vectors(2,:,:) = end_vectors(2,:,:) * -1;
start_vectors(2,:,:) = start_vectors(2,:,:) *-1;
end

