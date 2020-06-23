% This made the kOn and kWalk Dependent on the number of free or bound
% motors and kOn dependent on the length of the filament

% This simulates a multiple motor system with a changing concentration of
% motors

% THis code is one sided

% This is NOT optimized for cluster

clear all
close all

NumberofRuns=1000;

NumberofMotorsArray=1:10;


kOn=1; %This is chance of a single motor falling on the filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=1;
kWalk=1; %This is chance of a single motor walking on the filament. true kWalk is kOn*NumberofBoundMotors

% Once we have a code where the length changes continuosly instead of from
% l to L-1, kOn will also be dependent on number of monomers

LengthofFilament=5;
NumberofMonomers=LengthofFilament+1;

TotalTimeMatrix=zeros(NumberofRuns,size(NumberofMotorsArray,2)); 



for h=[1:NumberofRuns]

 for i=1:size(NumberofMotorsArray,2)   
    
     
NumberofMotors=NumberofMotorsArray(i);

MotorTrackingMatrix=zeros(NumberofMotors,4);
MotorTrackingMatrix(:,1)=(1:NumberofMotors); %first row is the motor number, second is the time it landed, the third is its current position

MotorFellOff=0;

DT=[0];
    
TotalSteps=0

while MotorFellOff<1
    

%----------------------------------------------------------------------

if sum(MotorTrackingMatrix(:,4)==0)>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0%If there are any free motors
        k1=kOn*sum(MotorTrackingMatrix(:,4)==0)*LengthofFilament; %kOn times number of free motors times length of filament
    else
        k1=0;
    end
    
    if sum(MotorTrackingMatrix(:,4)==NumberofMonomers)>0
        k2=kOff;
    else
        k2=0;
    end
    
    if sum(MotorTrackingMatrix(:,4))>0 && sum(MotorTrackingMatrix(:,4)==NumberofMonomers)==0 % should there be a condition where if there is a motor on the end this can't happen??
        k3=kWalk*sum(MotorTrackingMatrix(:,4)>0);
    else
        k3=0;
    end
        
    
    kTotal=k1+k2+k3;
    
    
%---Outcomes (Land, Walk, Off)---------------------------------------------
    
    
    p=rand;
    DT=[DT exprnd(1/kTotal)];
    TotalSteps=TotalSteps+1
    
    
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

                if mod(WalkInteger,2)~=0 && MotorTrackingMatrix(MotorToWalk,4)~=1; %whether or not its even or odd
                    WalkDirection=-1;
                else
                    WalkDirection=1;
                end

        MotorTrackingMatrix(MotorToWalk,4)=MotorTrackingMatrix(MotorToWalk,4)+WalkDirection;
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


 end

end

AverageTotalTimeArray=sum(TotalTimeMatrix,1)/NumberofRuns;

figure(1)
x=NumberofMotorsArray;
y=AverageTotalTimeArray;


concentrationtimeplot=plot(x,y,'m')

concentrationtimeplot.LineWidth=3
concentrationtimeplot.DisplayName=('Concentration of Protein Versus Time For Protein To Reach One End')

hold on

xlabel('Concentration (unit=number of proteins)')
ylabel('Time Until Protein Reaches One End (unit time=number of steps)')
title('Time Until Single Protein Diffuses to One End of Filament With Varying Protein Concentrations')
set(gca, 'fontsize',20)

hold on

% Finding The Difussion Constant---------

DiffCon=mean(1./(2*mean(AvgDTMatrix,1)))

%---------------------------------------------------------

%--Theory-----

yt=LengthofFilament^2/(3*DiffCon)+1./(kOn*x)+1/kOff;
theoryplot=plot(x, yt, 'g:')
theoryplot.DisplayName= 'Theory, T=L^2/(3D)+1/(kOn*NumberofProteins)+1/kOff'
theoryplot.LineWidth=3

str={NumberofRuns 'Runs', 'Concentration of Proteins=' NumberofMotorsArray, 'kOn=' kOn, 'kWalk=' kWalk, 'kOff=' kOff, 'Filament Length=' LengthofFilament, 'Diffusion Constant=' DiffCon}
text(5,9,str)

hold off

%----------------------------------------------------------

figure(2)

u=mean(SPTimeToEndMatrix,1); %The average amount of time the protein that reached end spent on filament per concentration
SPtimeplot=plot(x,u, 'm')
SPtimeplot.LineWidth=3
xlabel('Concentration (in # of Proteins)')
ylabel('Time Terminal Protein Spends On Filament Before Reaching End')
title('Time Terminal Protein Is Bound Before Reaching One End of Filament With Different Protein Concentrations')
set(gca, 'fontsize',20)

str={NumberofRuns 'Runs', 'Concentration of Proteins=' NumberofMotorsArray, 'kOn=' kOn, 'kWalk=' kWalk, 'kOff=' kOff, 'Filament Length=' LengthofFilament, 'Diffusion Constant=' DiffCon}
text(5,8,str)

figure(3)

v=mean(SPDisplacementMatrix,1); %The average number of monomers the protein that reached end travelled
SPdisplacementplot=plot(x,v, 'm')
SPdisplacementplot.LineWidth=3
xlabel('Concentration (in # of Proteins)')
ylabel('Average Displacement of Terminal Protein  Before Reaching End')
title('Average Number of Monomers Travelled By Terminal Protein Before Reaching One End of Filament At Different Protein Concentrations')
set(gca, 'fontsize',20)

str={NumberofRuns 'Runs', 'Concentration of Proteins=' NumberofMotorsArray, 'kOn=' kOn, 'kWalk=' kWalk, 'kOff=' kOff, 'Filament Length=' LengthofFilament, 'Diffusion Constant=' DiffCon}
text(2,1.5,str)

