
clear all
close all

StartingLength=66; % Number of monomers (the length in um is found by multiplying this by MonomerMeasurement) %% Taken from MCAK L0]; % Protein concentration
Proteins=.125;
%-Rates------------------------------------------------------------------
kLand=.082; % /sec %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kAssist=.26; % /sec
kWalk=46.39; %Chance of a single motor walking on filament. true kWalk is kWalk*NumberofBoundMotors
kFall=0; % Chance of a single protein falling off (not at end)
kUnassisted=0; %monomers/sec % Chance filament will depolymerize without a protein at the end


%-Other Parameters-------------------------------------------------------
NumberofRuns=1000; % How many times the simulation runs
MinFilamentSize=2; %How small (in terms of monomers) the filament will shrink to  %% Taken from MCAK LVT graph
ExampleRuns=5;

%---Measurements-------------------------------
MonomerMeasurement=.128; %This is the length of the idealized monomer in um



for h=1:NumberofRuns
    
    
    % Initializing Values
    
    IsProteinBound=0;
    IsProteinOnEnd=0;
    CurrentLength=StartingLength;
    NumberofMonomers=StartingLength+1;
    
    TimeAtLength=[0];
    TotalTime=[0];
    DepolEvents=0;
    Length=[0];
    j=0;
    DT=[0];
    
    while CurrentLength>MinFilamentSize
    
        j=j+1;
    
    if IsProteinBound==0
        
        k1=kLand*NumberofMonomers*Proteins;
    else
        k1=0;
        
    end
    
    if IsProteinOnEnd==1
        
        k2=kAssist;
    else
        k2=0;
    end
    
    if IsProteinBound==1 && IsProteinOnEnd==0
        
        k3=kWalk;
    else
        k3=0;
    end
    
    
    kTotal= k1+k2+k3;
    
% % FOR CHECKING--------------
%     k1=k1
%     k2=k2
%     k3=k3
%     kTotal=kTotal
    
    
    
    %---Generate Random Numbers-----        
    p=rand; % Determines Outcome
    
    
    if p<k1/kTotal % LAND
        
%         Outcome=1;
        
        LandPosition=ceil(p/(k1/kTotal)*NumberofMonomers);
        
        DT(j)=exprnd(1/kTotal);
        
        
        IsProteinBound=1;
        IsProteinOnEnd=0;
        

    else
        
        if p>k1/kTotal && p<(k1+k2)/kTotal % ASSIST
                
%             Outcome=2;
            
            NumberofMonomers=NumberofMonomers-1;
            CurrentLength=CurrentLength-1;
            
            % It doesn't matter which end it depolymerizes from, since the
            % proteins land one at a time anyway
            
            DT(j)=exprnd(1/kTotal);
            DepolEvents=DepolEvents+1;
            TimeAtLength(DepolEvents)=sum(DT); %Time when filament decreased length
            
            IsProteinBound=0;
            IsProteinOnEnd=0;
        
            
        else % WALK
         
%             Outcome=3;
            
            TimeToEitherEnd=LandPosition*(NumberofMonomers-LandPosition); % THis is the expected time to reasch an end based on land position, per the Gambler's Ruin paper
            DT(j)= TimeToEitherEnd;
            
            IsProteinBound=1;
            IsProteinOnEnd=1;
          
% This section calculates probabiity of the protein reaching either end,
% then gives the time it takes to get to that end. In Gambler's Ruin paper,
% they only discuss the time it takes to get to EITHER end, so that is what
% I will use until I get further clarification


%             ProbLeft=(CurrentLength-LandPosition)/CurrentLength; %Probability protein will reach left end
%             ProbRight=LandPosition/CurrentLength; %Probability protein will reach right end
%             %%% FILL IN WHEN IPAD WORKS TimeLeft=
%             %%% FILL IN WHEN IPAD WORKS TimeRight= 
%             
%             
%             q=p-(k1+k2)/kTotal; %This is how far p is away from the edge of the "walk bin." In this simulation, it should = p
%             
%             if q<ProbLeft
%                 WhichEnd=0; % Protein goes to left end
%                 DT(j)=TimeLeft; % Average time a protein in this position takes to reach left end
%             else
%                 WhichEnd=1; % Protein goes to right end
%                 DT(j)=TimeRight; % Average time a protein in this position takes to reach right end
%             end
%             
%             %%%% Check this whole section
            
      
            
        end
    end
    
    TotalTime(j)=sum(DT);
    Length(j)=CurrentLength;
    
    
% % FOR CHECKING---------------------
%      DT(j)=DT(j)
%      TotalTime=TotalTime
%      Length=Length
%      IsProteinBound=IsProteinBound
%      IsProteinOnEnd=IsProteinOnEnd
%      1==1; 
     
    end
    
    TimeAtLengthMatrix(h,:)=TimeAtLength;
    
end

AvgTimeAtLengthMatrix=mean(TimeAtLengthMatrix);


%% PLOTS

%% ~~~~COLOR GRADIENTS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% These are some custom color gradients that I reference occassionally.


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

% MasterColorGradient={oranges(size(lengths,2):-1:1,:) purples(size(lengths,2):-1:1,:) blues(size(lengths,2):-1:1,:) greens(size(lengths,2):-1:1,:)}; %pick colors based on how many proteins there are



%% ~~~LENGTH VERSUS TIME PLOT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


FigArray(1)=figure;

%---PLOTTING EXAMPLE RUNS--------------------------------------------------
    % This plots individual runs of the simulation. The number chosen is
    % specified by ExampleRuns. The plot of the average of all runs is
    % still the average of ALL runs, not just the number chosen by
    % ExampleRuns
    
% for r=1:ExampleRuns
%     
%     x=[0 TimeAtLengthMatrix(r,:)]; % in seconds
%     y=(StartingLength-(0:(StartingLength-MinFilamentSize)))*MonomerMeasurement;  %   times the length of 1 monomer
%     LVTplotEx=plot(x,y);
%     LVTplotEx.LineWidth=2;
%     LVTplotEx.Color=[.62 .455 .765];
%     
%     hold on
% 
% end
    
    hold on
    
%---PLOTTING AVERAGE OF ALL RUNS-------------------------------------------

    
    x=[0 AvgTimeAtLengthMatrix]; % in seconds
    y=(StartingLength-(0:(StartingLength-MinFilamentSize)))*MonomerMeasurement;  %times the length of 1 monomer
    
  
    
    LVTplot=plot(x,y)
    LVTplot.DisplayName=['Starting Length = ' num2str(StartingLength) ' | Proteins = ' num2str(Proteins)];
    LVTplot.LineWidth=8;
    ax=gca;
    ax.LineWidth=6; %Linewidth of axises
%     LVTplot.Color=proteincolors(i,:); % for changing protein concentration
    LVTplot.Color=[0.737 0.031 0.298]; %for changing starting lengths
    
    hold on
    



%---Setting Titles
xlabel('Time (sec)');
ylabel('Length (\mum)');
title('Multiple Protein Diffusion');

%---Setting Figure Properties 

% set(gca, 'Units', 'normalized');
% set(gca, 'OuterPosition', [0,.27,1,.73]); %  graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)

% set(gca, 'TitleFontSizeMultiplier', .6); % Makes title size smaller so it doeant run off the page
set(gca, 'fontsize',30);
set(gca, 'fontweight', 'bold');
% set(gca, 'XLim',[min(x),max(x)]);
% set(gca, 'YLim',[min(y),max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)

% %---SAVING FIGURE----------------------------------------------------------
 set(gcf, 'Position', get(0, 'Screensize'))
% lh=legend([LVTplot, LVTplotEx], 'Simulation Average', 'Sample Simulation Runs');
% 
% %---.fig Format------------------------------------------------------------
% FigName=[filename 'LengthTime'];
% if savefigures==1 
% saveas(gcf,FigName, 'fig'); %saves current figure (gcf) as a .fig (MATLAB format) (extension specified in name)
% end
% 
% %---Vector Format----------------------------------------------------------
% FigName=[filename 'LengthTime'];
% if savefigures==1 
% saveas(gcf,FigName, 'epsc2'); %saves current figure (gcf) as a eps (color) for Adobe Illustrator (extension specified in name)
% end
% 
% %---JPEG Format------------------------------------------------------------
% if savefigures==1
% FigName=[filename 'LengthTime'];
% saveas(gcf,FigName, 'png'); %saves current figure (gcf) as a jpeg (extension specified in name)
% end


 hold off
