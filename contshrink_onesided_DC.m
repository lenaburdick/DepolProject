clear all
close all

%This code tracks a continuously shrinking filament

%This code only works for one length at a time

% Proteins become free after they reach end and fall off
    %(Because of this, data about how long an individual protein has been
    %on filament is unreliable-- position resets to 0, and original
    %position landed/ original time landed gets re-written if protein lands
    %again)


%---Parameters-------------------------------------------------------------
NumberofRuns=1000;

StartingLength=50; %Number of monomers in filament initially
ShrinkAmount=StartingLength-2; %How many monomers will fall off during simulation
NumberofProteins=50; %Number of Proteins in system (stand-in for concentration)
filename=['ContShrinkP' num2str(NumberofProteins) 'L' num2str(StartingLength) '.txt'] %Keeps you from having to scroll to bottom to change

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100; %Set very high to approximate true koff =0
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kOn*NumberofBoundMotors

%---Tracking Matrices------------------------------------------------------
BoundOverTimeCell=cell(NumberofRuns, 1);
OnOffWalkCell=cell(NumberofRuns, 1);
DTCell=cell(NumberofRuns, 1);


TimeToDepolMatrix=zeros(NumberofRuns, ShrinkAmount);
TotalTimeToDepolMatrix=zeros(NumberofRuns, ShrinkAmount);


for h=1:NumberofRuns
 
     
%---INITIALIZING Values (Reset after each depolymerizing event)

%---Length
CurrentLength=StartingLength;  
NumberofMonomers=CurrentLength+1;

%---Motor Tracking Matrix
ProteinTrackingMatrix=zeros(NumberofProteins,4);
ProteinTrackingMatrix(:,1)=(1:NumberofProteins); %first row is the motor number, second is the time it landed, the third is its current position
%first column is the motor number, second is the time it landed, the third is position it landed in, fourth is current position

ProteinFellOff=0;
DT=0;
j=0; % Way of tracking number of runs through while loop

BoundOverTime=0; %Shows how many proteins bound at each step
OnOffWalk=0; %Shows outcome (on, off, or walk) of each step of simulation
WalkSteps=0; %DTs ONLY for walk steps


while ProteinFellOff<ShrinkAmount
    

%---Setting Rates----------------------------------------------------------

    if sum(ProteinTrackingMatrix(:,4)==0)>0 && sum(ProteinTrackingMatrix(:,4)==NumberofMonomers)==0 %If there are any free motors and no motors on end
        k1=kOn*sum(ProteinTrackingMatrix(:,4)==0)*CurrentLength; %kOn times number of free motors times length of filament
    else
        k1=0;
    end
    
    if sum(ProteinTrackingMatrix(:,4)==NumberofMonomers)>0
        k2=kOff;
    else
        k2=0;
    end
    
    if sum(ProteinTrackingMatrix(:,4))>0 && sum(ProteinTrackingMatrix(:,4)==NumberofMonomers)==0 % If there is a protein anywhere on the filament and there are no proteins on end
        k3=kWalk*sum(ProteinTrackingMatrix(:,4)>0); %kWalk * The number of bound motors
    else
        k3=0;
    end
    
    kTotal=k1+k2+k3;
    
%---Outcomes (Land, Walk, Off)---------------------------------------------
    
    p=rand;
    j=j+1;
    DT(j)=exprnd(1/kTotal);
   
    if p<k1/kTotal
        FreeProteinArray=find(ProteinTrackingMatrix(:,4)==0); %gives an array of the indexes of every free motor
        LandPosition=ceil(p*NumberofMonomers); %Which position "bin" the number falls into
        ProteinToLand=FreeProteinArray(ceil((LandPosition-p*NumberofMonomers)*size(FreeProteinArray,1))); %Splits the "position bin" into bins for free motors & finds where p falls
        
        ProteinTrackingMatrix(ProteinToLand,2)=sum(DT); %Time Landed
        ProteinTrackingMatrix(ProteinToLand,3)=LandPosition; %Position Landed
        ProteinTrackingMatrix(ProteinToLand,4)=LandPosition; %Current Position
        Outcome=1;
    else
        if p>k1/kTotal && p<(k1+k2)/kTotal
            ProteinFellOff=ProteinFellOff+1;
          
            
            TimeToDepolMatrix(h,ProteinFellOff)=sum(DT)-sum(TimeToDepolMatrix(h,:));
            TotalTimeToDepolMatrix(h,ProteinFellOff)=sum(DT); %Time this run of simulation takes before this depol event
       
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,4)=0; %Resets position of protein to 0--> PROTEINS FREE AFTER DEPOL
            CurrentLength=CurrentLength-1;
            NumberofMonomers=NumberofMonomers-1;
            Outcome=2;
            
        else
            BoundProteinArray=find(ProteinTrackingMatrix(:,4)~=0);
            q=p-(k1+k2)/kTotal; %This is how far p is away from the edge of the "walk bin"
            WalkInteger=ceil(q*size(BoundProteinArray,1)*2);
            ProteinToWalk=BoundProteinArray(ceil(WalkInteger/2)); %Does this make the higher indexed motors more likely to walk?
            WalkSteps=[WalkSteps DT(end)]; %adds the amount of time this walk step took

                if mod(WalkInteger,2)~=0 && ProteinTrackingMatrix(ProteinToWalk,4)~=1 %whether or not its even or odd
                    WalkDirection=-1;
                else
                    WalkDirection=1;
                end

            ProteinTrackingMatrix(ProteinToWalk,4)=ProteinTrackingMatrix(ProteinToWalk,4)+WalkDirection; %Current Position either forward or back
            Outcome=3;
        end
    end 
  
BoundOverTime(j)=size(ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)>0),1); %Tracks how many proteins are bound to the filament during this step
OnOffWalk(j)=Outcome; %Tracks what the outcome is this step
    
end

%---Tracking/Storing Data in Cells-----------------------------------------
BoundOverTimeCell{h,1}=BoundOverTime;
OnOffWalkCell{h,1}=OnOffWalk;
DTCell{h,1}=DT;
StartingPositionCell{h,1}=ProteinTrackingMatrix(:,3);
StartingTimeCell{h,1}=ProteinTrackingMatrix(:,2);


end


%---Organizing Data--------------------------------------------------------
for h=1:NumberofRuns
 
    
 On=(OnOffWalkCell{h,1}==1);
 Walk=(OnOffWalkCell{h,1}==3);
 
 BoundOverTimeTemp=BoundOverTimeCell{h,1};
 
 TotalOnSteps(h,1)=size(BoundOverTimeTemp(On),2); %How many times any protein came on in this run of simulation
 TotalWalkSteps(h,1)=size(BoundOverTimeTemp(Walk),2); %%How many times any protein walked in this run of simulation
 
 DTTemp=DTCell{h,1}; %DT array (time for each simulation step) for this run
 
 TotalOnTime(h,1)=sum(DTTemp(On)); %Total Time Spent binding in this run
 TotalWalkTime(h,1)=sum(DTTemp(Walk)); %Total Time Spent walking in this run
    
 
end


parameters=join({'Starting Filament Length=' num2str(StartingLength);'Total Proteins=' num2str(NumberofProteins); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});


figure(1)

%---Length Versus Total Time Plot------------------------------------------

%---Plotting Every Run
for h=1:NumberofRuns
    
    y=StartingLength-(0:ShrinkAmount);
    x=[0 TotalTimeToDepolMatrix(h,:)]; %Total time of sim after each step for every run (h)
    
    p=plot(x,y);
    
    hold on
    
end

%---Plotting avg of all runs

%Setting xavg (avg total time taken to get to length y)
xavg=[0 mean(TotalTimeToDepolMatrix)];

pavg=plot(xavg,y, '-dw');
pavg.LineWidth=6;

%---Setting Titles
xlabel('Total Time Elapsed (in units time)')
ylabel('Length of Filament (in Monomers)')
title('Total Time For Filament To Depolymerize From L to L-x')

%---Setting Figure Properties
set(gca, 'OuterPosition', [0,.2,1,.8]); % graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)
set(gca, 'fontsize',20);
set(gca, 'YLim',[min(y),max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)


%---Paremter Textbox
ParTextbox=annotation('textbox', [0.65, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=14;
ParTextbox.FontName='FixedWidth'; % To match data figure 2

%---Data Textbox

%Displaying only 2 decimal places
for h=1:size(xavg,2)
xavgString{1,h}=sprintf('%.2f',xavg(h))
end
xavgString=join(xavgString); %makes it cell that can be combined with the labels

avgVal=['Average (Total) Time Until Each Depol Event = ' xavgString]

DataTextbox=annotation('textbox', [0.05, 0, 0.15, 0.15], 'String', avgVal, 'FitBoxToText','on'); %text box horizontally offset (from left) 15% of figure's width & vertically offset (from bottom) 0%. Box fits around text. Default Height is 10% of height x 10% width
DataTextbox.FontSize=12;
DataTextbox.FontName='FixedWidth' % To match data figure 2

hold off



figure(2)

%---Time Until Depol Versus Current Length Plot----------------------------

%Setting x (the length the filament is shrinking TO)
x=-((1:ShrinkAmount)-StartingLength);

%---Plotting each run
for h=1:NumberofRuns
    
    y=[TimeToDepolMatrix(h,:)];
    
    p=plot(x,y);
    
    hold on
end

%---Plotting average of all runs

%Setting yavg (the average of each run)
yavg=[mean(TimeToDepolMatrix)];

pavg=plot(x,yavg,'-dw');
pavg.LineWidth=6;

%---Setting figure properties

set(gca, 'XDir','reverse'); %so x is shown shrinking instead of growing
set(gca, 'OuterPosition', [0,.2,1,.8]); % graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)
set(gca, 'fontsize',20);

set(gca, 'XLim',[min(x),max(x)]); %graph for some reason showing one blank data point at beginning (x=LengthofFilament), this fixes that (max(xavg)=LengthofFilament-1)

%---Setting Titles
title(join({'Time To Depolymerize From L=x+1 to L=x With' num2str(NumberofProteins) 'Total Proteins'}));
xlabel('Length (in Monomers) Filament Is Shrinking To');
ylabel('Time (in units time) For Single Depolymerization Event');

%---Paremeter textbox

ParTextbox=annotation('textbox', [0.5, 0.7, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 65% of figure's width & vertically offset (from bottom) 70%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=14;
ParTextbox.FontName='FixedWidth'; % To match data textbox

%---Data Textbox

%Creates Labels
avgText=["Time Between Each Depol Event: "; "When Shrinking to L = "]; %Creates String Array for labels
avgText=pad(avgText); %Makes them both the same number of characters

%Creates string array of data points
for u=(1:ShrinkAmount)
stry=sprintf('%.2f',yavg(u)); % displays only two decimals
strx=num2str(x(u));
avgData{1,u}=stry;
avgData{2,u}=strx;
end


avgData=pad(avgData); %Makes all data same number of characters (so they line up)
avgData=join(avgData); % Joins all data as two rows (so it can be but in array with labels)

%Combines labels and data points
avgVal=[avgText avgData];
avgVal=join(avgVal);

%Creates textbox
DataTextbox=annotation('textbox', [0.05, 0, 0.15, 0.15], 'String', [avgVal], 'FitBoxToText','on'); %text box horizontally offset (from left) 15% of figure's width & vertically offset (from bottom) 0%. Box fits around text. Default Height is 10% of height x 10% width
DataTextbox.FontSize=12;
DataTextbox.FontName='FixedWidth' % Font makes it so all data lines up



hold off

DataToTrack=[StartingLength NumberofProteins size(yavg,2) size(xavg,2) yavg xavg]

fileID3 = fopen(filename,'a'); 
fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack'); %Don't know why this was chosen
fclose(fileID3);



