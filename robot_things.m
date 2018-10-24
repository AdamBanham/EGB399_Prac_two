%Move from initial, to up, to destination
[start, dest] = find_start_and_end('real_photo_2.jpg');
%start = [180 135 53; 100 -10 53; -100 80 53];
%start(:, :, 1) = [110 -50 43];
%start(:, :, 2) = [185 160 43];
%start(:, :, 3) = [-225 -60 43];

%dest(:, :, 1) = [-40 150 43]';
%dest(:, :, 2) = [100 100 43]';
%dest(:, :, 3) = [-80 120 43]';
for i = 1:3
    orion = Orion5();
    orion.setJointPosition(4, 300);
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
end
