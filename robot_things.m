%Move from initial, to up, to destination
orion = Orion5();

for i = 1:3
    [start, dest] = find_start_and_end('real_photo.jpg');
    target = rob0(start(:, :, i));
    move_arm(orion, target);

    orion.SetJointPosition(5, 225);

    target = rob0(dest(:, :, i));
    target(5) = 225;
    move_arm(orion, target);

    orion.SetJointPosition(5, 300);
end