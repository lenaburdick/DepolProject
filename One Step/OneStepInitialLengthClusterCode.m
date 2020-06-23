%Single Step


clear all
close all

simulationtime=8000;
InitialFilamentSize= 1000;

L=zeros(1,InitialFilamentSize)

kMotorOn=15;
kMotorOff=20;

M(1)=size(L,2); %Shows length of filament over time
T(1)=1;

 InitialFilamentSize=[10:10:500];

NumberofRuns=1000;
FullSlopeofGraphsMatrix=zeros(NumberofRuns,size(InitialFilamentSize, 2));

for h=(1:NumberofRuns)


for j=(1:size(InitialFilamentSize,2))
    
  
%---Parameters, don't comment out------------------------------------------
    
    
    %Changing Initial Lengths
          L=zeros(1,InitialFilamentSize(j));
              M=zeros(1,InitialFilamentSize(j));
     
    
    M(1)=size(L,2); %Shows length of filament over time
    T=zeros(1,simulationtime-1);
    T(1)=0;
    
    i=1;
%--------------------------------------------------------------------------




while i<(simulationtime-1) && size(L,2)>1
    
    %k1
        k1=kMotorOff;
   
    
    %ktotal
    ktotal=k1;
    
    DT(i)=exprnd(1/ktotal);
    L(end)=[];
    
    
    
    
    M(i+1)=size(L,2);
    T(i+1)=T(i)+DT(i);
    i=i+1;
end

t=T>0;
TReal=T(t);
TReal=[0 TReal]; %this makes it so the first zero column (when the time is truly zero) is added back in

m=M>0;
MReal=M(m);

%~~~FOR MULTIPLE INITAL LENGTHS LINE GRAPH~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

FitofGraphs=polyfit(TReal.',MReal.',1);
SlopeofGraphsMatrix(j)=abs(FitofGraphs(1));


end

FullSlopeofGraphsMatrix(h,:)=SlopeofGraphsMatrix;

end

ErrorMatrix=(std(FullSlopeofGraphsMatrix))./h

AverageSlopeofGraphsMatrix=(sum(FullSlopeofGraphsMatrix))./h

%--------------------------------------------------------------------------
 
DataToTrack=[simulationtime,kMotorOn,kMotorOff,InitialFilamentSize,AverageSlopeofGraphsMatrix,ErrorMatrix];
fileID3 = fopen('OneStepInitialLengthClusterCode.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack);
fclose(fileID3);