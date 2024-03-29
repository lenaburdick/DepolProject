clear all
close all

% March 28 2021

%This code was copy and pasted from HighkFall_NultiProteinDiffusion_2_ContShrink.
%This is the version fo this code before making big changes to things like the tracking matrix

%-File Name--------------------------------------------------------------
mainfilename='One_Step'; %main file name (parameters added later)

%-Lengths and Proteins To Run--------------------------------------------
lengths=[20];
proteins=[5 20 80];

%-Rates------------------------------------------------------------------
kLand=.091; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kAssist=100; 
kWalk=3; %Chance of a single motor walking on filament. true kWalk is kWalk*NumberofBoundMotors
kFall=1; % Chance of a single protein falling off (not at end)
kUnassisted=4; % Chance filament will depolymerize without a protein at the end

%-Other Parameters-------------------------------------------------------
NumberofRuns=1000;
MinFilamentSize=2; %How small the filament will shrink to 
BoundEffect=0; %0 if free proteins constant, 1 if free proteins change
DirectEndBinding=0; %if DirectEndBinding=1, proteins can only land on end, if =0, they can land anywhere on filament



%---Cells------------------------------------------------------------------
ProteinTrackingCell=cell(size(lengths,2), size(proteins,2), NumberofRuns);
OccupancyCell=cell(size(lengths,2), size(proteins,2), NumberofRuns);
OutcomeMatrixCell=cell(size(lengths,2), size(proteins,2), NumberofRuns);



l=1; %~~~Lengths Loop~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for l=1:size(lengths,2)

w=1; %~~~Proteins Loop~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for w=1:size(proteins,2)
    
clearvars -except l w lengths proteins kLand kAssist kWalk kFall kUnassisted NumberofRuns MinFilamentSize BoundEffect DirectEndBinding mainfilename OccupancyCell ProteinTrackingCell OutcomeCell %%% add the tracking cells to this too

%---Initializing Starting Length & Proteins--------------------------------
StartingLength=lengths(l); %Number of monomers in filament initially
TotalProteins=proteins(w); %Number of Proteins in system (stand-in for concentration)
ShrinkAmount=StartingLength-MinFilamentSize; %How many monomers will fall off during simulation

%---Setting Parameter Names------------------------------------------------
parameters=join({'Initial Length=' num2str(StartingLength);'Total Proteins=' num2str(TotalProteins); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kLand); 'kAssist=' num2str(kAssist); 'kWalk=' num2str(kWalk); 'kFall=' num2str(kFall); 'kDepol=' num2str(kUnassisted)});

%---Setting File Name------------------------------------------------------
filename=[mainfilename '_1s_'  num2str(DirectEndBinding) 'b_' num2str(kUnassisted) 'kD_' num2str(kFall) 'kF_'  num2str(BoundEffect) 'c_' num2str(kWalk) 'kW_' num2str(kAssist) 'kA_' num2str(kLand) 'kO_' num2str(NumberofRuns) 'r_L' num2str(StartingLength) '_P' num2str(TotalProteins)]; 
filename=strrep(filename,'.','-'); %Replaces '.' in variables with '-' so it can be read

%---Colors-----------------------------------------------------------------

%Graph Textbox Background Color
TextboxColor=[1 1 1]; %[0.471 0.116 0.161];


%---Tracking Matrices------------------------------------------------------
% % % NumberBoundCell=cell(NumberofRuns, 1);
% % % OutcomeCell=cell(NumberofRuns, 1);
% % % DTCell=cell(NumberofRuns, 1);
% % % ProteinTrackingCell=cell(NumberofRuns, 1);

% kOnTrackingCell=cell(NumberofRuns, 1);
% kWalkTrackingCell=cell(NumberofRuns, 1);
% kAssistTrackingCell=cell(NumberofRuns, 1);






TimeAtLength=zeros(NumberofRuns, ShrinkAmount); %Time Spent at each length
TimeAtLengthCum=zeros(NumberofRuns, ShrinkAmount); %Time spent at each length, cumulative


for h=1:NumberofRuns
 
     
%---INITIALIZING Values (Reset after each depolymerizing event)

%---Length
CurrentLength=StartingLength;  
NumberofMonomers=CurrentLength+1;

%---Motor Tracking Matrix
ProteinTrackingMatrix=zeros(1,13); 
ProteinTrackingMatrix(1,1)=(1);
    % 1: motor number
            %The proteins are numbered as they land
    % 2: step it landed
    % 3: time it landed
    % 4: position it landed in
    % 5: length of filament when it landed
    % 6: current Position
    % 7: number of walk steps it took
    % 8: step when it fell off
    % 9: time when it fell off
    % 10: position it fell from
    % 11: length of filament when it fell
    % 12: Did the protein assist the depolymerization (1=yes, 0=no)
    % 13: How long did the protein spend on the end?
  
                 
OccupancyMatrix=zeros(1,NumberofMonomers); % Shows how many proteins are on each monomer at a given time
    %Each column is a different monomer
    %Each row is a different step
    
OutcomeMatrix=zeros(1,12); %Shows outcome (on, off, or walk) of each step of simulation
    %Each column is a different data point
        % 1: Step Number
        % 2: (Total) DT
        % 3: Length
        % 4: Number of Bound Proteins
        % 5: Outcome (1,2,3,4, or 5 for each rate)
        % 6: Walk Protein (If applicable, 0 otherwise)
        % 7: Walk Direction (If applicable, 0 otherwise)
        % 8: True kOn
        % 9: True kAssist
        % 10: True kWalk
        % 11: True kFall
        % 12: True kUnassisted (same as kUnassisted)
    %Each row is a different step



ProteinsLanded=0;
DepolEvents=0;

DT=0;
j=0; % Way of tracking number of runs through while loop

BoundProteins(1)=0; %Shows how many proteins bound at each step



FreeProteins(1)=TotalProteins;




OccupancyArray=zeros(1,NumberofMonomers);


while DepolEvents<ShrinkAmount
    
    
j=j+1;
    
OccupancyArray=OccupancyMatrix(end,:); %gets the last value of the occupancy array... is this necessary?
OutcomeArray=zeros(1,12); % resets the outcome array to 0


    
%---Setting Rates----------------------------------------------------------

    k1=kLand*FreeProteins(j)*CurrentLength; %kOn times number of free motors times length of filament
   
    if sum(ProteinTrackingMatrix(:,6)==NumberofMonomers)>0
        k2=kAssist;
    else
        k2=0;
    end
    
    if sum(ProteinTrackingMatrix(:,6))>0  % If there is a protein anywhere on the filament
        k3=kWalk*sum(ProteinTrackingMatrix(:,6)>0); %kWalk * The number of bound motors
    else
        k3=0;
    end
    
    if sum(ProteinTrackingMatrix(:,6))>0 % If there is a protein anywhere on the filament 
        k4=kFall*sum(ProteinTrackingMatrix(:,6)>0); %kFall * The number of bound motors
    else
        k4=0;
    end
    
    
    k5=kUnassisted;
    
    
    kTotal=k1+k2+k3+k4+k5;
    
    %---Outcome Array---
    OutcomeArray(8)=k1;
    OutcomeArray(9)=k2;
    OutcomeArray(10)=k3;
    OutcomeArray(11)=k4;
    OutcomeArray(12)=k5;
     
    
    
    
%---Outcomes (Land, Walk, Assist, Fall, Depol)---------------------------------------------
    
    p=rand;
    DT(j)=exprnd(1/kTotal);
   
    if p<k1/kTotal % LAND ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        
        if DirectEndBinding==1 % This value is determined at top of code. If DirectEndBinding=1, proteins can only land on end. If =0, they can land anywhere on the filament.
            LandPosition=NumberofMonomers;
        else
            LandPosition=ceil(p/(k1/kTotal)*NumberofMonomers); %Which position "bin" the number falls into
        end
        
        ProteinsLanded=ProteinsLanded+1;
        FreeProteins(j+1)=max(FreeProteins(j)-1*BoundEffect,0);
        
% % %         ProteinTrackingMatrix(ProteinsLanded,1)=ProteinsLanded;
% % %         ProteinTrackingMatrix(ProteinsLanded,2)=sum(DT); %Time Landed
% % %         ProteinTrackingMatrix(ProteinsLanded,3)=LandPosition; %Position Landed
% % %         ProteinTrackingMatrix(ProteinsLanded,4)=LandPosition; %Current Position
% % %         ProteinTrackingMatrix(ProteinsLanded,5)=0; %Position it fell off from
% % %         ProteinTrackingMatrix(ProteinsLanded,6)=0; %Time when Fell Off
% % %         ProteinTrackingMatrix(ProteinsLanded,7)=0;%Position it depolled from (length at that time)
% % %         ProteinTrackingMatrix(ProteinsLanded,8)=0; %Time when reached end
% % %         ProteinTrackingMatrix(ProteinsLanded,9)=0; %Time after depol
        
        
        %---New Stuff-----------------
        
        ProteinTrackingMatrix(ProteinsLanded,1)=ProteinsLanded; % Gives the protein a number based on the order it fell
        ProteinTrackingMatrix(ProteinsLanded,2)=j; % Step of simulation
        ProteinTrackingMatrix(ProteinsLanded,3)=sum(DT); % Time of simulation
        ProteinTrackingMatrix(ProteinsLanded,4)=LandPosition; % Position Landed
        ProteinTrackingMatrix(ProteinsLanded,5)=NumberofMonomers; % Length of filament at this time
        ProteinTrackingMatrix(ProteinsLanded,6)=LandPosition; % Current Position
        ProteinTrackingMatrix(ProteinsLanded,7)=0; % Total walk steps
        ProteinTrackingMatrix(ProteinsLanded,8)=0; % Step of simulation when protein disassociates
        ProteinTrackingMatrix(ProteinsLanded,9)=0; % Time of simulation when protein disassociates
        ProteinTrackingMatrix(ProteinsLanded,10)=0; % Position protein disassociates from
        ProteinTrackingMatrix(ProteinsLanded,11)=0; % Length of the filament when the protein disassociates
        ProteinTrackingMatrix(ProteinsLanded,12)=0; % Turns to 1 if the protein assists the filament to depolymerize (0 if depols independently)
        ProteinTrackingMatrix(ProteinsLanded,13)=0; % Time the protein spends on the end 
        
        %------------------------------
        
        
        
        
        
        OccupancyArray(LandPosition)=OccupancyArray(LandPosition)+1;
        
        Outcome=1;
        
    else % ASSIST ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if p>k1/kTotal && p<(k1+k2)/kTotal
            
            
            DepolEvents=DepolEvents+1;
          
            
            TimeAtLength(h,DepolEvents)=sum(DT)-sum(TimeAtLength(h,:)); %Time sim spent at this length
            TimeAtLengthCum(h,DepolEvents)=sum(DT); %Time this run of simulation takes before this depol event
            
            FreeProteins(j+1)=FreeProteins(j)+OccupancyArray(NumberofMonomers)*BoundEffect;
       
% % %             ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,7)=NumberofMonomers; %The length of the filament at the time this protein reached the end
% % %             ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,8)=sum(DT)-DT(j); % The total time of the simulation minus the current DT
% % %             ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,9)=sum(DT); %The total time of sim after depol
% % %             ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,4)=0; %Resets position of protein to 0 --> Proteins don't rejoin pool & just stay 0 since others are available
% % %             
            
            %---New Stuff-----------------
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,8)=j; % Step of simulation when protein disassociates
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,9)=sum(DT); % The time of the simulation after depol event
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,10)=NumberofMonomers; % Position of protein when it fell
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,11)=NumberofMonomers; % Length of filament when protein dissassociates
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,12)=0; % Did it assist? %%%%% Work on this later
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,13)= sum(DT)-ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,13); %%%% Work On This Later % Amount of time protein on end (current time minus time arrived on end)
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,6)=0; % Resets protein position to 0
                       
            
            OccupancyArray(NumberofMonomers:end)=NaN;
            
            CurrentLength=CurrentLength-1;
            NumberofMonomers=NumberofMonomers-1;
            
            Outcome=2;
            
% % %             kOnTrackingMatrix(DepolEvents,h)=mean(kOnTrackingArray);
% % %             kWalkTrackingMatrix(DepolEvents,h)=mean(kWalkTrackingArray);
% % %             kAssistTrackingMatrix(DepolEvents,h)=mean(kWalkTrackingArray);
            
        else % WALK ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            if p>(k1+k2)/kTotal && p<(k1+k2+k3)/kTotal
                
                BoundProteinArray=find(ProteinTrackingMatrix(:,6)~=0);
                q=p-(k1+k2)/kTotal; %This is how far p is away from the edge of the "walk bin"
                WalkInteger=ceil(q/((k3/kTotal)/(size(BoundProteinArray,1)*2)));
                ProteinToWalk=BoundProteinArray(ceil(WalkInteger/2)); %Does this make the higher indexed motors more likely to walk?

                    if mod(WalkInteger,2)~=0 && ProteinTrackingMatrix(ProteinToWalk,6)~=1 %whether or not its even or odd
                        WalkDirection=-1;
                    else
                        if ProteinTrackingMatrix(ProteinToWalk,6)~=NumberofMonomers % If the protein is not on the end
                            WalkDirection=1;
                        else
                            WalkDirection=-1; % If the protein is on the end, the walk direction is negative regardless of the value of p/q
                        end % Is this okay? IF PROBLEM: look here, this sub-if loop was written quickly & sloppily
                    end
                    
                %---New Stuff-----
                
                %---Is/Was Protein On End?---
                % (1,0)= is now on end (0,1)= was on end but walked off (0,0)= is not on end, was not on end
                if ProteinTrackingMatrix(ProteinToWalk,6)+WalkDirection==NumberofMonomers %If the protein IS on the end after walking
                   ProteinNearEnd(1,1)=1;
                else
                    ProteinNearEnd(1,1)=0;
                end
                if ProteinTrackingMatrix(ProteinToWalk,6)==NumberofMonomers %If the protein WAS on the end before walking
                   ProteinNearEnd(1,2)=1;
                else
                    ProteinNearEnd(1,2)=0;
                end

    
                %---Outcome Array---
                OutcomeArray(6)=ProteinToWalk; % tracks which protein walked during this step
                OutcomeArray(7)=WalkDirection; % shows which way the protein walked
                    
                %---Occupancy Array---
                OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,6))=OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,6))-1; %Removes protein from its original position

                OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,6)+WalkDirection)=OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,6)+WalkDirection)+1; %Adds  protein to new position
                
                %---Protein Tracking Matrix---
                
                ProteinTrackingMatrix(ProteinToWalk,6)=ProteinTrackingMatrix(ProteinToWalk,6)+WalkDirection; %Current Position either forward or back
                ProteinTrackingMatrix(ProteinToWalk,7)=ProteinTrackingMatrix(ProteinToWalk,7)+1; % Total time protein has walked

                
                
                if ProteinNearEnd(1,2)==1 %If this protein was on the end, but walked off
                    ProteinTrackingMatrix(ProteinToWalk,13)=0; %How long protein on end tracker resets to 0
                end
                if ProteinNearEnd(1,2)==1 %If this protein is now on the end
                    ProteinTrackingMatrix(ProteinToWalk,13)=sum(DT); %starts keeping track of how long the protein was on the end
                end
                
                
                
                
% % %                 ProteinTrackingMatrix(ProteinToWalk,4)=ProteinTrackingMatrix(ProteinToWalk,4)+WalkDirection; %Current Position either forward or back
 
                
                
                
                Outcome=3;
                
% % %                 OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,4))=OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,4))+1; %Adds protein to its new position
                
                FreeProteins(j+1)=FreeProteins(j);
                
                
            else % FALL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                
             if p>(k1+k2+k3)/kTotal && p<(k1+k2+k3+k4)/kTotal
                BoundProteinArray=find(ProteinTrackingMatrix(:,6)~=0);
                q=p-(k1+k2+k3)/kTotal; %This is how far p is away from the edge of the "fall bin"
                FallInteger=ceil(q/((k4/kTotal)/size(BoundProteinArray,1)));
                ProteinToFall=BoundProteinArray(FallInteger);
                
                OccupancyArray(ProteinTrackingMatrix(ProteinToFall,6))=OccupancyArray(ProteinTrackingMatrix(ProteinToFall,6))-1; %Removes protein from position it falls from
                
                
% % %                 ProteinTrackingMatrix(ProteinToFall,5)=ProteinTrackingMatrix(ProteinToFall,4); %Position protein was in when it fell off
% % %                 ProteinTrackingMatrix(ProteinToFall,4)=0;
% % %                 ProteinTrackingMatrix(ProteinToFall,6)=sum(DT); %Time when protein fell off (including time taken to fall)
                
                %---New Stuff---
                
                ProteinTrackingMatrix(ProteinToFall,8)=j; % Step of simulation when protein fell
                ProteinTrackingMatrix(ProteinToFall,9)=sum(DT); % Time of simulation when protein fell
                ProteinTrackingMatrix(ProteinToFall,10)=ProteinTrackingMatrix(ProteinToFall,6); % Position Protein fell from
                ProteinTrackingMatrix(ProteinToFall,11)=NumberofMonomers; % Length of filament when protein fell
% % %                 ProteinTrackingMatrix(ProteinToFall,13)= % WORK ON THIS LATER
                ProteinTrackingMatrix(ProteinToFall,6)=0; % Current Position resets to 0
                
                
                
                
                
                
                
                FreeProteins(j+1)=FreeProteins(j)+1*BoundEffect;
                
                Outcome=4;
                
             else % DEPOL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                 
                 DepolEvents=DepolEvents+1; %How many times the filament has depolymerized during this run
           
                 TimeAtLength(h,DepolEvents)=sum(DT)-sum(TimeAtLength(h,:)); %Time sim spent at this length
                 TimeAtLengthCum(h,DepolEvents)=sum(DT); %Time this run of simulation takes before this depol event
                              
                 FreeProteins(j+1)=FreeProteins(j)+OccupancyArray(NumberofMonomers)*BoundEffect; % The number of free proteins increases by amount of proteins on end monomer. This hsould always be zero, but added just in case.
                 
                 OccupancyArray(NumberofMonomers)=NaN; %the last monomer falls off (is no longer a spot to occupy)
% % %                  
% % %                 ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,7)=NumberofMonomers; %The length of the filament at the time this protein reached the end
% % %                 ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,8)=sum(DT)-DT(j); % The total time of the simulation minus the current DT, not super useful in this case but kept just in case
% % %                 ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,9)=sum(DT); %The total time of sim after depol
% % %                 ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,10)=1; % set to 1 to indicate that the filament depolled independently and not because of the protein
% % %                 ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,4)=0; %Resets position of protein to 0 --> Proteins don't rejoin pool & just stay 0 since others are available
% % %             
                %---New Stuff---
                
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,8)=j; % Step when filament depolymerized
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,9)=sum(DT); % Simulation time when filament depolled
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,10)=NumberofMonomers; % Length of filament BEFORE depolymerization (protein position)
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,11)=NumberofMonomers; % Length of filament BEFORE depolymerization
 % % %                 ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,12)=0; % Filament depolled independently %%% WORK ON THIS LATER
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,13)= sum(DT)-ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,13); %%%WORK ON THIS LATER % Amount of time protein on end (current time minus time arrived on end)
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,6)= 0; % Resets position of all proteins on end to 0    

                
                
                
                 CurrentLength=CurrentLength-1;
                 NumberofMonomers=NumberofMonomers-1;


                 Outcome=5;
             end
                
            end
        end
    end
    
    
%---Outcome Array----------------------------------------------------------
OutcomeArray(1)=j; % Step number
OutcomeArray(2)=sum(DT); %time at step
OutcomeArray(3)= CurrentLength;
OutcomeArray(4)=size(ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)>0),1); %copy and pasted from previous BoundProteins definition, changed 4 to 6
OutcomeArray(5)=Outcome; 

    
    
%%% BoundProteins(j+1)=size(ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)>0),1); %Tracks how many proteins are bound to the filament during this step
% % % OutcomeMatrix(j+1)=Outcome; %Tracks what the outcome is this step
OccupancyMatrix=[OccupancyMatrix;OccupancyArray];
OutcomeMatrix(j,:)=OutcomeArray;




%     Outcome
%     DT(j)
%     sum(DT)
%     ProteinTrackingMatrix
%     OccupancyArray
%     FreeProteins(j+1)
%     BoundProteins(j+1)

% % % OutcomeArray
% % % OccupancyArray
% % % ProteinTrackingMatrix

% OccupancyMatrix
% OccupancyArray
% OutcomeMatrix

end

%---Tracking/Storing Data in Cells-----------------------------------------
NumberBoundCell{h,1}=BoundProteins;
DTCell{h,1}=DT;

OutcomeCell{l,w,h}=OutcomeMatrix;
ProteinTrackingCell{l,w,h}=ProteinTrackingMatrix;
OccupancyCell{l,w,h}=OccupancyMatrix;


end





avgCumTime=[0 mean(TimeAtLengthCum)]; %avg cumulative time of the sim after each depol event
avgStepTime=[1./mean(TimeAtLength)]; %avg depol rate at each depol event

DataToTrack=[BoundEffect DirectEndBinding kFall kUnassisted kWalk kLand kAssist NumberofRuns StartingLength TotalProteins size(avgStepTime,2) size(avgCumTime,2) avgStepTime avgCumTime];

% % % matfile=[filename '.mat'];
% % % save(matfile); %saves all the workspace values (cells, matrices, etc) from this run
% % % 
% % % textfile=[filename '.txt']; %saves array variables that can easily be read from a .txt file in a reader code
% % % fileID3 = fopen(textfile,'a'); 
% % % fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack'); %Don't know why this was chosen
% % % fclose(fileID3);



%one sided, direct end binding, falling?, depolling on own?, concentration?

figdescription{1}=['DESCRIPTION'];
figdescription{2}=['One-Sided Depolymerization'];
if BoundEffect==0
    figdescription{3}=['(High Conc. System) Constant Free Protein Concentration'];
else
    figdescription{3}=['(Low Conc. System) Limited Free Protein Concentration'];
    
end 

if DirectEndBinding==1
    figdescription{4}=['Direct End Binding Only'];
else
    if kFall==0
        figdescription{4}=['Proteins: Bind | Diffuse in 1D | Dissassociate At Filament End Only'];
    else
        figdescription{4}=['Proteins: Bind | Diffuse in 1D | Dissassociate Independently Or At End'];
    end 
end 


if kUnassisted==0
    figdescription{5}=['Filament: Depolymerizes Only When Protein Is On End'];
else
    figdescription{5}=['Filament: Depolymerizes Independently Or When Protein Is On End'];
    
end 






FigArray(1)=figure;

%---Length Versus Total Time Plot------------------------------------------

%---Plotting Every Run
for h=1:NumberofRuns
    
    y=StartingLength-(0:ShrinkAmount);
    x=[0 TimeAtLengthCum(h,:)]; %Total time of sim after each step for every run (h)
    
    p=plot(x,y);
    
    hold on
    
end

set(p, 'visible', 'off') %%%%%%%%%%%%%

%---Plotting avg of all runs

%Setting xavg (avg total time taken to get to length y)
avgCumTime=[0 mean(TimeAtLengthCum)];

pavg=plot(avgCumTime,y, '-dw');
pavg.LineWidth=6;

%---Setting Titles
xlabel('Total Time Elapsed (in units time)');
ylabel('Length of Filament (in Monomers)');
title('Total Time For Filament To Depolymerize From L to L-x');

%---Setting Figure Properties 

set(gca, 'Units', 'normalized');
set(gca, 'OuterPosition', [0,.27,1,.73]); %  graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)


set(gca, 'fontsize',12);
set(gca, 'YLim',[min(y),max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)



%---Paremter Textbox
ParTextbox=annotation('textbox', [0.6, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=12;
ParTextbox.FontName='FixedWidth'; % To match data figure 2
ParTextbox.BackgroundColor=TextboxColor;
ParTextbox.FaceAlpha=.7; %Transparency of textbox background
%---FigDescription Textbox
DesTextbox=annotation('textbox', [0.05, 0.15, 0.1, 0.1], 'String', figdescription, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
DesTextbox.FontSize=12;


% %---Data Textbox
% 
% %Displaying only 2 decimal places
% for h=1:size(avgCumTime,2)
% xavgString{1,h}=sprintf('%.2f',avgCumTime(h))
% end
% xavgString=join(xavgString); %makes it cell that can be combined with the labels
% 
% avgVal=['Average (Total) Time Until Each Depol Event = ' xavgString]
% 
% DataTextbox=annotation('textbox', [0.05, 0, 0.15, 0.15], 'String', avgVal, 'FitBoxToText','on'); %text box horizontally offset (from left) 15% of figure's width & vertically offset (from bottom) 0%. Box fits around text. Default Height is 10% of height x 10% width
% DataTextbox.FontSize=12;
% DataTextbox.FontName='FixedWidth' % To match data figure 2

hold off
% 
% 
% 

FigName=[filename 'LengthTime.jpg'];
% % % % saveas(gcf,FigName); %saves current figure (gcf) as a jpeg (extension specified in name)

FigName=[filename 'LengthTime.eps'];
% % % saveas(gcf,FigName); %saves current figure (gcf) as a eps for Adobe Illustrator (extension specified in name)



FigArray(2)=figure;

%---Depol Rate Versus Current Length Plot----------------------------

%Setting x (the length the filament is shrinking FROM)
x=-((0:ShrinkAmount-1)-StartingLength);

%---Plotting each run
for h=1:NumberofRuns
    
    y=[TimeAtLength(h,:)];
    
    p=plot(x,y);
    
    hold on
end

set(p, 'visible', 'off') %%%%%%%%%%%%%

%---Plotting average of all runs

%Setting yavg (the average of each run)
avgStepTime=[mean(TimeAtLength)];

pavg=plot(x,avgStepTime,'-dw');
pavg.LineWidth=6;

%---Setting figure properties

set(gca, 'OuterPosition', [0.05,.27,1,.73]); % graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)
set(gca, 'fontsize',14);

set(gca, 'XLim',[min(x),max(x)]); %graph for some reason showing one blank data point at beginning (x=LengthofFilament), this fixes that (max(xavg)=LengthofFilament-1)

set(gca, 'XDir','reverse'); %so x is shown shrinking instead of growing, must be under setting XLim


%---Setting Titles
title('Time Until Depolymerization At L=x to L=x-1');
xlabel('Length (in Monomers) Filament Is Shrinking From');
ylabel('Time Taken To Depolymerize');


% %---Data Textbox
% 
% %Creates Labels
% avgText=["Time Between Each Depol Event: "; "When Shrinking to L = "]; %Creates String Array for labels
% avgText=pad(avgText); %Makes them both the same number of characters
% 
% %Creates string array of data points
% for u=(1:ShrinkAmount)
% stry=sprintf('%.2f',avgStepTime(u)); % displays only two decimals
% strx=num2str(x(u));
% avgData{1,u}=stry;
% avgData{2,u}=strx;
% end
% 
% 
% avgData=pad(avgData); %Makes all data same number of characters (so they line up)
% avgData=join(avgData); % Joins all data as two rows (so it can be but in array with labels)
% 
% %Combines labels and data points
% avgVal=[avgText avgData];
% avgVal=join(avgVal);
% 
% %Creates textbox
% DataTextbox=annotation('textbox', [0.05, 0, 0.15, 0.15], 'String', [avgVal], 'FitBoxToText','on'); %text box horizontally offset (from left) 15% of figure's width & vertically offset (from bottom) 0%. Box fits around text. Default Height is 10% of height x 10% width
% DataTextbox.FontSize=12;
% DataTextbox.FontName='FixedWidth' % Font makes it so all data lines up

%---Paremter Textbox
ParTextbox=annotation('textbox', [0.65, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=12;
ParTextbox.FontName='FixedWidth'; % To match data figure 2
ParTextbox.BackgroundColor=TextboxColor;
ParTextbox.FaceAlpha=.7; %Transparency of textbox background

%---FigDescription Textbox
DesTextbox=annotation('textbox', [0.05, 0.15, 0.1, 0.1], 'String', figdescription, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
DesTextbox.FontSize=12;

hold off

FigName=[filename 'DepolTime.jpg'];
% % % saveas(gcf,FigName); %saves current figure (gcf) as a jpeg (extension specified in name)

FigName=[filename 'DepolTime.eps'];
% % % saveas(gcf,FigName); %saves current figure (gcf) as a eps for Adobe Illustrator (extension specified in name)


%Saving figures
FigArrayName=[filename '.fig'];
% % % savefig(FigArray,FigArrayName,'compact');


w=w+1
end

l=l+1
end


% textfile2=[filename 'AvgRates.txt'] %saves the avg rate data
% fileID3 = fopen(textfile2,'a');
% fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack'); %Don't know why this was chosen
% fclose(fileID3);