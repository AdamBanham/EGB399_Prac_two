function  move_arm(target)
Orion = Orion5();
%moves arm into the target position safetly 
delay = 2;
%move arm back out of the space.
Orion.setJointPosition(1,110)
pause(delay)
Orion.setJointPosition(3, -90)
pause(delay)
%move second joint to position
Orion.setJointPosition(1,target(2))
pause(delay)
%move thrid joint
Orion.setJointPosition(2,target(3))
pause(delay)

%move base
Orion.setJointPosition(0,target(1))
pause(delay)
%move the foruth joint
Orion.setJointPosition(3,target(4))
pause(delay)
Orion.stop();
end

