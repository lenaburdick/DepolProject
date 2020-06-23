close all
clear all

simulationtime=8000;

% %Use When Making Graph Inital length Independent
% InitialFilamentSize= 1000;

kMotorOn=15;
kMotorOff=20;

T=zeros(1,simulationtime);
T(1)=0;

DS=zeros(1,simulationtime); %
TotalDS(1)=0; %
DS(1)=0; %

NumberOfRuns=1000

for h=(1:NumberOfRuns)

%~~~Initial Filament Size Versus Depolymerization Rate Stuff~~~~~~~~~~~~~~~(Comment Out Everything until next line when not changing Initial Filament Size)
    InitialFilamentSize=[10:10:500];
for j=(1:size(InitialFilamentSize,2))
    
    

        C=1; %Use this when making the code concentration independent (Don't comment out when changing initial lengths)

% %---Parameters, don't comment out------------------------------------------
    
    %Changing Initial Lengths
         L=zeros(1,InitialFilamentSize(j));
             M=zeros(1,InitialFilamentSize(j));
  
             
    M(1)=size(L,2); %Shows length of filament over time
    T=zeros(1,simulationtime-1);
    T(1)=0;
    
    i=1;
%--------------------------------------------------------------------------


while i<simulationtime-1 && M(i)>1 %this is so none of the graphs reach zero and stay there for a long time (makes the slopes accurate)
   
    
     TotalDS(i)=sum(DS); %
    
    %k1
    k1=kMotorOn*C;

    %k2
    if L(end)==1 && size(L,2)>1
        k2=kMotorOff;
    else
        k2=0;
    end
    
    %ktotal
    ktotal=k1+k2;
    
    DT(i)=exprnd(1/ktotal);
    
    
    %Probabilities
    p=rand;
    
    if p<k1/ktotal
        L(end)=1;
    else
        L(end)=[];
        DS(i+1)=T(i)-TotalDS(i); %
    end
    
    M(i+1)=size(L,2);
    T(i+1)=T(i)+DT(i);

i=i+1;

end




ds=DS>0; %
DSReal=DS(ds); %

t=T>0;
TReal=T(t);
TReal=[0 TReal]; %this makes it so the first zero column (when the time is truly zero) is added back in

m=M>0;
MReal=M(m);


FitofGraphs=polyfit(TReal.',MReal.',1);
SlopeofGraphsMatrix(j)=abs(FitofGraphs(1));


end

FullSlopeofGraphsMatrix(h,:)=SlopeofGraphsMatrix;

end

ErrorMatrix=(std(FullSlopeofGraphsMatrix))./h


DataToTrack=[simulationtime,kMotorOn,kMotorOff,InitialFilamentSize,SlopeofGraphsMatrix,ErrorMatrix];
fileID3 = fopen('TwoStepInitialLengthClusterCode.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack);
fclose(fileID3);


