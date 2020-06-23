close all
clear all

     
%%%%Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simulationtime=80000;

%INITIAL LENGTH INDEPENDENT
InitialFilamentSize=1000; %Use When Not Changing Initial Lengths


%Rates
kMotorOn=(15/50);
kMotorOff=20;
kWalk=15;

%kWalk Rates
kWalkForward=5;
kWalkBackward=5;
kWalkTotal=kWalkForward+kWalkBackward;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
%~~~Concentration Versus Depolymerization Rate Stuff~~~~~~~~~~~~~~~~~~~~~~~
Concentration=[1100:100:5000];

for j=(1:size(Concentration,2))
    
   NumberofMotors=Concentration(j);
    
% %CONCENTRATION DEPENDENT BUT FREE MOTORS INDEPENDENT (Use this or next one for three step)   
    FreeMotors=zeros(1,simulationtime-1);
     FreeMotors(1,:)=NumberofMotors; %Doing this means that later on,kTrueOnRate=kMotorOn*FreeMotors(i) becomes kMotorOn*NumberofMotors


         
%%%%Parameters, Don't Comment Out%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Length Matrix
L=zeros(1,simulationtime);
 
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

FitofGraphs=polyfit(TReal.',LReal.',1);
SlopeofGraphsMatrix(j)=abs(FitofGraphs(1));


end
 
DataToTrack=[simulationtime,kMotorOn,kMotorOff,kWalk,InitialFilamentSize,Concentration,SlopeofGraphsMatrix];
fileID3 = fopen('ThreeStepConcentrationClusterCode.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack);
fclose(fileID3);
 