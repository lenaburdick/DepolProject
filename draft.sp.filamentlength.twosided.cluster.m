% This code provides data for the starting position (monomer) of a protein
% versus the avg. time it takes to reach the end of a filament, as well as
% the average time for any protein (regardless of starting position) to
% reach the end of different length filaments

% This code is two sided

% This code IS optimized for cluster

% You may have to run this code again to get a new .txt file after changing
% its name

clear all
close all

LengthsofFilament=[5:5:25]
AverageTimeMatrix=zeros(1,size(LengthsofFilament,2))

LengthStartingPositionsMatrix=zeros(size(LengthsofFilament,2),size(LengthsofFilament,2));

for h=(1:size(LengthsofFilament,2))
    
LengthofFilament=LengthsofFilament(h);    

%---(Single Length) POSITION VERSUS TIME-----------------------------------
NumberofRuns=100;

TimeMatrix=zeros(1,LengthofFilament);


for OriginalPosition=(1:LengthofFilament)

    SinglePositionTimeMatrix=zeros(1,NumberofRuns);
    
    % OriginalPosition
    
    for i=1:NumberofRuns
            
    
    Position=OriginalPosition;
    Time=0;
    
    IsMotorOnEnd=0;
    
    
    while IsMotorOnEnd<1 
    
    p=rand;
    
    if p<0.5
        Position=(Position-1);
    else
        Position=(Position+1);
    end
    
    if Position==LengthofFilament
        IsMotorOnEnd=1;
    else
        if Position==1
        IsMotorOnEnd=1;
        else
        IsMotorOnEnd=0;
        end
    end
        
        Time=Time+1;
        
    end
    
    SinglePositionTimeMatrix(i)=Time;
    
    
    end
    
    % SinglePositionTimeMatrix
    
    AverageSinglePositionTime=mean(SinglePositionTimeMatrix);
    
    TimeMatrix(1,OriginalPosition)=AverageSinglePositionTime;
    
    LengthStartingPositionsMatrix(h,OriginalPosition)=AverageSinglePositionTime;
    
end

LengthStartingPositionsMatrix(h,1)=0;
LengthStartingPositionsMatrix(h,LengthofFilament)=0;

TimeMatrix(1,1)=0; %Replaces Last Time With Zero (so doesn't become Inf)
TimeMatrix(1,LengthofFilament)=0; %Replaces Last Time With Zero (so doesn't become Inf)

%---POSITION VERSUS TIME GRAPH---(Simulation Data, Fit to Simulation, Theory from Diffusion Constant------

Equation='a*x+b*(x^2)';

x=(1:LengthofFilament);
y=TimeMatrix;
f=fit(x' , y' , Equation);

% FitofSimulation=plot(f, 'c:');

 ABValues=coeffvalues(f);
    DiffCons=[LengthofFilament/(2*ABValues(1)), -1/(2*ABValues(2))];
    DiffusionConstant=mean(DiffCons);

%--------------------------------------------------------------------------

AverageTimeMatrix(1,h)=((sum(LengthStartingPositionsMatrix(h,:)))/LengthofFilament);


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
fileID3 = fopen('sp.filamentlength.twosided.cluster.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack);
fclose(fileID3);