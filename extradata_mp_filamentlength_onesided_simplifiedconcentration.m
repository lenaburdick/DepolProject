
%This code makes kon dependent only concentration, not free motors, and
%kwalk not dependent on concentration at all. This is to mirror the theory


clear all
close all

NumberofRuns=1000;

NumberofMotors=25;

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100;
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kOn*NumberofBoundMotors

LengthofFilamentArray=[5 20 50 100];

BoundOverTimeCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
OnOffWalkCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
DTCell=cell(NumberofRuns, size(LengthofFilamentArray,2));
DisplacementCell=cell(NumberofRuns, size(LengthofFilamentArray,2));


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

j=0;

%--------------------------------------------------------------------------
   

while MotorFellOff<1
    

%---Setting Rates----------------------------------------------------------

    if sum(MotorTrackingMatrix(:,4)==0)>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0 %If there are any free motors and no motors on end
        k1=kOn*NumberofMotors*LengthofFilament; %kOn times number of motors times length of filament
    else
        k1=0; %don't need this
    end
    
    if sum(MotorTrackingMatrix(:,4)==NumberofMonomers)>0
        k2=kOff;
    else
        k2=0;
    end
    
    if sum(MotorTrackingMatrix(:,4))>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0 % If there is a protein anywhere on the filament and there are no proteins on end
        k3=kWalk; %kWalk not multiplied by number of bound motors
    else
        k3=0;
    end
    
    kTotal=k1+k2+k3;
    
%---Outcomes (Land, Walk, Off)---------------------------------------------
    
    p=rand;
%     DT=[DT exprnd(1/kTotal)];
    j=j+1;
    DT(j)=exprnd(1/kTotal);
   
    if p<k1/kTotal %Landing
        FreeMotorArray=find(MotorTrackingMatrix(:,4)==0); %gives an array of the indexes of every free motor
        LandPosition=ceil(p*NumberofMonomers); %Which position "bin" the number falls into
        MotorToLand=FreeMotorArray(ceil((LandPosition-p*NumberofMonomers)*size(FreeMotorArray,1))); %Splits the "position bin" into bins for free motors & finds where p falls
        
        MotorTrackingMatrix(MotorToLand,2)=sum(DT); %Time Landed
        MotorTrackingMatrix(MotorToLand,3)=LandPosition; %Position Landed
        MotorTrackingMatrix(MotorToLand,4)=LandPosition; %Current Position
        Outcome=1;
    else
        if p>k1/kTotal && p<(k1+k2)/kTotal
            MotorFellOff=1;
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
    
    
end

TotalTimeMatrix(h,i)=sum(DT); %how much time this run took in total


Displacement=[NumberofMonomers, MotorTrackingMatrix(:,4)']-[(MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,3)) (MotorTrackingMatrix(:,3)')]; % First entry is displacement of terminal protein, rest is the final position-original position for all proteins in order (terminal protein included)
    
BoundOverTimeCell{h,i}=BoundOverTime;
OnOffWalkCell{h,i}=OnOffWalk;
DTCell{h,i}=DT;
DisplacementCell{h,i}=Displacement;

TPTimeOnFilamentMatrix(h,i)=sum(DT)-MotorTrackingMatrix(MotorTrackingMatrix(:,4)==NumberofMonomers,2); %How long the depolymerizing protein was on the filament, including falling off


end

end


for h=1:NumberofRuns
 
    
 for i=1:size(LengthofFilamentArray,2)
     
 TotalTime(h,i)=sum(DTCell{h,i});
 
 DisplacementTemp=DisplacementCell{h,i};
 TPDisplacement(h,i)=DisplacementTemp(1); %Displacement of protein that eventually reaches end
 DisplacementTemp(1)=[];
 AvgDisplacement(h,i)= mean(DisplacementTemp); %Average Displacement of all proteins for this run
 
 
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

mean(TPTimeOnFilamentMatrix,1)


x=LengthofFilamentArray;


%Calculate Diffusion Constant

DiffCon=1/(2*mean(mean(TotalWalkTime,1)./mean(TotalWalkSteps,1))); % 1/ (2* The mean of The average time spent walking divided by the average walk steps for multiple lengths)
%-----------------------------------

parameters=join({'Runs=' num2str(NumberofRuns); 'Total Proteins=' num2str(NumberofMotors); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff); 'Filament Lengths=' num2str(LengthofFilamentArray); 'Diffusion Constant=' num2str(DiffCon)})


figure(1) %Total Time Versus Length

totaltimeplot=plot(x,mean(TotalTime,1), 'm')
totaltimeplot.LineWidth=3
totaltimeplot.DisplayName='Simulation Data'

hold on

totaltimetheory=LengthofFilamentArray.^2./(3*DiffCon)+1./(kOn*NumberofMotors*LengthofFilamentArray)+1/kOff;
totaltimetheoryplot=plot(x,totaltimetheory,'c:')
totaltimetheoryplot.LineWidth=3
totaltimetheoryplot.DisplayName='Theory, T= L^2/(3*DiffCon)+1/(kOn*NumberofMotors*Length)+1/kOff'

xlabel('Length (in Monomers) of Filament')
ylabel('Time Until One Protein Reaches The End and Depolymerizes')
title('Multiple Protein System, Length Versus Time until Depolymerization Event', 'FontSize',14)
set(gca, 'fontsize',20)

legend show

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14

figure(2) %Displacement of terminal protein and all proteins

tpdisplacementplot=plot(x,mean(TPDisplacement,1), 'm')
tpdisplacementplot.LineWidth=3
tpdisplacementplot.DisplayName='Protein That Reaches End'

hold on

avgdisplacementplot=plot(x,mean(AvgDisplacement,1), 'c')
avgdisplacementplot.LineWidth=3
avgdisplacementplot.DisplayName='All Proteins' %should I index proteins with 0 displacement differently than proteins that never land?

xlabel('Length (in Monomers) of Filament')
ylabel('Average Total Displacement of Proteins')
title('Average Total Displacement of Proteins Versus Length', 'FontSize',14)
set(gca, 'fontsize',20)

legend show

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14

figure(3) %Single Protein Time Versus Length

tptimeonfilamentplot=plot(x,mean(TPTimeOnFilamentMatrix,1), 'm')
tptimeonfilamentplot.LineWidth=3
tptimeonfilamentplot.DisplayName='Simulation Averages' 

xlabel('Length (in Monomers) of Filament')
ylabel('Time Terminal Protein Spends On Filament')
title('Time Terminal Protein Spends On Filament Versus Length', 'FontSize',14)
set(gca, 'fontsize',20)

hold on

tptimeonfilamenttheoryplot=plot(x, LengthofFilamentArray.^2./(3*DiffCon), 'g:')
tptimeonfilamenttheoryplot.LineWidth=3
tptimeonfilamenttheoryplot.DisplayName= 'Theory, Time=Length^2/(3*DiffusionConstant)'

legend show

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14

figure(4)

yyaxis right
totalwalkstepsplot=plot(x,mean(TotalWalkSteps,1), 'm')
totalwalkstepsplot.LineWidth=3
totalwalkstepsplot.DisplayName='Average Walk Steps'

hold on

yyaxis left
totalwalktimeplot=plot(x,mean(TotalWalkTime,1), 'm:')
totalwalktimeplot.LineWidth=3
totalwalktimeplot.DisplayName='Total Time Spent Walking'

xlabel('Length (in Monomers) of Filament')
ylabel('Time (Left) and Number of Steps (Right)')
title('Number of Walking Steps and Time Spent Walking Versus Length', 'FontSize',14)
set(gca, 'fontsize',20)

legend show

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14


figure(5)

yyaxis right
totalonstepsplot=plot(x,mean(TotalOnSteps,1), 'c')
totalonstepsplot.LineWidth=3
totalonstepsplot.DisplayName='Average Land Steps'

hold on

yyaxis left
totalontimeplot=plot(x,mean(TotalOnTime,1), 'c:')
totalontimeplot.LineWidth=3
totalontimeplot.DisplayName='Total Time Spent Landing'

xlabel('Length (in Monomers) of Filament')
ylabel('Time (Left) and Number of Steps (Right)')
title('Number of Landing Steps and Time Spent Landing Versus Length', 'FontSize',14)
set(gca, 'fontsize',20)

legend show

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14


