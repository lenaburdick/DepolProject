%%% GIT TEST

clear all
close all

LengthsofFilament=[5:5:50]

TimeForEachRunMatrix=zeros(size(LengthsofFilament,2),NumberofRuns)

%AverageTimesForFullFilamentMatrix=zeros(1,size(LengthsofFilament,2))



for h=(1:size(LengthsofFilament,2))
    
LengthofFilament=LengthsofFilament(h);    

%---(Single Length) POSITION VERSUS TIME-----------------------------------
NumberofRuns=200;

TimeMatrix=zeros(1,LengthofFilament);

    %%LengthofFilament=20;

for StartingPosition=(1:LengthofFilament)
    
%     SinglePositionTimeMatrix=zeros(1,NumberofRuns);
    
    % OriginalPosition
    
    for i=1:NumberofRuns
            
    
    Position=StartingPosition;
    Time=0;
    
    IsMotorOnEnd=0;
    
    
    while IsMotorOnEnd<1 
    
    p=rand;
    
    if p<0.5
        Position=(Position-1);
    else
        Position=(Position+1);
    end
    
    if Position==1 || Position==LengthofFilament
        IsMotorOnEnd=1;
    else
        IsMotorOnEnd=0;
    end
        
        Time=Time+1;
        
    end
    
    SinglePositionTimeMatrix(i)=Time;
    
    end
    
    
    AverageTime=mean(SinglePositionTimeMatrix);
    
    TimeMatrix(1,StartingPosition)=AverageTime;  
    
end

TimeMatrix(1,1)=0; %Replaces Last Time With Zero (so doesn't become Inf)
TimeMatrix(1,LengthofFilament)=0; %Replaces Last Time With Zero (so doesn't become Inf


%---POSITION VERSUS TIME GRAPH---(Simulation Data, Fit to Simulation, Theory from Diffusion Constant------

figure(1)
%~~~Simulation Data~~~~~~~
x=(1:LengthofFilament);
y=TimeMatrix;
Simulation=plot(x,y,'d-m');
Simulation.LineWidth=5;
Simulation.DisplayName=('Simulation Data');

    legend show
    LEGH=legend;
    LEGH.FontSize=40;
 
hold on
%~~~Fit to Simulation Data~~~~~~~
Equation='a*x+b*(x^2)';

f=fit(x' , y' , Equation);
FitofSimulation=plot(f, 'c:'); 
FitofSimulation.LineWidth=3;
FitofSimulation.DisplayName=('Polynomial Fitted to Simulation');

%~~~Finding Diffusion Constant~~~~~~~    
    ABValues=coeffvalues(f);
    DiffCons=[LengthofFilament/(2*ABValues(1)), -1/(2*ABValues(2))];
    DiffusionConstant=mean(DiffCons);

hold on
%~~~Theory~~~~~~~
v=(1:LengthofFilament);
w=((v.*(LengthofFilament-v))/2).*(1./DiffusionConstant);
Theory=plot(v,w, '-*g');
Theory.DisplayName=('Theory');
Theory.LineWidth=3;
   
hold on 

%~~~Graph Labels~~~~~~~
xlabel('Starting Position of Protein');
ylabel('Time Until Protein Reaches End');

legendname=strcat('Time Until a Protein Reaches The End of a ',num2str(LengthofFilament),' Monomer Long Filament ');
title(legendname)

%title('Time Until a Protein Reaches The End of a Filament Through a Random Walk');
set(gca, 'fontsize',40);
 
hold off
%--------------------------------------------------------------------------


AverageTimesForFullFilamentMatrix(1,h)=mean(TimeMatrix)

end


figure(2)

x=LengthsofFilament
y=AverageTimesForFullFilamentMatrix
AvgLengthTime=plot(x,y, 'd-m')
AvgLengthTime.DisplayName=('Simulation Data')
AvgLengthTime.LineWidth=5

hold on
%~~~Theory~~~~~~~
%T=(LengthsofFilament.^2)/(2*DiffusionConstant)

%TheoryLengthTime=plot(x,T)

Equation='b*(x^2)';

g=fit(x' , y' , Equation);
FitofLengthTimeSim=plot(g, 'c:'); 
FitofLengthTimeSim.LineWidth=3;
FitofLengthTimeSim.DisplayName=('Polynomial Fitted to Simulation');

%~~~Finding Diffusion Constant~~~~~~~    
    DiffusionConstant2=1/(2*coeffvalues(g));
v=LengthsofFilament
w=(v.^2)./(DiffusionConstant2*2)
TheoryLengthTime=plot(v,w,'-*g')
TheoryLengthTime.LineWidth=3
TheoryLengthTime.DisplayName=('Theory')

xlabel('Length of Filament')
ylabel('Average Time Until Protein Reaches End')
title('Average Time For A Diffusing Protein To Reach The End of A Filament')
set(gca, 'fontsize',40)