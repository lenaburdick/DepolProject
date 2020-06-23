clear all
close all

NumberofRuns=100;

kOn=1;
kOff=1;
kWalk=1;

LengthofFilamentArray=[5:5:25];

NumberofMotors=5;

TotalTimeMatrix=zeros(NumberofRuns,size(LengthofFilamentArray,2)); 


for h=[1:NumberofRuns]
    
   

for i=1:size(LengthofFilamentArray,2)
    
LengthofFilament=LengthofFilamentArray(i)
    
NumberofMonomers=LengthofFilament+1;
    
MotorTrackingMatrix=zeros(NumberofMotors,4);
MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position


MotorFellOff=0;

DT=[0];

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
    
    kTotal=k1+k2+k3;
    
    
    %----------------------------------------------------------------------
    
    p=rand;
    DT=[DT exprnd(1/kTotal)];
    
    
    
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
            WalkInteger=ceil(p*size(BoundMotorArray,1)*2);
            MotorToWalk=BoundMotorArray(ceil(WalkInteger/2));

                if mod(WalkInteger,2)~=0 && MotorTrackingMatrix(MotorToWalk,4)~=1; %whether or not its even or odd
                    WalkDirection=-1;
                else
                    WalkDirection=1;
                end

        MotorTrackingMatrix(MotorToWalk,4)=MotorTrackingMatrix(MotorToWalk,4)+WalkDirection;
        end
    end 
    
    
    
    %MotorTrackingMatrix
   
    
end

TotalTime=sum(DT);
TotalTimeMatrix(h,i)=TotalTime;

end

end

NewTotalTimeMatrix=sum(TotalTimeMatrix,1);

x=LengthofFilamentArray;
y=NewTotalTimeMatrix;
plot(x,y)
