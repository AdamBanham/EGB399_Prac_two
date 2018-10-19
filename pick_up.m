function pos2 = pick_up(x, y, orion)
    wait = 5;
    pos = rob(x, y, 90);    
    pos
    orion.setAllJointsPosition(pos);
    pause(1);
    pos(5) = 220;
    orion.setAllJointsPosition(pos);
    pause(wait);
    pos2 = rob(x, y, 90);
    pos2(5) = 220;
    orion.setAllJointsPosition(pos2);
    pause(wait);
