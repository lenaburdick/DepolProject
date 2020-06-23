close all
clear all

        %---Definitions----------------------------------------------------
            %Concentration Dependent means Kon Is Dependent on
            %kMotorOn*Concentration (Concentration is set at the beginning
            %of a run and it unchanging), Concentration Independent means
            %kon is dependent only on kMotorOn, Free Motors Dependent means
            %Kon is dependent both on the con centration set at the
            %beginning, and the number of motors on the filament affects
            %the availability of motors throughout the run
            
            % "~~~" sections are sections which can be commented in or out
            % depending on what you are tracking (they go until the next
            % "~~~" line
            
            % Things between "%%%" lines stay consistent from run to run
            
            % Things in capital letters should be checked and changed each
            % run to make sure they are correct

%%%%Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simulationtime=80000;

%INITIAL LENGTH INDEPENDENT
 InitialFilamentSize=1000; %Use When Not Changing Initial Lengths


NumberofMotors=50;

%Rates
kMotorOn=(15/50);
kMotorOff=20;
kWalk=15;

%kWalk Rates
kWalkForward=5;
kWalkBackward=5;
kWalkTotal=kWalkForward+kWalkBackward;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%~~~Initial Filament Size Versus Depolymerization Rate Stuff~~~~~~~~~~~~~~~
%  InitialFilamentSize=[10 25 50 75 100 110 120 135 150 175 200 ];
% 
% for j=(1:size(InitialFilamentSize,2))
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
%~~~Concentration Versus Depolymerization Rate Stuff~~~~~~~~~~~~~~~~~~~~~~~
Concentration=[1100:100:5000];

for j=(1:size(Concentration,2))
    
   NumberofMotors=Concentration(j);
    
% %CONCENTRATION DEPENDENT BUT FREE MOTORS INDEPENDENT (Use this or next one for three step)   
    FreeMotors=zeros(1,simulationtime-1);
     FreeMotors(1,:)=NumberofMotors; %Doing this means that later on,kTrueOnRate=kMotorOn*FreeMotors(i) becomes kMotorOn*NumberofMotors

% %CONCENTRATION AND FREE MOTORS DEPENDENT         
% %Free Motors Matrix
%      FreeMotors=zeros(1,simulationtime);
%      FreeMotors(1)=NumberofMotors;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% %CONCENTRATION AND FREE MOTORS INDEPENDENT (use only for 2 step or motoro position matrix won't work)       
%      NumberofMotors=1; %Use this when making the code concentration independent, don't comment out when changing intitial lengths
%      FreeMotors=zeros(1,simulationtime-1);
%      FreeMotors(1,:)=NumberofMotors;
         
%%%%Parameters, Don't Comment Out%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Length Matrix
L=zeros(1,simulationtime);
     %INITIAL LENGTH DEPENDENT
%           L(1)=InitialFilamentSize(j);
     %INITIAL LENGTH INDEPENDENT
          L(1)=InitialFilamentSize;

%Time Matrix
T=zeros(1,simulationtime);
T(1)=0;

%Waiting Time Distribution Stuff
DS=zeros(1,simulationtime);
DS(1)=0;
TotalDS(1)=0;

%Motor Position Matrix
MotorPositionMatrix=zeros(NumberofMotors,3);
n=1:NumberofMotors;
MotorPositionMatrix(n,1)=n;

%Evaluation Stuff
WhichIsPossibleMatrix=zeros(simulationtime,3);
TimeValuesMatrix=zeros(simulationtime-1,4);

%%%%For Loop%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=(1:simulationtime-1)
   
    LengthofFilament=L(i);
    
%     %FREE MOTORS DEPENDENT
%       FreeMotors(i)=sum(MotorPositionMatrix(:,2)==0);
%       kTrueOnRate=FreeMotors(i)*kMotorOn;
    
    %FREE MOTORS INDEPENDENT
        kTrueOnRate=kMotorOn*FreeMotors(i); %A condition earlier made FreeMotors(i)=NumberofMotors
    
    IsMotorOnEnd=sum(MotorPositionMatrix(:,3)==LengthofFilament);
    
    TotalDS(i)=sum(DS);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if L(i)==1
    break
end

%%%%Rates%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
% k1, kTrueOnRate
if sum(MotorPositionMatrix(:,2)==0)>0
    k1=kTrueOnRate;
%     Isk1Possible(i)=1;
else
    k1=0;
%     Isk1Possible(i)=0;
end

%k2, kMotorOff
if LengthofFilament>1 && IsMotorOnEnd>0
    k2=kMotorOff;
%     Isk2Possible(i)=1;
else
    k2=0;
%     Isk2Possible(i)=0;
end

%k3, kWalk
 if sum(MotorPositionMatrix(:,2)==1)>0 %this says whether there are any motors on the filament
     k3=kWalk;
%      Isk3Possible(i)=1;
 else
     k3=0;
%      Isk3Possible(i)=0;
 end

% ktotal
ktotal=k1+k2+k3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 DT(i)=exprnd(1/ktotal);

 T(i+1)=T(i)+DT(i);
 
 if T(i)==Inf
     return
 end
%%%%Probabilities%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p=rand;

%Motor Lands
if p<k1/ktotal
    h=find(MotorPositionMatrix(:,2)==0);
    MotorToLand=h(randi(length(h)));
    MotorPositionMatrix(MotorToLand,2)=1;
    
    %~~~THREE STEP~~~
    MotorPositionMatrix(MotorToLand,3)=randi(LengthofFilament);
    %~~~TWO STEP~~~
     %MotorPositionMatrix(MotorToLand,3)=LengthofFilament; %USE THIS TO DO LAUREN 2 STEP
    
    L(i+1)=L(i);
%     WhichHappened=1;
else

%Motor Falls Off
if p>k1/ktotal && p<(k1+k2)/ktotal
    MotorsLeaving=MotorPositionMatrix(MotorPositionMatrix(:,3)==LengthofFilament);
    MotorPositionMatrix(MotorsLeaving,3)=0;
    MotorPositionMatrix(MotorsLeaving,2)=0;
    
    L(i+1)=L(i)-1;
    DS(i+1)=T(i)-TotalDS(i);
%     WhichHappened=2;
    DS(i+1);
else
    
%Motor Walks
   MotorsOnFilament=find(MotorPositionMatrix(:,2)==1); 
   MotorToWalk=MotorsOnFilament(randi(length(MotorsOnFilament)));
   
   L(i+1)=L(i);
%    WhichHappened=3;
    
   q=rand;
    
    %k1Walk
        if MotorPositionMatrix(MotorToWalk,3)==LengthofFilament
            k1Walk=0;
        else
            k1Walk=kWalkForward;
        end
    
    %k2Walk
        if MotorPositionMatrix(MotorToWalk,3)==1
            k2Walk=0;
        else
            k2Walk=kWalkBackward;
        end
  
    %kWalkTotal
    kWalkTotal=k1Walk+k2Walk;
    
        if q<k1Walk/kWalkTotal
            MotorPositionMatrix(MotorToWalk,3)=MotorPositionMatrix(MotorToWalk,3)+1;
        else
            MotorPositionMatrix(MotorToWalk,3)=MotorPositionMatrix(MotorToWalk,3)-1;
        end
end
        
end

%%%%Values to track%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%i
%L(i)
%DS(i)
% ktotal
% DT(i)
% T(i)
% MotorPositionMatrix
% IsMotorOnEnd
% WhichHappened

% WhichIsPossibleMatrix(i,1)=Isk1Possible(i);
% WhichIsPossibleMatrix(i,2)=Isk2Possible(i);
% WhichIsPossibleMatrix(i,3)=Isk3Possible(i);
% 
%  
% TimeValuesMatrix(i,1)=T(i);
% TimeValuesMatrix(i,2)=sum(DT);
% TimeValuesMatrix(i,3)=DT(i);
% TimeValuesMatrix(i,4)=T(i)-TotalDS(i);
% TimeValuesMatrix(i,5)=TotalDS(i);
% TimeValuesMatrix(i,6)=DS(i);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

ds=DS>0;
DSReal=DS(ds);

t=T>0;
TReal=T(t);
TReal=[0 TReal]; %this makes it so the first zero column (when the time is truly zero) is added back in

l=L>0;
LReal=L(l);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%~~~FOR MULTIPLE CONCENTRATION LINE GRAPHS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 figure(1)
colors=jet(size(Concentration,2));
 p=plot(TReal,LReal);
p.Color=colors(j,:);

 xlabel('Time')
 ylabel('Length')
 title('Length of Filament Versus Time')

FitofGraphs=polyfit(TReal.',LReal.',1);
SlopeofGraphsMatrix(j)=abs(FitofGraphs(1));

legendname=strcat('Concentration=',num2str(Concentration(j)),' & Slope=', num2str(SlopeofGraphsMatrix(j)));
p.DisplayName=legendname;
legend show

hold on



end

%---FOR CONCENTRATION VERSUS DEPOLYMERIZATION SCATTER PLOT----------------- 
hold off
 
 figure(2)
 sz=200
 n=scatter(Concentration,SlopeofGraphsMatrix,sz)
 xlabel('Concentration', 'fontsize',40)
 ylabel('Depolymerization Rates', 'fontsize',40)
 title('Depolymerization Rates Versus Concentration of Motors', 'fontsize',40)
 
 n.Marker=('o')
 n.MarkerFaceColor=('g')
 n.MarkerEdgeColor=('g')
 n.DisplayName=('Simulated Data')
 
 hold on
 
%  err=ones(size(Concentration))
%  o=errorbar(Concentration, SlopeofGraphsMatrix, err,'LineStyle','none')
%  o.DisplayName=('Error')
%  o.Color=('m')
 
 hold on
 
%  y=(kMotorOn*Concentration*kMotorOff)./(kMotorOn*Concentration+kMotorOff);
%  x=Concentration;
%  r=plot(x,y,'m')
%  r.DisplayName=('Theory')
%  r.LineWidth=3
 
 
 legend show
 LEGH=legend;
 LEGH.FontSize=40
 
 hold off
 
 
%~~~FOR MULTIPLE INITAL LENGTHS LINE GRAPH~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% figure(1)
% colors=jet(size(InitialFilamentSize,2));
% p=plot(TReal,LReal);
% p.Color=colors(j,:);
% 
% xlabel('Time')
% ylabel('Length')
% title('Length of Filament Versus Time For Different Time Intervals')
% 
% FitofGraphs=polyfit(TReal.',LReal.',1);
% SlopeofGraphsMatrix(j)=abs(FitofGraphs(1));
% 
% legendname=strcat('InitialLength',num2str(InitialFilamentSize(j)),' & Slope=', num2str(SlopeofGraphsMatrix(j)));
% p.DisplayName=legendname;
% legend show
% 
% hold on
% 
% end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%~~~For Initial Lengths Versus Depolymerization Scatter Plot~~~~~~~~~~~~~~~

% figure(2)
%  n=scatter(InitialFilamentSize,SlopeofGraphsMatrix)
%  xlabel('Initial Lengths')
%  ylabel('Depolymerization Rates')
%  title('Initial Lengths Versus Depolymerization Rate')
%  n.DisplayName=('Simulated Data')
%  hold on
%  y=(kMotorOn*kMotorOff)/(kMotorOn+kMotorOff)
%  r=line([0,InitialFilamentSize(end)],[y,y])
%  r.DisplayName=('Calculated Data')
%  legend show
%  LEGH=legend
%  LEGH.FontSize=40
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



%~~~PLOTS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% %Length Versus Time (Single Run)
% plot(TReal,LReal);
%  xlabel('Time')
%  ylabel('Length')
%  title('Length of Filament Versus Time')

%---WaitingTimeDistribution------------------------------------------------

% figure(5)
% histogram(DT, 'Normalization','pdf')
% xlabel('Waiting Time')
% ylabel('Probability')
% title('Simulated DT Distribution')
% 
% figure(6)
% histogram(DSReal, 'Normalization','pdf')
% xlabel('Waiting Time')
% ylabel('Probability')
% title('Simulated DS Distribution') 
%  hold on
%-------------------------------------------------------------------------- 
% % %True Two Step Equation
% y=(kTrueOnRate*kMotorOff/(kTrueOnRate-kMotorOff))*(exp(-kMotorOff*DT)-exp(-kTrueOnRate*DT));
% scatter(DT,y, 'c')
% 
% % %When kTrueOnRate<<kMotorOff
%  y1=kTrueOnRate*exp(-kTrueOnRate*DT);
%  scatter(DT,y1, 'r')
% 
% % %When kMotorOff<<kTrueOnRate
%  y2=kMotorOff*exp(-kMotorOff*DT);
%  scatter(DT,y2, 'g')
% 
% %  y=DT.*(kMotorOff*kTrueOnRate*kWalk*exp(-kMotorOff*DT)); %DO I USE DS REAL OR DT OR T
% %   scatter(DT,y, 'm')
% %-------------------------------------------------------------------------- 
% 
%  hold off
 
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 
 
 %---COMMENTS ABOUT CODE---------------------------------------------------
 %If Length goes to zero too quickly time becomes infinity because ktotal=0,
%it then looks like the length isnt decreasing but its actually not long
%enough not too short.....OR sometimes this happens when the system runs
%out of motors but there are no motors on end (kon and koff are then 0)

%It shrinks at very different rates every time
