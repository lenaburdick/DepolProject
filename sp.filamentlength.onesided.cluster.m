NumberofRuns=10000;
LengthsofFilament=[5:5:25];
TimePerMonomerMatrix=zeros(size(LengthsofFilament,2) , LengthsofFilament(end)+1);
AverageTimeMatrix=zeros(1,size(LengthsofFilament,2))


for h=(1:size(LengthsofFilament,2))


LengthofFilament=LengthsofFilament(h);
NumberofMonomers=LengthofFilament+1;
EveryRunMatrix=zeros(NumberofMonomers,NumberofRuns); % Tracks all the runs for every single monomer



for OriginalPosition=(1:NumberofMonomers) %This starts at 1 for indexing purposes
    
    
    for i=1:NumberofRuns
        
        Position=OriginalPosition;
        Time=0;
        
        IsMotorOnEnd=0;
        
        
        while IsMotorOnEnd<1
            
            p=rand;
            
            
            if p<0.5 && Position~=1
                Position=(Position-1);
            else
                Position=(Position+1);
            end
    
            
            if Position==NumberofMonomers %if it's on the final monomer, the loop stops
                IsMotorOnEnd=1;
            else
                IsMotorOnEnd=0;
            end
            
            Time=Time+1;
               
        end
        
        EveryRunMatrix(OriginalPosition,i)=Time;
      
    end
    
    
end

EveryRunMatrix(NumberofMonomers,:)=0;  % Makes the proteins that start on the end reach the end immedietelty so you don't get weird results with Inf 

TimePerMonomerMatrix(h,1:NumberofMonomers)=mean(EveryRunMatrix,2); %Gives the averages of every one matrix-- the average starting from each monomer

AverageTimeMatrix(1,h)=sum(TimePerMonomerMatrix(h,:))/NumberofMonomers;
end

%---Finding Diffusion Constant-------

Equation= 'a*(x^2)';

x=LengthsofFilament;
y=AverageTimeMatrix;
f=fit(x' , y' , Equation);

AValue=coeffvalues(f); %gives a
    DiffusionConstant=1/(3*AValue); %Because there is only one coefficient, we cannot find the mean of two diffusions constant like in the earlier code

    
    
    
%---Creating the file------------
TimePerMonomerArray=reshape(TimePerMonomerMatrix',1,[]); %this reshapes timepermonomermatrix so it's one straight line. It is reshaped again in the reader code

FindNumberofRuns=6;
FindLengthsofFilament=7;
FindAverageTimeMatrix=7+size(LengthsofFilament,2);
FindDiffusionConstant=FindAverageTimeMatrix+size(AverageTimeMatrix,2);
FindTimePerMonomerArray=FindDiffusionConstant+1;


DataToTrack=[FindNumberofRuns, FindLengthsofFilament, FindAverageTimeMatrix, FindDiffusionConstant, FindTimePerMonomerArray, NumberofRuns, LengthsofFilament, AverageTimeMatrix, DiffusionConstant, TimePerMonomerArray];
 
fileID3 = fopen('sp.filamentlength.onesided.cluster.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack'); %Don't know why this was chosen
fclose(fileID3);

