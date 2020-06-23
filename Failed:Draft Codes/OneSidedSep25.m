clear all
close all

LengthsofFilament=[5:5:25]
AverageTimeMatrix=zeros(1,size(LengthsofFilament,2))
NumberofRuns=100;

LengthStartingPositionsMatrix=zeros(size(LengthsofFilament,2),size(LengthsofFilament,2));

for h=(1:size(LengthsofFilament,2))
    
LengthofFilament=LengthsofFilament(h);
TrueLength=LengthofFilament+1 %%%

%---(Single Length) POSITION VERSUS TIME-----------------------------------

TimeMatrix=zeros(1,TrueLength); %%%


for OriginalPosition=(0:LengthofFilament) %%%

    SinglePositionTimeMatrix=zeros(1,NumberofRuns);
    
    % OriginalPosition
    
    for i=1:NumberofRuns
            
    
    Position=OriginalPosition;
    Time=0;
    
    IsMotorOnEnd=0;
    
    
    while IsMotorOnEnd<1 
    
    p=rand;
    
    if p<0.5 && Position~=0
        Position=(Position-1);
    else
        Position=(Position+1);
    end
    
    if Position==LengthofFilament
        IsMotorOnEnd=1;
    else
        IsMotorOnEnd=0; 
    end
        
        Time=Time+1;
        
    end
    
    SinglePositionTimeMatrix(i)=Time;
    
    
    end
    
    % SinglePositionTimeMatrix
    
    AverageSinglePositionTime=mean(SinglePositionTimeMatrix);
    
    TimeMatrix(1,OriginalPosition+1)=AverageSinglePositionTime; %%%
    
    LengthStartingPositionsMatrix(h,OriginalPosition+1)=AverageSinglePositionTime; %%%
    
end

LengthStartingPositionsMatrix(h,LengthofFilament+1)=0; %%%

TimeMatrix(1,TrueLength)=0; %Replaces Last Time With Zero (so doesn't become Inf) %%%

%---POSITION VERSUS TIME GRAPH---(Simulation Data, Fit to Simulation, Theory from Diffusion Constant------

Equation='a*(x^2)';

x=(0:LengthofFilament); %%%
y=TimeMatrix;
f=fit(x' , y' , Equation);

% FitofSimulation=plot(f, 'c:');

 AValue=coeffvalues(f);
    DiffCons=[-1/(2*AValue), (LengthofFilament^2)/(2*AValue)];
    DiffusionConstant=mean(DiffCons);

%--------------------------------------------------------------------------

AverageTimeMatrix(1,h)=((sum(LengthStartingPositionsMatrix(h,:)))/LengthofFilament)


end

LengthStartingPositionsArray=reshape(LengthStartingPositionsMatrix',1,[]);

FindLengthsofFilament=(1:size(LengthsofFilament,2));
FindNumberofRuns=(size(LengthsofFilament,2)+1);
FindLengthStartingPositionsArray=((size(LengthsofFilament,2)+2):size(LengthStartingPositionsArray,2)+(size(LengthsofFilament,2)+1));
FindDiffCons=size(LengthStartingPositionsArray,2)+size(LengthsofFilament,2)+2:size(LengthStartingPositionsArray,2)+size(LengthsofFilament,2)+3;
FindAverageTimeMatrix=((size(LengthStartingPositionsArray,2)+size(LengthsofFilament,2)+4):(size(LengthStartingPositionsArray,2)+size(LengthsofFilament,2)+3+size(AverageTimeMatrix,2)));

FindLengthsofFilament=FindLengthsofFilament(1)+5;
FindNumberofRuns=FindNumberofRuns(1)+5;
FindLengthStartingPositionsArray=FindLengthStartingPositionsArray(1)+5;
FindDiffCons=FindDiffCons(1)+5;
FindAverageTimeMatrix=FindAverageTimeMatrix(1)+5;


DataToTrack=[FindLengthsofFilament,FindNumberofRuns,FindLengthStartingPositionsArray,FindDiffCons,FindAverageTimeMatrix,LengthsofFilament,NumberofRuns,LengthStartingPositionsArray,DiffCons,AverageTimeMatrix];
fileID3 = fopen('OneSidedSep25.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack);
fclose(fileID3);