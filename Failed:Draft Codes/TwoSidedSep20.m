clear all
close all

%%% Are places where things had to change to adjust indexing (first
%%% position=0)

LengthsofFilament=10
h=1 %how many lengths you're testing
AverageTimeMatrix=zeros(1,size(LengthsofFilament,2))

TimeMatrix=zeros(size(LengthsofFilament,2),size(LengthsofFilament,2));

% for h=(1:size(LengthsofFilament,2))
%     
% LengthofFilament=LengthsofFilament(h);    

%---(Single Length) POSITION VERSUS TIME-----------------------------------
LengthofFilament=LengthsofFilament
TrueLength=LengthofFilament+1 %%%

NumberofRuns=10000;

TimeMatrix=zeros(1,TrueLength); %%%


for OriginalPosition=(0:LengthofFilament)  %%%

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
        if Position==0
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
    
    TimeMatrix(1,OriginalPosition+1)=AverageSinglePositionTime; %%%
    
    TimeMatrix(h,OriginalPosition+1)=AverageSinglePositionTime; %%%
    
end

TimeMatrix(h,1)=0;
TimeMatrix(h,LengthofFilament+1)=0; %%%

%---POSITION VERSUS TIME GRAPH---(Simulation Data, Fit to Simulation, Theory from Diffusion Constant------

Equation='a*x+b*(x^2)';

x=(0:LengthofFilament); %%%
y=TimeMatrix;
f=fit(x' , y' , Equation);

% FitofSimulation=plot(f, 'c:');

 ABValues=coeffvalues(f);
    DiffCons=[(LengthofFilament+1)/(2*ABValues(1)), -1/(2*ABValues(2))]; %%%
    DiffusionConstant=mean(DiffCons);

%--------------------------------------------------------------------------

% AverageTimeMatrix(1,h)=((sum(TimeMatrix(h,:)))/LengthofFilament)



LengthStartingPositionsArray=reshape(TimeMatrix',1,[]);

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
fileID3 = fopen('TwoSidedSep20.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack);
fclose(fileID3);