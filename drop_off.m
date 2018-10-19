function [] = drop_off(x, y, orion)
    wait = 5;
    pos = rob(x, y, 65);
    pos(5) = 220;
    
    orion.setAllJointsPosition(pos);
    pause(wait);
    pause(1);
    pos(2) = pos(2) + 30;
    pos(5) = 250;
    orion.setAllJointsPosition(pos)
    pause(wait);