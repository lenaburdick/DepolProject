



NumberofMotors=10;
NumberofRuns=10;

kOn=1;
kOff=1;
kWalk=1;

LengthofFilament=10
NumberofMonomers=LengthofFilament+1

MotorTrackingMatrix=zeros(NumberofMotors,4);
MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position

MotorFellOff=0

while MotorFellOff<1
    
    
    %~~~Setting the Rates~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if sum(MotorTrackingMatrix(:,4)==0)>0 %If there are any free motors
        k1=kOn;
    else
        k1=0
    end
    
    if sum(MotorTrackingMatrix(:,4)==NumberofMonomers)>0
        k2=kOff
    else
        k2=0
    end
    
    if sum(MotorTrackingMatrix(:,4))>0 % should there be a condition where if there is a motor on the end this can't happen??
        k3=kWalk
    else
        k3=0
    end
    
    kTotal=k1+k2+k3;
    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    p=rand;
    
    %~~~Landing, Walking, and Falling off simulation~~~~~~~~~~~~~~~~~~~~~~
    
    if p<k1/kTotal %Motor Landing
        LandInteger=kTotal-(k2+k3); %this is the length from 0 to k1
        FreeMotorsArray=find(MotorTrackingMatrix(:,4)==0); %gives an array of the indexes of every free motor
        LandIntegersSize=(LandInteger/(size(FreeMotorsArray,1)*NumberofMonomers));
        LandPositionIntegers=[0:LandIntegersSize:k1]; %an array that divides the land integer into one section for each position and each potential monomer it could fall on
        dist=abs(LandPositionIntegers-p); %How far is each integer from p
        minDist=min(dist); %finds the integer with the smallest distance to p (what section op falls in)
        WhichLandInteger=find(dist==minDist);
        MotorToLand=FreeMotorsArray(ceil(WhichLandInteger/NumberofMonomers)); %ceil rounds up to nearest whole number, so this finds the motor that moves
        WhichMonomer=(WhichLandInteger*LandIntegersSize-(MotorToLand-1)*LandIntegersSize)/LandIntegersSize;
        MotorTrackingMatrix(MotorToLand,4)=WhichMonomer;
        
        
        
    else
        if p>k1/kTotal && p<(k1+k2)/kTotal
            MotorFellOff=1;
        else
            WalkInteger=kTotal-(k1+k2); %Length of walk integer
            NumberofMotorsOnFilament=sum(MotorTrackingMatrix(:,4)~=0);
            MotorIntegers=[(k1+k2):(WalkInteger/(2*NumberofMotorsOnFilament)):kTotal] %Divides the k3 section into integers (one for each direction for each motor on the filament)
            dist=abs(MotorIntegers-p); %distance from each "bin" to p (find which section p falls in)
            minDist = min(dist); %finds the bin closest to p
            WhichWalkInteger= find(dist == minDist); 
            MotorToMove=ceil(WhichWalkInteger/2); %ceil rounds up to nearest whole number
                if mod(WhichWalkInteger,2)~=0 && MotorTrackingMatrix(MotorToMove,4)~=1 %whether or not its even or odd and the motor is on one end
                    WalkDirection=-1
                else
                    WalkDirection=1
                end
            MotorTrackingMatrix(MotorToMove,4)=MotorTrackingMatrix(MotorToMove,4)+WalkDirection
        end
    end
    
    MotorTrackingMatrix
    
end