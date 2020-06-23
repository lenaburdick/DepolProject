


% This made the kOn and kWalk Dependent on the number of free or bound
% motors and kOn dependent on the length of the filament

% This simply simulates the land, walking, and falling off of a system with
% multiple motors

clear all
close all

NumberofRuns=1000;

NumberofMotors=15;

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100;
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kOn*NumberofBoundMotors

LengthofFilamentArray=5:5:25;


for h=1:NumberofRuns
 
    
 for i=1:size(LengthofFilamentArray,2)
     
%---INITIALIZING Values (Reset after each depolymerizing event)

LengthofFilament=LengthofFilamentArray(i);
    
NumberofMonomers=LengthofFilament+1;
    
MotorTrackingMatrix=zeros(NumberofMotors,4);
MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position
%first column is the motor number, second is the time it landed, the third is position it landed in, fourth is current position

MotorFellOff=0;

DT=[0];

TotalSteps=0;

WalkSteps=0;
%--------------------------------------------------------------------------
   

while MotorFellOff<1
    

%---Setting Rates----------------------------------------------------------

    if sum(MotorTrackingMatrix(:,4)==0)>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0 %If there are any free motors and no motors on end
        k1=kOn*sum(MotorTrackingMatrix(:,4)==0)*LengthofFilament; %kOn times number of free motors times length of filament
    else
        k1=0;
    end
    
    if sum(MotorTrackingMatrix(:,4)==NumberofMonomers)>0
        k2=kOff;
    else
        k2=0;
    end
    
    if sum(MotorTrackingMatrix(:,4))>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0 % If there is a protein anywhere on the filament and there are no proteins on end
        k3=kWalk*sum(MotorTrackingMatrix(:,4)>0);
    else
        k3=0;
    end
    
    kTotal=k1+k2+k3;
    
%---Outcomes (Land, Walk, Off)---------------------------------------------
    
    p=rand;
    DT=[DT exprnd(1/kTotal)];
    TotalSteps=TotalSteps+1; 
   
    if p<k1/kTotal
        FreeMotorArray=find(MotorTrackingMatrix(:,4)==0); %gives an array of the indexes of every free motor
        LandPosition=ceil(p*NumberofMonomers); %Which position "bin" the number falls into
        MotorToLand=FreeMotorArray(ceil((LandPosition-p*NumberofMonomers)*size(FreeMotorArray,1))); %Splits the "position bin" into bins for free motors & finds where p falls
        
        MotorTrackingMatrix(MotorToLand,2)=sum(DT); %Time Landed
        MotorTrackingMatrix(MotorToLand,3)=LandPosition; %Position Landed
        MotorTrackingMatrix(MotorToLand,4)=LandPosition; %Current Position
    else
        if p>k1/kTotal && p<(k1+k2)/kTotal
            MotorFellOff=1;
            
        else
            BoundMotorArray=find(MotorTrackingMatrix(:,4)~=0);
            q=p-(k1+k2)/kTotal; %This is how far p is away from the edge of the "walk bin"
            WalkInteger=ceil(q*size(BoundMotorArray,1)*2);
            MotorToWalk=BoundMotorArray(ceil(WalkInteger/2)); %Does this make the higher indexed motors more likely to walk?
            WalkSteps=[WalkSteps DT(end)]; %adds the amount of time this walk step took

                if mod(WalkInteger,2)~=0 && MotorTrackingMatrix(MotorToWalk,4)~=1 %whether or not its even or odd
                    WalkDirection=-1;
                else
                    WalkDirection=1;
                end

        MotorTrackingMatrix(MotorToWalk,4)=MotorTrackingMatrix(MotorToWalk,4)+WalkDirection; %Current Position either forward or back
        end
    end 
  

    
end

TotalTimeMatrix(h,i)=sum(DT); %how much time this run took in total

DT(end)=[]; %This eliminates tOff, which sometimes is screwy
TimeToEndMatrix(h,i)=sum(DT); %time for a protein to reach end, not including falling off

AvgDTMatrix(h,i)=sum(DT)/size(DT,2);

StepsMatrix(h,i)=TotalSteps;
SPTimeToEndMatrix(h,i)=TimeToEndMatrix(h,i)-MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,2); %How long the depolymerizing protein was on the filament, not including falling off
SPDisplacementMatrix(h,i)=NumberofMonomers-MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,3); %How far the final protein travelled

MeanWalkStepMatrix(h,i)=mean(WalkSteps); %finds the avg time it takes for a protein to move 1 monomer for that run

end

end




% %---Creating The File------------------------------------------------------

%-Reshaping--
StepsArray=reshape(StepsMatrix,1,[]);
MeanWalkStepArray=reshape(MeanWalkStepMatrix,1,[]);
SPTimeToEndArray=reshape(SPTimeToEndMatrix,1,[]);
SPDisplacementArray=reshape(SPDisplacementMatrix,1,[]);
TotalTimeArray=reshape(TotalTimeMatrix,1,[]);
AvgDTArray=reshape(AvgDTMatrix,1,[]);

FindNumberofRuns= 13;
FindNumberofMotors=14;
FindLengthofFilamentArray=15;
FindkOn=15+size(LengthofFilamentArray,2);
FindkOff=FindkOn+1;
FindkWalk=FindkOff+1;
FindTotalTimeArray=FindkWalk+1;
FindAvgDTArray=FindTotalTimeArray+size(TotalTimeArray,2);
FindStepsArray=FindAvgDTArray+size(AvgDTArray,2);
FindMeanWalkStepArray=FindStepsArray+size(StepsArray,2);
FindSPTimeToEndArray=FindMeanWalkStepArray+size(MeanWalkStepArray,2);
FindSPDisplacementArray=FindSPTimeToEndArray+size(SPTimeToEndArray,2);

DataToTrack= [FindNumberofRuns, FindNumberofMotors, FindLengthofFilamentArray, FindkOn, FindkOff, FindkWalk, FindTotalTimeArray, FindAvgDTArray, FindStepsArray, FindMeanWalkStepArray, FindSPTimeToEndArray, FindSPDisplacementArray, NumberofRuns, NumberofMotors, LengthofFilamentArray, kOn, kOff, kWalk, TotalTimeArray, AvgDTArray, StepsArray, MeanWalkStepArray, SPTimeToEndArray, SPDisplacementArray]


fileID3 = fopen('mp_filamentlength_onesided_cluster.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack'); %Don't know why this was chosen
fclose(fileID3);