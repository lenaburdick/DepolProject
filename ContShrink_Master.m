clear all
close all
   

%---Parameters-------------------------------------------------------------
NumberofRuns=1;

StartingLength=15; %Number of monomers in filament initially
ShrinkAmount=StartingLength-2; %How many monomers will fall off during simulation

TotalProteins=10; %Number of Proteins in system (stand-in for concentration)

filename=['contshrink_kfall_DC_P' num2str(TotalProteins) 'L' num2str(StartingLength) '.txt'] %Keeps you from having to scroll to bottom to change

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100; 
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kWalk*NumberofBoundMotors
kFall=1; % Chance of a single protein falling off (not at end)

BoundEffect=0; %0 if free proteins constant, 1 if free proteins change

%---Tracking Matrices------------------------------------------------------
NumberBoundCell=cell(NumberofRuns, 1);
OutcomeCell=cell(NumberofRuns, 1);
DTCell=cell(NumberofRuns, 1);
ProteinTrackingCell=cell(NumberofRuns, 1);
% 
% 
TimeAtLength=zeros(NumberofRuns, ShrinkAmount); %Time Spent at each length
TimeAtLengthCum=zeros(NumberofRuns, ShrinkAmount); %Time spent at each length, cumulative


for h=1:NumberofRuns
 
     
%---INITIALIZING Values (Reset after each depolymerizing event)

%---Length
CurrentLength=StartingLength;  
NumberofMonomers=CurrentLength+1;

%---Motor Tracking Matrix
ProteinTrackingMatrix=zeros(1,8);
ProteinTrackingMatrix(1,1)=(1);
    %first column is the motor number
    %second is the time it landed
    %third is position it landed in
    %fourth is current position
    %fifth is the position it fell off from
    %sixth is time when fell off
    %seventh is position # it depolled from (length of filament at that time)
    %eighth is time when it reached end
    %ninth is time when it depoled
    

        %The proteins are numbered as they land
        
        
OccupancyMatrix=zeros(1,NumberofMonomers);


ProteinsLanded=0;
DepolEvents=0;

DT=0;

j=0; % Way of tracking number of runs through while loop

BoundProteins(1)=0; %Shows how many proteins bound at each step
OutcomeArray(1)=0; %Shows outcome (on, off, or walk) of each step of simulation


% OccupancyArray=zeros(1,NumberofMonomers);

FreeProteins(1)=TotalProteins;


while DepolEvents<ShrinkAmount
    
j=j+1;
    
OccupancyArray=OccupancyMatrix(end,:);
    
    
%---Setting Rates----------------------------------------------------------

    if sum(ProteinTrackingMatrix(:,4)==NumberofMonomers)==0 %If there are no motors on end
        k1=kOn*FreeProteins(j)*CurrentLength; %kOn times number of free motors times length of filament
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
    
    if sum(ProteinTrackingMatrix(:,4))>0 && sum(ProteinTrackingMatrix(:,4)==NumberofMonomers)==0 % If there is a protein anywhere on the filament and there are no proteins on end
        k4=kFall*sum(ProteinTrackingMatrix(:,4)>0); %kFall * The number of bound motors
    else
        k4=0;
    end
    
    kTotal=k1+k2+k3+k4;
    
%---Outcomes (Land, Walk, Off)---------------------------------------------
    
    p=rand;
    DT(j)=exprnd(1/kTotal);
   
    if p<k1/kTotal
        LandPosition=ceil(p/(k1/kTotal)*NumberofMonomers); %Which position "bin" the number falls into
        
        ProteinsLanded=ProteinsLanded+1;
        FreeProteins(j+1)=max(FreeProteins(j)-1*BoundEffect,0);
        
        ProteinTrackingMatrix(ProteinsLanded,1)=ProteinsLanded;
        ProteinTrackingMatrix(ProteinsLanded,2)=sum(DT); %Time Landed
        ProteinTrackingMatrix(ProteinsLanded,3)=LandPosition; %Position Landed
        ProteinTrackingMatrix(ProteinsLanded,4)=LandPosition; %Current Position
        ProteinTrackingMatrix(ProteinsLanded,5)=0; %Position it fell off from
        ProteinTrackingMatrix(ProteinsLanded,6)=0; %Time when Fell Off
        ProteinTrackingMatrix(ProteinsLanded,7)=0;%Position it depolled from (length at that time)
        ProteinTrackingMatrix(ProteinsLanded,8)=0; %Time when reached end
        ProteinTrackingMatrix(ProteinsLanded,9)=0; %Time after depol
        
        OccupancyArray(LandPosition)=OccupancyArray(LandPosition)+1;
        
        Outcome=1;
    else
        if p>k1/kTotal && p<(k1+k2)/kTotal
            DepolEvents=DepolEvents+1;
          
            
            TimeAtLength(h,DepolEvents)=sum(DT)-sum(TimeAtLength(h,:)); %Time sim spent at this length
            TimeAtLengthCum(h,DepolEvents)=sum(DT); %Time this run of simulation takes before this depol event
       
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,7)=NumberofMonomers; %The length of the filament at the time this protein reached the end
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,8)=sum(DT)-DT(j); % The total time of the simulation minus the current DT
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,9)=sum(DT); %The total time of sim after depol
            ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)==NumberofMonomers,4)=0; %Resets position of protein to 0 --> Proteins don't rejoin pool & just stay 0 since others are available
            
            
            CurrentLength=CurrentLength-1;
            NumberofMonomers=NumberofMonomers-1;
            
            FreeProteins(j+1)=FreeProteins(j)+1*BoundEffect;
            
            OccupancyArray(NumberofMonomers+1:end)=NaN;
            
            Outcome=2;
            
        else
            if p>(k1+k2)/kTotal && p<(k1+k2+k3)/kTotal
                
                BoundProteinArray=find(ProteinTrackingMatrix(:,4)~=0);
                q=p-(k1+k2)/kTotal; %This is how far p is away from the edge of the "walk bin"
                WalkInteger=ceil(q/((k3/kTotal)/(size(BoundProteinArray,1)*2)));
                ProteinToWalk=BoundProteinArray(ceil(WalkInteger/2)); %Does this make the higher indexed motors more likely to walk?

                    if mod(WalkInteger,2)~=0 && ProteinTrackingMatrix(ProteinToWalk,4)~=1 %whether or not its even or odd
                        WalkDirection=-1;
                    else
                        WalkDirection=1;
                    end
                    
                    
                OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,4))=OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,4))-1; %Removes protein from its original position

                ProteinTrackingMatrix(ProteinToWalk,4)=ProteinTrackingMatrix(ProteinToWalk,4)+WalkDirection; %Current Position either forward or back
                Outcome=3;
                
                OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,4))=OccupancyArray(ProteinTrackingMatrix(ProteinToWalk,4))+1; %Adds protein to its new position
                
                FreeProteins(j+1)=FreeProteins(j);
                
                
            else
                BoundProteinArray=find(ProteinTrackingMatrix(:,4)~=0);
                q=p-(k1+k2+k3)/kTotal; %This is how far p is away from the edge of the "fall bin"
                FallInteger=ceil(q/((k4/kTotal)/size(BoundProteinArray,1)));
                ProteinToFall=BoundProteinArray(FallInteger);
                
                OccupancyArray(ProteinTrackingMatrix(ProteinToFall,4))=OccupancyArray(ProteinTrackingMatrix(ProteinToFall,4))-1; %Removes protein from position it falls from
                
                
                ProteinTrackingMatrix(ProteinToFall,5)=ProteinTrackingMatrix(ProteinToFall,4); %Position protein was in when it fell off
                ProteinTrackingMatrix(ProteinToFall,4)=0;
                ProteinTrackingMatrix(ProteinToFall,6)=sum(DT); %Time when protein fell off (including time taken to fall)
                
                FreeProteins(j+1)=FreeProteins(j)+1*BoundEffect;
                
                Outcome=4;
                
                
            end
        end
    end
    
  
BoundProteins(j+1)=size(ProteinTrackingMatrix(ProteinTrackingMatrix(:,4)>0),1); %Tracks how many proteins are bound to the filament during this step
OutcomeArray(j+1)=Outcome; %Tracks what the outcome is this step
OccupancyMatrix=[OccupancyMatrix;OccupancyArray];

    Outcome
    ProteinTrackingMatrix
    OccupancyArray
    FreeProteins(j+1)
    BoundProteins(j+1)

  
end

%---Tracking/Storing Data in Cells-----------------------------------------
NumberBoundCell{h,1}=BoundProteins;
OutcomeCell{h,1}=OutcomeArray;
DTCell{h,1}=DT;

ProteinTrackingCell{h}=ProteinTrackingMatrix;
OccupancyCell{h}=OccupancyMatrix;


end


save(filename);




%---Organizing Data--------------------------------------------------------
% for h=1:NumberofRuns
%  
%     
%  OnIndex=(OutcomeCell{h,1}==1);
%  OffIndex=(OutcomeCell{h,1}==2);
%  WalkIndex=(OutcomeCell{h,1}==3);
%  FallIndex=(OutcomeCell{h,1}==4);
%  
%  BoundOverTimeTemp=NumberBoundCell{h,1};
%  
%  OnSteps(h,1)=size(BoundOverTimeTemp(OnIndex),2); %How many times any protein came on in this run of simulation
%  OffSteps(h,1)=size(BoundOverTimeTemp(OffIndex),2);
%  WalkSteps(h,1)=size(BoundOverTimeTemp(WalkIndex),2); %%How many times any protein walked in this run of simulation
%  FallSteps(h,1)=size(BoundOverTimeTemp(FallIndex),2);
%  
%  DTTemp=DTCell{h,1}; %DT array (time for each simulation step) for this run
%  
%  TotalOnTime(h,1)=sum(DTTemp(OnIndex)); %Total Time Spent binding in this run
%  TotalOffTime(h,1)=sum(DTTemp(OffIndex));
%  TotalWalkTime(h,1)=sum(DTTemp(WalkIndex)); %Total Time Spent walking in this run
%  TotalFallTime(h,1)=sum(DTTemp(FallIndex));
%     
%  
% end


%OnSteps,OffSteps,WalkSteps,FallSteps: Number of steps taken of each of these actions 
%TotalOnTime, TotalOffTime,TotalWalkTime,TotalOffTime: Time spent on each of these actions
%ProteinTrackingCell{h}: Protein Tracking Matrix for each run
%NumberBoundCell{h}:NumberBoundMatrix for each run
%OutcomeCell{h}: Outcome array for each run
% 
% 
% 
% parameters=join({'Starting Filament Length=' num2str(StartingLength);'Total Proteins=' num2str(TotalProteins); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kFall=' num2str(kFall); 'kOff=' num2str(kOff)});
% 
% 
% figure(1)
% 
% %---Length Versus Total Time Plot------------------------------------------
% 
% %---Plotting Every Run
% for h=1:NumberofRuns
%     
%     y=StartingLength-(0:ShrinkAmount);
%     x=[0 TimeAtLengthCum(h,:)]; %Total time of sim after each step for every run (h)
%     
%     p=plot(x,y);
%     
%     hold on
%     
% end
% 
% %---Plotting avg of all runs
% 
% %Setting xavg (avg total time taken to get to length y)
% xavg=[0 mean(TimeAtLengthCum)];
% 
% pavg=plot(xavg,y, '-dw');
% pavg.LineWidth=6;
% 
% %---Setting Titles
% xlabel('Total Time Elapsed (in units time)')
% ylabel('Length of Filament (in Monomers)')
% title('Total Time For Filament To Depolymerize From L to L-x With Fixed Number of Free Proteins')
% 
% %---Setting Figure Properties
% set(gca, 'OuterPosition', [0,.2,1,.8]); % graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)
% set(gca, 'fontsize',20);
% set(gca, 'YLim',[min(y),max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)
% 
% 
% %---Paremter Textbox
% ParTextbox=annotation('textbox', [0.65, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=14;
% ParTextbox.FontName='FixedWidth'; % To match data figure 2
% 
% %---Data Textbox
% 
% %Displaying only 2 decimal places
% for h=1:size(xavg,2)
% xavgString{1,h}=sprintf('%.2f',xavg(h))
% end
% xavgString=join(xavgString); %makes it cell that can be combined with the labels
% 
% avgVal=['Average (Total) Time Until Each Depol Event = ' xavgString]
% 
% DataTextbox=annotation('textbox', [0.05, 0, 0.15, 0.15], 'String', avgVal, 'FitBoxToText','on'); %text box horizontally offset (from left) 15% of figure's width & vertically offset (from bottom) 0%. Box fits around text. Default Height is 10% of height x 10% width
% DataTextbox.FontSize=12;
% DataTextbox.FontName='FixedWidth' % To match data figure 2
% 
% hold off

% 
% 
% figure(2)
% 
% %---Time Until Depol Versus Current Length Plot----------------------------
% 
% %Setting x (the length the filament is shrinking TO)
% x=-((1:ShrinkAmount)-StartingLength);
% 
% %---Plotting each run
% for h=1:NumberofRuns
%     
%     y=[TimeAtLength(h,:)];
%     
%     p=plot(x,y);
%     
%     hold on
% end
% 
% %---Plotting average of all runs
% 
% %Setting yavg (the average of each run)
% yavg=[mean(TimeAtLength)];
% 
% pavg=plot(x,yavg,'-dw');
% pavg.LineWidth=6;
% 
% %---Setting figure properties
% 
% set(gca, 'XDir','reverse'); %so x is shown shrinking instead of growing
% set(gca, 'OuterPosition', [0,.2,1,.8]); % graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)
% set(gca, 'fontsize',20);
% 
% set(gca, 'XLim',[min(x),max(x)]); %graph for some reason showing one blank data point at beginning (x=LengthofFilament), this fixes that (max(xavg)=LengthofFilament-1)
% 
% %---Setting Titles
% title(join({'Time To Depolymerize From L=x+1 to L=x With Fixed' num2str(NumberofProteins) '  Proteins'}));
% xlabel('Length (in Monomers) Filament Is Shrinking To');
% ylabel('Time (in units time) For Single Depolymerization Event');
% 
% %---Paremeter textbox
% 
% ParTextbox=annotation('textbox', [0.5, 0.7, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 65% of figure's width & vertically offset (from bottom) 70%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=14;
% ParTextbox.FontName='FixedWidth'; % To match data textbox
% 
% %---Data Textbox
% 
% %Creates Labels
% avgText=["Time Between Each Depol Event: "; "When Shrinking to L = "]; %Creates String Array for labels
% avgText=pad(avgText); %Makes them both the same number of characters
% 
% %Creates string array of data points
% for u=(1:ShrinkAmount)
% stry=sprintf('%.2f',yavg(u)); % displays only two decimals
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
% 
% 
% 
% hold off
% 
% % DataToTrack=[StartingLength NumberofProteins size(yavg,2) size(xavg,2) yavg xavg]
% % 
% % fileID3 = fopen(filename,'a'); 
% % fprintf(fileID3,'%12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f %12.8f\r\n',DataToTrack'); %Don't know why this was chosen
% % fclose(fileID3);