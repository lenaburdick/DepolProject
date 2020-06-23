clear all
close all

NumberofRuns=3;

NumberofMotors=4;

ShrinkAmount=7;

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100;
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kOn*NumberofBoundMotors

LengthofFilamentArray=[10];

BoundOverTimeCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
OnOffWalkCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
DTCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
DisplacementCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
LengthCell=cell(NumberofRuns, size(LengthofFilamentArray,2));

parameters=join({'Runs=' num2str(NumberofRuns); 'Total Proteins=' num2str(NumberofMotors); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff); 'Filament Lengths=' num2str(LengthofFilamentArray); 'Diffusion Constant=' num2str(.5)})



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

BoundOverTime=0;
OnOffWalk=0;
DT=0;

DTTotal=0;

DepolEvents=0;

j=0;

TimeToDepol=zeros(1,ShrinkAmount)

Length=LengthofFilamentArray(i);

LengthChange=0;
TimeChange=0;

%--------------------------------------------------------------------------
   

while DepolEvents<ShrinkAmount
    

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
        k3=kWalk*sum(MotorTrackingMatrix(:,4)>0); %kWalk * The number of bound motors
    else
        k3=0;
    end
    
    kTotal=k1+k2+k3;
    
%---Outcomes (Land, Walk, Off)---------------------------------------------
    
    p=rand;
%     DT=[DT exprnd(1/kTotal)];
    j=j+1;
    DT(j)=exprnd(1/kTotal);
    DTTotal(j)=sum(DT);
   
    if p<k1/kTotal
        FreeMotorArray=find(MotorTrackingMatrix(:,4)==0); %gives an array of the indexes of every free motor
        LandPosition=ceil(p*NumberofMonomers); %Which position "bin" the number falls into
        MotorToLand=FreeMotorArray(ceil((LandPosition-p*NumberofMonomers)*size(FreeMotorArray,1))); %Splits the "position bin" into bins for free motors & finds where p falls
        
        MotorTrackingMatrix(MotorToLand,2)=sum(DT); %Time Landed
        MotorTrackingMatrix(MotorToLand,3)=LandPosition; %Position Landed
        MotorTrackingMatrix(MotorToLand,4)=LandPosition; %Current Position
        Outcome=1;
    else
        if p>k1/kTotal && p<(k1+k2)/kTotal
 
            DepolEvents=DepolEvents+1;
            if DepolEvents==1
            TimeToDepol(DepolEvents)=sum(DT);
            else
                TimeToDepol(DepolEvents)=sum(DT)-TimeToDepol(DepolEvents-1);
            end
            
            MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,2)=0; %Time Landed
            MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,3)=0; %Position Landed
            MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,4)=0; %Current Position
            
            LengthofFilament=LengthofFilament-1;
            NumberofMonomers=NumberofMonomers-1;
            
            LengthChange(DepolEvents)=LengthofFilament;
            TimeChange(DepolEvents)=sum(DT);
            
            Outcome=2;
            
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
            Outcome=3;
        end
    end 
  
BoundOverTime(j)=size(MotorTrackingMatrix(MotorTrackingMatrix(:,4)>0),1);
OnOffWalk(j)=Outcome;
Length(j)=LengthofFilament;

% MotorTrackingMatrix
    
end

TotalTimeMatrix(h,i)=sum(DT); %how much time this run took in total


% Displacement=[NumberofMonomers, MotorTrackingMatrix(:,4)']-[(MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,3)) (MotorTrackingMatrix(:,3)')]; % First entry is displacement of terminal protein, rest is the final position-original position for all proteins in order (terminal protein included)
  
LengthCell{h,i}=Length;

TimeToDepolCell{h,i}=TimeToDepol;

BoundOverTimeCell{h,i}=BoundOverTime;
OnOffWalkCell{h,i}=OnOffWalk;
DTCell{h,i}=DT;
% DisplacementCell{h,i}=Displacement;
StartingPositionCell{h,i}=MotorTrackingMatrix(:,3);
StartingTimeCell{h,i}=MotorTrackingMatrix(:,2);

% TPTimeOnFilamentMatrix(h,i)=sum(DT)-MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,2); %How long the depolymerizing protein was on the filament, including falling off


figure(i)

TimeChange=[0 TimeChange]
LengthChange=[LengthofFilamentArray(i) LengthChange]

p=plot(TimeChange,LengthChange)
ylabel('Length (in Monomers) of Filament')
xlabel('Time Passed')
% colors=jet(size(LengthofFilamentArray,2))
% p.FaceColor=colors(i,:);
title(['Length Versus Time Of Constantly Depolymerizing Protein Starting at L = ', num2str(LengthofFilamentArray(i))])
TimeChangeCell{h,i}=TimeChange;
LengthChangeCell{h,i}=LengthChange;


hold on


 end


end


for h=1:NumberofRuns
 
    
 for i=1:size(LengthofFilamentArray,2)
     
 TotalTime(h,i)=sum(DTCell{h,i});
 
 DisplacementTemp=DisplacementCell{h,i};
%  TPDisplacement(h,i)=DisplacementTemp(1); %Displacement of protein that eventually reaches end
%  DisplacementTemp(1)=[];
%  AvgDisplacement(h,i)= mean(DisplacementTemp); %Average Displacement of all proteins for this run
 
 
 On=(OnOffWalkCell{h,i}==1);
 Walk=(OnOffWalkCell{h,i}==3);
 
 BoundOverTimeTemp=BoundOverTimeCell{h,i};
 
 TotalOnSteps(h,i)=size(BoundOverTimeTemp(On),2);
 TotalWalkSteps(h,i)=size(BoundOverTimeTemp(Walk),2);
 
 DTTemp=DTCell{h,i};
 TotalOnTime(h,i)=sum(DTTemp(On));
 TotalWalkTime(h,i)=sum(DTTemp(Walk));

 end
 
end

for i=1:size(LengthofFilamentArray,2)
for h=1:NumberofRuns
LengthChangeMatrixTemp=LengthChangeCell{h,i};
TimeChangeMatrixTemp=TimeChangeCell{h,i};
end
LengthChangeMatrix(i,:)=mean(LengthChangeMatrixTemp,1)
TimeChangeMatrix(i,:)=mean(TimeChangeMatrixTemp,1)

figure(i)
p=plot(mean(TimeChangeMatrixTemp,1),mean(LengthChangeMatrixTemp,1), 'b')
p.LineWidth=3
p.DisplayName='Average of Simulation'

hold on



% theory=mean(LengthChangeMatrixTemp,1).^2./(3*.5)+1/(kOn*NumberofMotors)+1/kOff;
% t=plot(theory,mean(LengthChangeMatrixTemp,1),'r:')
% t.LineWidth=3
% t.DisplayName='Theory, T=L^2/(3D)+1/(kOn*N)+1/kOff, D=.5'

legend show

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14
end



