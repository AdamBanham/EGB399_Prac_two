function  move_arm(Orion,target)
%moves arm into the target position safetly 
delay = 1;
%move arm back out of the space.
Orion.setJointPosition(2,180)
pause(delay)
%move base
Orion.setJointPosition(1,target(1))
pause(delay)
%move thrid joint
Orion.setJointPosition(3,target(3))
pause(delay)
%move the foruth joint
Orion.setJointPosition(4,target(4))
pause(delay)
%move second joint to position
Orion.setJointPosition(2,target(2))
pause(delay)
end

