clear all
close all

% April 15 2021

%This code was copy and pasted from Jenna_Unassisted.m

%This simulation measures the average instantaneous depolymerization rate
%as a filament shrinks by one monomer at four different lengths.

%Rates are based on Helenius paper

%Updated July 13 2021

%-File Name--------------------------------------------------------------
mainfilename='Jenna_EndBinding_LVD'; %main file name (parameters added later)

%-Save This Run?---------------------------------------------------------
saverun=1; %Saves the data if =1, doesn't if =0

%-Lengths and Proteins To Run--------------------------------------------
lengths=[1050 1025 1000 975]; %shrinking from 8.4 to 7.8um, like helenius paper
proteins=[5]; % 5nM

%-Rates------------------------------------------------------------------
kLand=0.00512; % /sec %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kAssist=4.17; % /nM/sec
kWalk=0; %Chance of a single motor walking on filament. true kWalk is kWalk*NumberofBoundMotors
kFall=0; % Chance of a single protein falling off (not at end)
kUnassisted=0; %monomers/sec % Chance filament will depolymerize without a protein at the end

%-Other Parameters-------------------------------------------------------
NumberofRuns=10000;
MinFilamentSize=[1049 1024 999 974]; %How small the filament will shrink to 
BoundEffect=0; %0 if free proteins constant, 1 if free proteins change
DirectEndBinding=1; %if DirectEndBinding=1, proteins can only land on end, if =0, they can land anywhere on filament

%---Measurements-------------------------------
MonomerMeasurement=0.008; %This is the length of monomer in um


%---Cells------------------------------------------------------------------
ProteinTrackingCell=cell(size(lengths,2), size(proteins,2), NumberofRuns);
OccupancyCell=cell(size(lengths,2), size(proteins,2), NumberofRuns);
OutcomeMatrixCell=cell(size(lengths,2), size(proteins,2), NumberofRuns);



l=1; %~~~Lengths Loop~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for l=1:size(lengths,2)

w=1; %~~~Proteins Loop~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for w=1:size(proteins,2)
    
clearvars -except l w lengths proteins kLand kAssist kWalk kFall kUnassisted NumberofRuns MinFilamentSize BoundEffect DirectEndBinding mainfilename OccupancyCell ProteinTrackingCell OutcomeCell avgCumTimeCell MonomerMeasurement DepolRateCell saverun avgDepolRateMatrix CumTimeCell %%% add the tracking cells to this too

%---Initializing Starting Length & Proteins--------------------------------
StartingLength=lengths(l); %Number of monomers in filament initially
TotalProteins=proteins(w); %Number of Proteins in system (stand-in for concentration)
ShrinkAmount=StartingLength-MinFilamentSize(l); %How many monomers will fall off during simulation

%---Setting Parameter Names------------------------------------------------
parameters=join({'Initial Length=' num2str(StartingLength);'Total Proteins=' num2str(TotalProteins); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kLand); 'kAssist=' num2str(kAssist); 'kWalk=' num2str(kWalk); 'kFall=' num2str(kFall); 'kDepol=' num2str(kUnassisted)});

%---Setting File Name------------------------------------------------------
filename=[mainfilename '_1s_'  num2str(DirectEndBinding) 'b_' num2str(kUnassisted) 'kD_' num2str(kFall) 'kF_'  num2str(BoundEffect) 'c_' num2str(kWalk) 'kW_' num2str(kAssist) 'kA_' num2str(kLand) 'kO_' num2str(NumberofRuns) 'r_L' num2str(StartingLength) '_P' num2str(TotalProteins)]; 
filename=strrep(filename,'.','-'); %Replaces '.' in variables with '-' so it can be read

%---Colors-----------------------------------------------------------------

%Graph Textbox Background Color
TextboxColor=[1 1 1]; %[0.471 0.116 0.161];


%---Tracking Matrices------------------------------------------------------

TimeAtLength=zeros(NumberofRuns, ShrinkAmount); %Time Spent at each length
TimeAtLengthCum=zeros(NumberofRuns, ShrinkAmount); %Time spent at each length, cumulative


%~~~RUN LOOP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %(each run is one filament depolymerizing fully)
        
for h=1:NumberofRuns
 
     
%~~~INITIALIZING VALUES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %(That Reset after each depolymerizing event)

%---Length-----
CurrentLength=StartingLength;  
NumberofMonomers=CurrentLength+1;

%---Motor Tracking Matrix-----
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
  
%---Occupancy Matrix-----                 
OccupancyMatrix=zeros(1,NumberofMonomers); % Shows how many proteins are on each monomer at a given time
    %Each column is a different monomer
    %Each row is a different step
OccupancyArray=zeros(1,NumberofMonomers);

%---Outcome Matrix-----    
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

%---Time, Steps, Depol Events-----
DT=0;
j=0; % Way of tracking number of runs through while loop
DepolEvents=0; % How many times has this filament depolled

%---Landed, Bound, and Free Proteins-----
ProteinsLanded=0; % How many Proteins have landed so far
BoundProteins(1)=0; %Shows how many proteins bound at each step
FreeProteins(1)=TotalProteins;


%~~~DEPOLYMERIZATION LOOP~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %(Each run through loop is one depol event)
        
while DepolEvents<ShrinkAmount
    
%---Counting While Loop-----   
j=j+1;

%---Initializing Arrays-----    
OccupancyArray=OccupancyMatrix(end,:); %gets the last value of the occupancy array... is this necessary?
OutcomeArray=zeros(1,12); % resets the outcome array to 0

   
%~~~SETTING RATES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

 %-- k1 (kLand)
    if DirectEndBinding==1
        k1=kLand*FreeProteins(j)*1;
    else
        k1=kLand*FreeProteins(j)*CurrentLength; %kOn times number of free motors times length of filament
    end
 %-- k2 (kAssist)    
    if sum(ProteinTrackingMatrix(:,6)==NumberofMonomers)>0
        k2=kAssist;
    else
        k2=0;
    end
 %-- k3 (kWalk)    
    if sum(ProteinTrackingMatrix(:,6))>0  % If there is a protein anywhere on the filament
        k3=kWalk*sum(ProteinTrackingMatrix(:,6)>0); %kWalk * The number of bound motors
    else
        k3=0;
    end
 %-- k4 (kFall)    
    if sum(ProteinTrackingMatrix(:,6))>0 % If there is a protein anywhere on the filament 
        k4=kFall*sum(ProteinTrackingMatrix(:,6)>0); %kFall * The number of bound motors
    else
        k4=0;
    end
    
 %-- k5 (kUnassisted)   
    k5=kUnassisted;
    
 %-- kTotal  
    kTotal=k1+k2+k3+k4+k5;
    
%---Outcome Array---
    OutcomeArray(8)=k1; %Tracks k1
    OutcomeArray(9)=k2; %Tracks k2
    OutcomeArray(10)=k3; %Tracks k3
    OutcomeArray(11)=k4; %Tracks k4
    OutcomeArray(12)=k5; %Tracks k5
       
    
%~~~OUTCOMES~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Determines what simulation does based on randomly generated number

%---Generate Random Numbers-----        
    p=rand; % Determines Outcome
    DT(j)=exprnd(1/kTotal); % Determines Time of Step
   
%---LAND (k1)-----    
    if p<k1/kTotal
          
        if DirectEndBinding==1 % If DirectEndBinding=1, proteins can only land on end. If =0, they can land anywhere on the filament.
            LandPosition=NumberofMonomers;
        else
            LandPosition=ceil(p/(k1/kTotal)*NumberofMonomers); %Which position "bin" the number falls into
        end
        
        %---Tracking Free and Landed Proteins
        ProteinsLanded=ProteinsLanded+1;
        FreeProteins(j+1)=max(FreeProteins(j)-1*BoundEffect,0);
        

        %---Protein Tracking Matrix------
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
        ProteinTrackingMatrix(ProteinsLanded,13)=0; % Time the protein spends on the en
        %--------------------------------
        
        %---Occupancy Array--------------
        OccupancyArray(LandPosition)=OccupancyArray(LandPosition)+1;
        %--------------------------------
        
        %---Outcome----------------------
        Outcome=1;
        %--------------------------------
        
%---ASSIST (k2)-----    
    else 
        if p>k1/kTotal && p<(k1+k2)/kTotal
            
            %---Depol Events-----
            DepolEvents=DepolEvents+1;
          
            %---TIME AT LENGTH ARRAY-----
            TimeAtLength(h,DepolEvents)=sum(DT)-sum(TimeAtLength(h,:)); %Time sim spent at this length
            TimeAtLengthCum(h,DepolEvents)=sum(DT); %Time this run of simulation takes before this depol event
            
            %---Free Proteins-----
            FreeProteins(j+1)=FreeProteins(j)+OccupancyArray(NumberofMonomers)*BoundEffect;
       
  
            %---Protein Tracking Matrix------
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,8)=j; % Step of simulation when protein disassociates
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,9)=sum(DT); % The time of the simulation after depol event
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,10)=NumberofMonomers; % Position of protein when it fell
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,11)=NumberofMonomers; % Length of filament when protein dissassociates
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,12)=0; % Did it assist? %%%%% Work on this later
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,13)= sum(DT)-ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,13); %%%% Work On This Later % Amount of time protein on end (current time minus time arrived on end)
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,6)=0; % Resets protein position to 0
            %--------------------------------           
            
            %---Occupancy Array--------------
            OccupancyArray(NumberofMonomers:end)=NaN;
            %--------------------------------           
            
            %---Outcome----------------------
            Outcome=2;
            %--------------------------------
            
            %---DECREASING LENGTH-----
            CurrentLength=CurrentLength-1;
            NumberofMonomers=NumberofMonomers-1;
            
            
%---WALK (k3)-----
        else 
            if p>(k1+k2)/kTotal && p<(k1+k2+k3)/kTotal
                
                
                %---Finding Walk Protein and Direction-----
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
                    
                
                %---Is/Was Protein On End?---
                    % (1,0)= is now on end (0,1)= was on end but walked off (0,0)= is not on end, was not on end
                    % This is so you can get a proper "time on end" measurement
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
                %---------------------------

    
                %---Outcome----------------------
                OutcomeArray(6)=ProteinToWalk; % tracks which protein walked during this step
                OutcomeArray(7)=WalkDirection; % shows which way the protein walked
                %--------------------------------
                    
                %---Occupancy Array--------------
                OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,6))=OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,6))-1; %Removes protein from its original position
                OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,6)+WalkDirection)=OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,6)+WalkDirection)+1; %Adds  protein to new position
                %--------------------------------
                
                %---Protein Tracking Matrix------
                ProteinTrackingMatrix(ProteinToWalk,6)=ProteinTrackingMatrix(ProteinToWalk,6)+WalkDirection; %Current Position either forward or back
                ProteinTrackingMatrix(ProteinToWalk,7)=ProteinTrackingMatrix(ProteinToWalk,7)+1; % Total times protein has walked
                %--------------------------------
                
                %---Time Protein Spent on End----
                %Sums the total time a protein was on the end of the filament before a depol event occurs
                if ProteinNearEnd(1,2)==1 %If this protein was on the end, but walked off
                    ProteinTrackingMatrix(ProteinToWalk,13)=0; %How long protein on end tracker resets to 0
                end
                if ProteinNearEnd(1,2)==1 %If this protein is now on the end
                    ProteinTrackingMatrix(ProteinToWalk,13)=sum(DT); %starts keeping track of how long the protein was on the end
                end
                %--------------------------------                
                
                %---Outcome----------------------
                Outcome=3;
                %--------------------------------
                
                %---Free Proteins-----
                FreeProteins(j+1)=FreeProteins(j);
                
%---FALL (k4)-----                
            else
                
             if p>(k1+k2+k3)/kTotal && p<(k1+k2+k3+k4)/kTotal
                 
                %---Finding Protein To Fall-----
                BoundProteinArray=find(ProteinTrackingMatrix(:,6)~=0);
                q=p-(k1+k2+k3)/kTotal; %This is how far p is away from the edge of the "fall bin"
                FallInteger=ceil(q/((k4/kTotal)/size(BoundProteinArray,1)));
                ProteinToFall=BoundProteinArray(FallInteger);

                %---Occupancy Array--------------                
                OccupancyArray(ProteinTrackingMatrix(ProteinToFall,6))=OccupancyArray(ProteinTrackingMatrix(ProteinToFall,6))-1; %Removes protein from position it falls from
                %--------------------------------

                %---Protein Tracking Matrix------
                ProteinTrackingMatrix(ProteinToFall,8)=j; % Step of simulation when protein fell
                ProteinTrackingMatrix(ProteinToFall,9)=sum(DT); % Time of simulation when protein fell
                ProteinTrackingMatrix(ProteinToFall,10)=ProteinTrackingMatrix(ProteinToFall,6); % Position Protein fell from
                ProteinTrackingMatrix(ProteinToFall,11)=NumberofMonomers; % Length of filament when protein fell
% % %                 ProteinTrackingMatrix(ProteinToFall,13)= % WORK ON THIS LATER
                ProteinTrackingMatrix(ProteinToFall,6)=0; % Current Position resets to 0
                %--------------------------------                
     
                %---Free Proteins-----
                FreeProteins(j+1)=FreeProteins(j)+1*BoundEffect;
                
                %---Outcome----------------------
                Outcome=4;
                %--------------------------------   
                
%---DEPOL (k5)-----                
             else
                 
                 %---Depol Events-----
                 DepolEvents=DepolEvents+1; %How many times the filament has depolymerized during this run
           
                 %---TIME AT LENGTH ARRAY-----
                 TimeAtLength(h,DepolEvents)=sum(DT)-sum(TimeAtLength(h,:)); %Time sim spent at this length
                 TimeAtLengthCum(h,DepolEvents)=sum(DT); %Time this run of simulation takes before this depol event
                  
                 %---Free Proteins-----
                 FreeProteins(j+1)=FreeProteins(j)+OccupancyArray(NumberofMonomers)*BoundEffect; % The number of free proteins increases by amount of proteins on end monomer. This hsould always be zero, but added just in case.
                 
                 %---Occupancy Array--------------   
                 OccupancyArray(NumberofMonomers)=NaN; %the last monomer falls off (is no longer a spot to occupy)
                 %--------------------------------         

                %---Protein Tracking Matrix-------
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,8)=j; % Step when filament depolymerized
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,9)=sum(DT); % Simulation time when filament depolled
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,10)=NumberofMonomers; % Length of filament BEFORE depolymerization (protein position)
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,11)=NumberofMonomers; % Length of filament BEFORE depolymerization
 % % %                 ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,12)=0; % Filament depolled independently %%% WORK ON THIS LATER
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,13)= sum(DT)-ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,13); %%%WORK ON THIS LATER % Amount of time protein on end (current time minus time arrived on end)
                ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)==NumberofMonomers,6)= 0; % Resets position of all proteins on end to 0    
                %--------------------------------  
                
                %---DECREASING LENGTH-----
                 CurrentLength=CurrentLength-1;
                 NumberofMonomers=NumberofMonomers-1;

                 %---Outcome----------------------
                 Outcome=5;
                 %--------------------------------      
                 
             end 
            end
        end
    end
    
%~~~END OF STEP DATA~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
%---OUTCOME ARRAY----------------------------------------------------------
OutcomeArray(1)=j; % Step number
OutcomeArray(2)=sum(DT); %time at step
OutcomeArray(3)= CurrentLength;
OutcomeArray(4)=size(ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)>0),1); %copy and pasted from previous BoundProteins definition, changed 4 to 6
OutcomeArray(5)=Outcome; 

%--MATRICES (Occupancy and Outcome)-----
OccupancyMatrix=[OccupancyMatrix;OccupancyArray];
OutcomeMatrix(j,:)=OutcomeArray;    

%---Bound Proteins-----
BoundProteins(j+1)=size(ProteinTrackingMatrix(ProteinTrackingMatrix(:,6)>0),1); %Tracks how many proteins are bound to the filament during this step

end

%~~~END OF RUN DATA~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%---Tracking/Storing Data in Cells-----------------------------------------
%---Number Bound-----
NumberBoundCell{h,1}=BoundProteins;
%---DT (Step Time)-----
DTCell{h,1}=DT;
%---Outcome-----
OutcomeCell{l,w,h}=OutcomeMatrix;
%---Protein Tracking-----
ProteinTrackingCell{l,w,h}=ProteinTrackingMatrix;
%---Occupancy-----
OccupancyCell{l,w,h}=OccupancyMatrix;
%---Time For Depol Event (Cumulative)-----
CumTimeCell{l,w,h}=[0 TimeAtLengthCum(h,:)];

end

%~~~END OF ALL RUNS FOR LENGTH/PROTEIN~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

avgCumTime=[0 mean(TimeAtLengthCum)]; %avg cumulative time of the sim after each depol event
avgDepolRate=[1./mean(TimeAtLength)]; %avg depol rate at each depol event
avgDepolRateMatrix(l)=avgDepolRate;
DepolRateCell{l,w}=avgDepolRate;
avgCumTimeCell{l,w}=avgCumTime;

%~~~SAVING MATLAB DATA~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        %Saves new file for each combination of protein concentration and length

if saverun==1         
matfile=[filename '.mat'];
save(matfile); %saves all the workspace values (cells, matrices, etc) from this run
end



%---FIGURE DESCRIPTION-----------------------------------------------------

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

%--------------------------------------------------------------------------

w=w+1;
end

l=l+1;
end




%% ~~~~COLOR GRADIENTS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

reds=    [0.4941    0.0235    0.1725
        0.6627    0.2471    0.3281
        0.8314    0.4706    0.4837
        1.0000    0.6941    0.6392];
oranges=[0.8706    0.3608    0.0196
        0.9046    0.5739    0.2105
        0.9386    0.7869    0.4013
        0.9725    1.0000    0.5922];
 greens=[0.3059    0.7294    0.1020
        0.4340    0.8196    0.3438
        0.5621    0.9098    0.5856
        0.6902    1.0000    0.8275];
 blues=[0.0196    0.7216    0.9686
        0.2745    0.7699    0.9686
        0.5294    0.8183    0.9686
        0.7843    0.8667    0.9686];
purples=[ 0.3059    0.0118    0.6745
        0.5294    0.2850    0.7830
        0.7529    0.5582    0.8915
        0.9765    0.8314    1.0000];

MasterColorGradient={oranges(size(lengths,2):-1:1,:) purples(size(lengths,2):-1:1,:) blues(size(lengths,2):-1:1,:) greens(size(lengths,2):-1:1,:)}; %pick colors based on how many proteins there are

DesboxColor=[0.6902    1.0000    0.8275];
TextboxColor=[0.7843    0.8667    0.9686]




%% ~~~DEPOL VERSUS LENGTH PLOT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


FigArray(1)=figure;


%---Plotting Theory-----
limx=[min(lengths*MonomerMeasurement) max(lengths*MonomerMeasurement)];
y=MonomerMeasurement*60*((kLand*proteins*kAssist)/(kAssist+kLand*proteins));
Theoryplot=plot(limx,y*[1,1]);
Theoryplot.LineWidth=8;
Theoryplot.Color=reds(3,:);
Theoryplot.DisplayName='Theory';

hold on

    
    
    x=lengths*MonomerMeasurement;
    y=avgDepolRateMatrix*60*MonomerMeasurement; 
    
    
    DEPOLplot=plot(x,y, 'o')
    DEPOLplot.DisplayName='Simulation Average';
    DEPOLplot.MarkerSize=20;
    DEPOLplot.LineWidth=4; % The size of the marker edge
    DEPOLplot.MarkerFaceColor=greens(3,:);
    DEPOLplot.MarkerEdgeColor=greens(2,:);
    
    ax=gca;
    ax.LineWidth=6; %Linewidth of axises
  
    
    hold on
    


 legend show
 
 

%---Setting Titles
xlabel('Length (\mum)');
ylabel('Depol Rate (\mum/min)');
title('End Binding');

%---Setting Figure Properties 

% set(gca, 'Units', 'normalized');
% set(gca, 'OuterPosition', [0,.27,1,.73]); %  graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)

% set(gca, 'TitleFontSizeMultiplier', .6); % Makes title size smaller so it doeant run off the page
set(gca, 'fontsize',30);
set(gca, 'fontweight', 'bold');
set(gca, 'YLim',[min(y)*(2/3),max(y)*(4/3)]); %If the graph is too zoomed in, you can't tell its a straight line
set(gca, 'XLim',[min(x),max(x)]);

set(gca, 'XDir','reverse'); %so x is shown shrinking instead of growing, must be under setting XLim

%--Saving Vector Figure Before Textboxes
set(gcf, 'Position', get(0, 'Screensize'))

if saverun==1 
FigName=[filename 'LengthTime'];
saveas(gcf,FigName, 'epsc2'); %saves current figure (gcf) as a eps (color) for Adobe Illustrator (extension specified in name)
          
FigName=[filename 'LengthTime.png'];
saveas(gcf,FigName); %saves current figure (gcf) as a jpeg (extension specified in name)
end

% hold off


