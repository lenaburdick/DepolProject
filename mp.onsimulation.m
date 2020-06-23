% this code is the process of motors falling on the filament

clear all
close all


NumberofMotors=3;

kOn=1;
kOff=1;
kWalk=1;

LengthofFilament=5;
NumberofMonomers=LengthofFilament+1;

MotorTrackingMatrix=zeros(NumberofMotors,4);
MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position




while find(MotorTrackingMatrix(:,4)==0)>0
    
    
    p=rand;
    
    
    FreeMotorArray=find(MotorTrackingMatrix(:,4)==0); %gives an array of the indexes of every free motor
    LandPosition=ceil(p*NumberofMonomers);
    MotorToLand=FreeMotorArray(ceil(size(FreeMotorArray,1)*p));
    MotorTrackingMatrix(MotorToLand,4)=LandPosition
    
    
    
    % Note: there is an amount of bias where lower number indexed motors
    % will fall on a lower position on the filament in general, does this
    % matter?
    
        
end