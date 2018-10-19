function [target] = robot_control(x, y, z)
mm = 1*10-03;

h = 53.0*mm;
r = 30.309*mm;
l2 = 170.384*mm;
l3 = 136.307*mm;
l4 = 86.0*mm;
d = 40*mm;

x = x*mm;
y = y*mm;
z = z*mm;
alpha = l4 + d+z;

a = sqrt(h^2+y^2);
theta = atan2(h, y);
thetaj = pi/2-theta;

c = sqrt(a^2+alpha^2+2*(a*alpha)*cos(thetaj));

betatop = alpha^2 - a^2 - c^2;
betab = 2*a*c;
be = betatop/betab;
while abs(be) > 1
   if be > 0
       be = be - 1;
   else
       be = be + 1;
   end
end


beta = acos(betatop/betab);

term = (l3^2-l2^2-c^2)/(2*l2*c);
while abs(term) > 1
   if term > 0
       term = term - 1;
   else
       term = term + 1;
   end
end

w = acos(term);

term1 = (c^2-l2^2-l3^2)/(2*l2*l3);
while abs(term1) > 1
   if term1 > 0
       term1 = term1 - 1;
   else
       term1 = term1 + 1;
   end
end

theta1 = atan2(y, x);
theta2 = beta + w;
theta3 = acos(term1);
theta1 = rad2deg(theta1);
theta2 = 180 - rad2deg(theta2);
theta3 = rad2deg(theta3);
theta4 = 360 - theta2 - theta3 - thetaj;
target = [theta1, theta2, theta3, theta4, 250];
%theta4 = 50 - theta4;
