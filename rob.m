function [target] = rob(x, y, z)
    h = 53;
    r = 30.309;
    l2 = 170.384;
    l3 = 136.307;
    l4 = 86;
    c = 40;
    
    d2 = 0;
    
    if x > r
        d2 = sqrt(y^2 + (x - r)^2);
    elseif x < r && x >= 0
        d2 = sqrt(y^2 + (r - x)^2);
    elseif x < 0
        d2 = sqrt(y^2 + (r + abs(x))^2);
    end
    %d2 = y+r;
        
    alpha = l4 + c;
    d3 = sqrt(d2^2 + (alpha + z - h)^2);
    theta1 = atan2(y, x);
    theta2 = asin((alpha+z-h)/(l2));    
    i = (l2^2 + l3^2 - d3^2)/(2*l2*l3);
    while abs(i) > 1
        if i > 0
            i = i - 1;
        else
            i = i + 1;
        end
    end
    disp(i)
    theta3 = acos(i);
    disp(theta3)
    theta4 = (2*pi) - theta2 - theta3 - (pi/2);
    target = [rad2deg(theta1) rad2deg(theta2) rad2deg(theta3) rad2deg(theta4) 250];