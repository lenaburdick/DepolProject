
% This simply simulates the land, walking, and falling off of a system with
% multiple motors

clear all
close all


NumberofMotors=4;

kOn=1;
kOff=1;
kWalk=1;

LengthofFilament=5;
NumberofMonomers=LengthofFilament+1;

MotorTrackingMatrix=zeros(NumberofMotors,4);
MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position

MotorFellOff=0;

DT=0;
i=1;

while MotorFellOff<1
    

%----------------------------------------------------------------------

if sum(MotorTrackingMatrix(:,4)==0)>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0%If there are any free motors
        k1=kOn;
    else
        k1=0;
    end
    
    if sum(MotorTrackingMatrix(:,4)==NumberofMonomers)>0
        k2=kOff;
    else
        k2=0;
    end
    
    if sum(MotorTrackingMatrix(:,4))>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0 % should there be a condition where if there is a motor on the end this can't happen??
        k3=kWalk;
    else
        k3=0;
    end
    
    k1
    k2
    k3
    
    
    kTotal=k1+k2+k3
    
    
    %----------------------------------------------------------------------
    
    p=rand;
    DT(i)=exprnd(1/kTotal);
    
    
    
    if p<k1/kTotal
        FreeMotorArray=find(MotorTrackingMatrix(:,4)==0); %gives an array of the indexes of every free motor
        LandPosition=ceil(p*NumberofMonomers);
        MotorToLand=FreeMotorArray(ceil(size(FreeMotorArray,1)*p));
        MotorTrackingMatrix(MotorToLand,4)=LandPosition;
                % Note: there is an amount of bias where lower number indexed motors
                % will fall on a lower position on the filament in general, does this
                % matter?
        MotorTrackingMatrix(MotorToLand,3)=LandPosition;
        MotorTrackingMatrix(MotorToLand,2)=sum(DT);
    else
        if p>k1/kTotal && p<(k1+k2)/kTotal
            MotorFellOff=1;
        else
            BoundMotorArray=find(MotorTrackingMatrix(:,4)~=0);
            q=p-(k1+k2)/kTotal; %This is how far p is away from the edge of the "walk bin"
            WalkInteger=ceil(q*size(BoundMotorArray,1)*2);
            MotorToWalk=BoundMotorArray(ceil(WalkInteger/2)); %Does this make the higher indexed motors more likely to walk?

                if mod(WalkInteger,2)~=0 && MotorTrackingMatrix(MotorToWalk,4)~=1; %whether or not its even or odd
                    WalkDirection=-1;
                else
                    WalkDirection=1;
                end

        MotorTrackingMatrix(MotorToWalk,4)=MotorTrackingMatrix(MotorToWalk,4)+WalkDirection;
        end
    end 
    
    i=i+1;
    
    
    MotorTrackingMatrix
    
end

TotalTime=sum(DT);
