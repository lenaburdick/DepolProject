close all
clear all

simulationtime=8000;

% %Use When Making Graph Inital length Independent
InitialFilamentSize= 1000;

kMotorOn=15;
kMotorOff=20;

T=zeros(1,simulationtime);
T(1)=0;

DS=zeros(1,simulationtime); %
TotalDS(1)=0; %
DS(1)=0; %

NumberofRuns=1000

%~~~Concentration Versus Depolymerization Rate Stuff~~~~~~~~~~~~~~~~~~~~~~~
    %--(Comment Out Everything until next line when not changing concentration)
Concentration=[1:10:100 100:50:1000 1100:100:2000];
FullSlopeofGraphsMatrix=zeros(NumberofRuns,size(Concentration, 2));

for h=(1:NumberofRuns)

for j=(1:size(Concentration, 2))

    C=Concentration(j);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    
% %---Parameters, don't comment out------------------------------------------
    

    %%Constant Initial Lengths
        L=zeros(1,InitialFilamentSize)
        M=zeros(1,InitialFilamentSize);
     
    
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



%~~~FOR MULTIPLE CONCENTRATION LINE GRAPHS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


% colors=jet(size(Concentration,2));
 p=plot(TReal,MReal);
% p.Color=colors(j,:);

%  xlabel('Time')
%  ylabel('Length')
%  title('Length of Filament Versus Time')

FitofGraphs=polyfit(TReal.',MReal.',1);
SlopeofGraphsMatrix(j)=abs(FitofGraphs(1));

legendname=strcat('Concentration=',num2str(Concentration(j)),' & Slope=', num2str(SlopeofGraphsMatrix(j)));
p.DisplayName=legendname;
legend show

hold on


end

FullSlopeofGraphsMatrix(h,:)= SlopeofGraphsMatrix;

end

ErrorMatrix=(std(FullSlopeofGraphsMatrix))./h

AverageSlopeofGraphsMatrix=(sum(FullSlopeofGraphsMatrix))./h

 
DataToTrack=[simulationtime,kMotorOn,kMotorOff,InitialFilamentSize,Concentration,AverageSlopeofGraphsMatrix, ErrorMatrix];
fileID3 = fopen('TwoStepConcentrationClusterCode.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack);
fclose(fileID3);
