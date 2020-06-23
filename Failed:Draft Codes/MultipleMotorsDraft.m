% Multiple Motors Code

NumberofMotors=10;
NumberofRuns=100;
kOn=1;
kOff=1;
kWalk=1;

LengthofFilament
NumberofMonomers

MotorTrackingMatrix=zeros(NumberofMotors,4);
MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position

MotorFellOff=0

while MotorFellOff<1
    
   
    
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
    
    p=rand;
    
    if p<k1/kTotal  %What happens when k1=0???
        LandInteger=kTotal-(k2+k3)
        FreeMotorsArray=find(MotorTrackingMatrix(:,4)==0)
        WhichLands=size(FreeMotorsArray)*NumberofMonomers
        LandPositionIntegers=[0:WhichLands:k1]
        dist=abs(LandPositionIntegers-p)
        minDist = min(dist)
        WhichMotorInteger1= find(dist == minDist)
        MotorToMove=FreeMotorsArray(ceil(WhichMotorInteger1/NumberofMonomers)) %ceil rounds up to nearest whole number
        WhichMonomer=LengthofFilament(abs(p-MotorToMove)/Landinteger) %the distance between p and Motor to move divided by integer length is how many monomers away it is from LengthofFilament
        MotorTrackingMatrix(MotorToMove,4)=WhichMonomer
        MotorTrackingMatrix(MotorToMove,3)=WhichMonomer
    else
        if p>k1/kTotal && p<(k1+k2)/kTotal
            MotorFellOff=1
        else
            WalkInteger=kTotal-(k1+k2)
            WhichMoves=WalkInteger/(2*NumberofMotorsOnFilament)
            MotorIntegers=[(k1+k2):WhichMoves:k3]+p
            dist=abs(MotorIntegers-p)
            minDist = min(dist)
            WhichMotorInteger= find(dist == minDist)
            MotorToMove=ceil(WhichMotorInteger/2) %ceil rounds up to nearest whole number
                if mod(WhichMotorInteger,2)==0 %whether or not its even or odd
                    WalkDirection=1
                else
                    WalkDirection=-1
                end
            MotorTrackingMatrix(MotorToMove,4)=MotorTrackingMatrix(MotorToMove,4)+WalkDirection
                if MotorTrackingMatrix(MotorToMove,4)==NumberofMonomers
                IsMotorOnEnd=1
                end
        end
    end
    
    % Motor Walking simulation
    
%    WalkInteger=kTotal-(k1+k2)
%    WhichMoves=WalkInteger/(2*NumberofMotorsOnFilament)
%    MotorIntegers=[(k1+k2):WhichMoves:k3]+p
%    dist=abs(MotorIntegers-p)
%    minDist = min(dist)
%    WhichMotorInteger= find(dist == minDist)
%    MotorToMove=ceil(WhichMotorInteger/2) %ceil rounds up to nearest whole number
%    if mod(WhichMotorInteger,2)==0 %whether or not its even or odd
%        WalkDirection=1
%    else
%        WalkDirection=-1
%    end
%    MotorTrackingMatrix(MotorToMove,4)=MotorTrackingMatrix(MotorToMove,4)+WalkDirection
%    if MotorTrackingMatrix(MotorToMove,4)==NumberofMonomers
%        IsMotorOnEnd=1
%    end
   
   %Motor Landing
   
%    LandInteger=kTotal-(k2+k3)
%    FreeMotorsArray=find(MotorTrackingMatrix(:,4)==0)
%    WhichLands=size(FreeMotorsArray)*NumberofMonomers
%    LandPositionIntegers=[0:WhichLands:k1]
%    dist=abs(LandPositionIntegers-p)
%    minDist = min(dist)
%    WhichMotorInteger1= find(dist == minDist)
%    MotorToMove=FreeMotorsArray(ceil(WhichMotorInteger1/NumberofMonomers)) %ceil rounds up to nearest whole number
%    WhichMonomer=LengthofFilament(abs(p-MotorToMove)/Landinteger) %the distance between p and Motor to move divided by integer length is how many monomers away it is from LengthofFilament
%    MotorTrackingMatrix(MotorToMove,4)=WhichMonomer
%    MotorTrackingMatrix(MotorToMove,3)=WhichMonomer
   
   
   
%    %MotorFallingOff
%    MotorFellOff=1
    
    
end
