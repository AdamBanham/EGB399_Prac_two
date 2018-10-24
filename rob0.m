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
d1 = sqrt((r + x)^2 + y^2);
d2 = sqrt(d1^2 + l4^2);
thetal = acos((l3^2 - d2^2 - l2^2)/(-2*d2*l2));
thetap = atan(l4/d1);

theta2 = thetal + thetap;
thetak = (acos((d2^2 - l2^2 - l3^2)/(-2*l2*l3)));
theta3 = thetak;

thetab = acos((l2^2 - d2^2 - l3^2)/(-2*d2*l3));
thetad = atan(d1 / l4);
theta4 = thetab + thetad;


target(1) = rad2deg(-theta1);
target(2) = rad2deg(theta2);
target(3) = rad2deg(theta3);
target(4) = rad2deg(theta4);
target(5) = 300;