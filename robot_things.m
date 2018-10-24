%Move from initial, to up, to destination
[start, dest] = find_start_and_end('real_photo_1.jpg');

for i = 1:3

    target = rob0(start(:, :, i));
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
