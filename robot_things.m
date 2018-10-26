%Move from initial, to up, to destination
%[start, dest] = find_start_and_end('prac_pic.jpg');
%start = [180 135 53; 100 -10 53; -100 80 53];
start(:, :, 1) = [129 -30 43];
start(:, :, 2) = [98 98 43];
start(:, :, 3) = [21 166 43];

dest(:, :, 1) = [-130 -45 43]';
dest(:, :, 2) = [-101 68 43]';
dest(:, :, 3) = [-80 -102 43]';
resting = [90 90 180 180 300];
for i = 1:3
    orion = Orion5();
    orion.setJointPosition(4, 300);
    %if x < 0
    %calculate vector from origin to end effector
    %translate 
    target = rob0(start(:, :, i));
    orion.stop()
    move_arm(target);
    orion = Orion5();
    orion.setJointPosition(4, 210);
    pause(2);
    target = rob0(dest(:, :, i));
    target(5) = 210;
    orion.stop();
    pause(4)
    move_arm(target);
    orion = Orion5();
    orion.setJointPosition(4, 300);
    pause(2)
    orion.stop()
    pause(4)
    move_arm(resting);
    orion.stop()
    pause(4)    
    pause;
    
end
