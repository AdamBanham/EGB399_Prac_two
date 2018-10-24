%Move from initial, to up, to destination

for i = 1:3

    [start, dest] = find_start_and_end('real_photo_1.jpg');
    target = rob0(start(:, :, i));
    move_arm(target);
    orion = Orion5();
    orion.setJointPosition(5, 225);
    pause(2)
    target = rob0(dest(:, :, i));
    target(5) = 225;
    orion.stop();
    pause(2)
    move_arm(target);
    
    orion = Orion5();
    orion.setJointPosition(5, 300);
    pause(2)
    orion.stop()
    pause(2)
end
