% This simulates the motor Walking

clear all
close all


NumberofMotors=4;

kOn=1;
kOff=1;
kWalk=1;

LengthofFilament=9;
NumberofMonomers=LengthofFilament+1;

MotorTrackingMatrix=zeros(NumberofMotors,4);
MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position

MotorTrackingMatrix(1,4)=3; %These are just used as dummy positions
MotorTrackingMatrix(2,4)=5;
MotorTrackingMatrix(4,4)=2;
IsMotorOnEnd=0;

while IsMotorOnEnd==0
p=rand;


BoundMotorArray=find(MotorTrackingMatrix(:,4)~=0);
WalkInteger=ceil(p*size(BoundMotorArray,1)*2);  %This will be different when there's multiple rates
MotorToWalk=BoundMotorArray(ceil(WalkInteger/2));

if mod(WalkInteger,2)~=0 && MotorTrackingMatrix(MotorToWalk,4)~=1; %whether or not its even or odd
   WalkDirection=-1;
else
   WalkDirection=1;
end

MotorTrackingMatrix(MotorToWalk,4)=MotorTrackingMatrix(MotorToWalk,4)+WalkDirection

if MotorTrackingMatrix(MotorToWalk,4)==NumberofMonomers
   IsMotorOnEnd=1;
end

end