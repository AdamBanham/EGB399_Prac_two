function H = calc_hom(BlueBlobs)
    %Q = [20 380; 200 380; 380 380; 20 200; 200 200; 380 200; 20 20; 200 20; 380 20];
    %Q = [345 560;345 290;345 20;183 560;182 290;183 20;20 290;20 560;20 20];
    %Q = [346 560.5;346 290.5;346 19.5;184 560.5;184 290.5;184 19.5;20 290.5;20 560.5;20 19.5];
    %Q = [346 19.5;346 290.5;346 560.5;184 19.5;184 290.5;184 560.5;20 290.5;20 19.5;20 560.5];
    Q = [345 20;345 290;345 560;183 20;184 290;183 560;20 290;20 20;20 560];
    Pb = Q';
    
    for i = 1:length(BlueBlobs)
        %get the centroids of each blue blob
        Pb(1, i) = BlueBlobs(i).uc;
        Pb(2, i) = BlueBlobs(i).vc;
        
        %test matching blobs to Q points
%         BlueBlobs(i).plot_box('y')
%         fprintf('uc : %d , vc : %d \n',Pb(1, i),Pb(2, i))
%         disp('continue to next shape ?')
%         pause;
    end
%     i = Pb';
%     i = sortrows(i, 1);
%     
%     j = sortrows(i(4:6, 1:2), 2);
%     k = sortrows(i(7:9, 1:2), 2);
%     i = sortrows(i(1:3, 1:2), 2);
%     things = vertcat(i, j, k);
%     Pb = things';        
    H = homography(Pb, Q');
end
