function [target] = rob0(pos)
x = pos(1);
y = pos(2);
z = pos(3);

r = 30.309;
h = 53;
l2 = 170.384;
l3 = 136.307;
l4 = 86;
c = 40;


theta1 = atan2(y, x);

if r > x && x > 0
    %d1 = sqrt((r + x)^2 + y^2);
    d1 = sqrt((r - x)^2 + y^2);
elseif r > x && x < 0
    d1 = sqrt((r+abs(x))^2 + y^2);
elseif x > r
    d1 = sqrt((x-r)^2+y^2);
elseif x == 0
    d1 = sqrt(r^2 + y^2);
end
d2 = sqrt(d1^2 + l4^2);
thetab = acos((l2^2 - d2^2 - l3^2)/(-2*d2*l3));
thetak = (acos((d2^2 - l2^2 - l3^2)/(-2*l2*l3)));
%thetal = pi-thetab-thetak;
thetal = acos((l3^2 - d2^2 - l2^2)/(-2*d2*l2));
%thetak = pi-thetal-thetab;
thetap = acos(d1/d2);
thetaq = atan(10/d1);
disp(rad2deg(thetal));
disp(rad2deg(thetap));

theta2 = thetal + thetap - thetaq;
theta3 = thetak;

thetad = atan2(d1, l4);
theta4 = thetab + thetad;


target(1) = rad2deg(-theta1);
target(2) = rad2deg(theta2);
target(3) = rad2deg(theta3);
target(4) = rad2deg(theta4);
target(5) = 300;
%target(1) = 180 - target(1);