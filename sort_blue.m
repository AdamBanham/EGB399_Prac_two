function sorted_blobs = sort_blue(blobs)
%sorts a given collection of 
sorted_blobs = blobs;
%sort blobs to be in q matrix format
for i = 1:length(blobs)
    if blobs(i).uc > max(blobs.uc)*.7
        %blob is in first column which means it should be in pos 1 , 4 , 7
        if blobs(i).vc < min(blobs.vc) * 2
            sorted_blobs(1) = blobs(i);
        elseif blobs(i).vc < mean(blobs.vc) * 1.3
            sorted_blobs(4) = blobs(i);
        else
            sorted_blobs(7) = blobs(i);
        end
    elseif blobs(i).uc > mean(blobs.uc) *.7
        %blob is in second column which means it should be in pos 2 , 5 , 8
        if blobs(i).vc < min(blobs.vc) * 2
            sorted_blobs(2) = blobs(i);
        elseif blobs(i).vc < mean(blobs.vc) * 1.3
            sorted_blobs(5) = blobs(i);
        else
            sorted_blobs(8) = blobs(i);
        end        
    else
        %blob is in second column which means it should be in pos 3 , 6 , 9
        if blobs(i).vc < min(blobs.vc) * 3
            sorted_blobs(3) = blobs(i);
        elseif blobs(i).vc < mean(blobs.vc) * 1.5
            sorted_blobs(6) = blobs(i);
        else
            sorted_blobs(9) = blobs(i);
        end     
        
    end
        
    
end

end

