%%LengthofFilament starts at 0
%%NumberofMonomers is LengthofFilament+1

NumberofRuns=10000;

LengthofFilament=10;
NumberofMonomers=LengthofFilament+1;

EveryRunMatrix=zeros(NumberofMonomers,NumberofRuns); % Tracks all the runs for every single monomer

for OriginalPosition=(1:NumberofMonomers) %This starts at 1 for indexing purposes
    
    for i=1:NumberofRuns
        
        Position=OriginalPosition;
        Time=0;
        
        IsMotorOnEnd=0;
        
        while IsMotorOnEnd<1
          
            p=rand;
            
            if p<0.5 && Position~=1 && Position~=NumberofMonomers %The motor can not move backwards if its position is 1 or NumberofMonomers
                Position=(Position-1);
            else
                Position=(Position+1);
            end
            
            
            
             if Position==NumberofMonomers  %Both ends 
                IsMotorOnEnd=1;
             else
                if Position==1
                    IsMotorOnEnd=1;
                else
                    IsMotorOnEnd=0;
                end
             
                Time=Time+1;
            
              end
        end 
        
        EveryRunMatrix(OriginalPosition,i)=Time;
        
        
    end
          
end

EveryRunMatrix(NumberofMonomers,:)=0;  % Makes the proteins that start on the end reach the end immedietelty so you don't get weird results with Inf 
EveryRunMatrix(1,:)=0; %Does the same thing as above but for monomer 1 (position=0)

AverageTimeMatrix=mean(EveryRunMatrix,2); %Gives the averages of every one matrix-- the average starting from each monomer  
    
%---Finding Diffusion Constant-------

Equation= 'a*(x^2)+b*x';

x=(0:LengthofFilament); % starts at 0 and goes through length of filament to make equation work (position 1=monomer 0)
y=AverageTimeMatrix;
f=fit(x' , y , Equation);

ABValues=coeffvalues(f); %gives a and b

DiffCons=[-1/(2*ABValues(1)) LengthofFilament/(2*ABValues(2))]; %Uses LengthofFilament instead of number of monomers because in equation length 1 monomer=length 0
DiffusionConstant=mean(DiffCons);

%---Creating the file---------

 EveryRunArray=reshape(EveryRunMatrix',1,[]); %this reshapes every run matrix so it's one straight line. It is reshaped in the reader code
 

 
 %These values give the index of datatotrack that each of these categories
 %begin on (i.e. Average time matrix begins on DataToTrack(11) and ends on
 %DataToTrack 11+size(averagetimematrix)-1
 FindNumberofRuns=8;
 FindLengthofFilament=9;
 FindNumberofMonomers=10;
 FindAverageTimeMatrix=11;
 FindDiffCons=FindAverageTimeMatrix+size(AverageTimeMatrix,1);
 FindDiffusionConstant=FindDiffCons+size(DiffCons,1)+1;
 FindEveryRunArray=FindDiffusionConstant+1;
 
DataToTrack=[FindNumberofRuns, FindLengthofFilament, FindNumberofMonomers, FindAverageTimeMatrix, FindDiffCons, FindDiffusionConstant, FindEveryRunArray, NumberofRuns, LengthofFilament, NumberofMonomers, AverageTimeMatrix', DiffCons, DiffusionConstant, EveryRunArray];
 
fileID3 = fopen('TwoSidedOct11.txt','a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack'); %Don't know why this was chosen
fclose(fileID3);
 



    