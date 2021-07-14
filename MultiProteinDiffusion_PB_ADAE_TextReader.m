
clear all

% Created July 13 2021


mainfilename='MultiProteinDiffusion_PB_ADAE'; %main file name 

%% ---PARAMETERS-----------------------------------------------------------    

%Copy & Paste this section from code that created the file you want to read


%-Lengths and Proteins To Run--------------------------------------------
% In this version of the simulation, "lengths" and "proteins" are single
% values, but in other versions, they are arrays of multiple values 

lengths=[263]; % Number of monomers (the length in um is found by multiplying this by MonomerMeasurement) %% Taken from MCAK LVT graph
proteins=[5]; % Protein concentration

%-Rates------------------------------------------------------------------
kLand=.02048; % /sec %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kAssist=1.042; % /sec
kWalk=742.12; %Chance of a single motor walking on filament. true kWalk is kWalk*NumberofBoundMotors
kFall=0; % Chance of a single protein falling off (not at end)
kUnassisted=0; %monomers/sec % Chance filament will depolymerize without a protein at the end

%-Other Parameters-------------------------------------------------------
NumberofRuns=50; % How many times the simulation runs
MinFilamentSize=245; %How small 9in terms of monomers) the filament will shrink to  %% Taken from MCAK LVT graph
PBTime=10; %How many seconds the simulation "has been running"/ binding proteins before starting
BoundEffect=0; %0 if free proteins constant, 1 if free proteins change.
    % This will generally always be 0.
DirectEndBinding=0; %if DirectEndBinding=1, proteins can only land on end, if =0, they can land anywhere on filament
ExampleRuns=6; % How many sample trajectories in the Length versus Time graph

%---Measurements-------------------------------
MonomerMeasurement=.032; %This is the length of the idealized monomer in um

%% ---SETTING VALUES-------------------------------------------------------
% Sets values that would normally be set in creator code
savefigures=1;

StartingLength=lengths;
ShrinkAmount=StartingLength-MinFilamentSize;
TotalProteins=proteins;
l=1;
p=1;


%% ---OPENING TEXT FILE----------------------------------------------------


%---Setting File Name------------------------------------------------------
filename=[mainfilename '_1s_'  num2str(DirectEndBinding) 'b_' num2str(kUnassisted) 'kD_' num2str(kFall) 'kF_'  num2str(BoundEffect) 'c_' num2str(kWalk) 'kW_' num2str(kAssist) 'kA_' num2str(kLand) 'kO_' num2str(NumberofRuns) 'r_L' num2str(StartingLength) '_P' num2str(TotalProteins)]; 
filename=strrep(filename,'.','-'); %Replaces '.' in variables with '-' so it can be read
textfile=[filename '.txt'];

fileID=fopen(textfile,'r');

formatSpec='%f';

A1=fscanf(fileID, formatSpec);

%% ---FINDING VALUES ------------------------------------------------------

ParameterSize=A1(1);
DataSize=A1(2);
SampleDataSize=A1(3);
avgCumTimeCell{l,p}=A1(3+ParameterSize+1:3+ParameterSize+DataSize)';
for z=1:ExampleRuns
    start=3+ParameterSize+DataSize+(DataSize*(z-1))+2; %deletes first zero value (added back in later... wanted to keep bottom half of code same as creator code)
    finish=3+ParameterSize+DataSize+(DataSize*(z-1))+SampleDataSize;
    TimeAtLengthCum(z,:)=A1(start : finish)'; %named same as matrix in creator code so I could keep bottom of code the same
end




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

MasterColorGradient={oranges(size(lengths,2):-1:1,:) purples(size(lengths,2):-1:1,:) blues(size(lengths,2):-1:1,:) greens(size(lengths,2):-1:1,:)}; %pick colors based on how many proteins there are

DesboxColor=[0.6902    1.0000    0.8275];
TextboxColor=[0.7843    0.8667    0.9686]


%---Setting File Name------------------------------------------------------
%Sets filename again to specify these figures come from the text reader
%code not the original
filename=[mainfilename '_TextReader_1s_'  num2str(DirectEndBinding) 'b_' num2str(kUnassisted) 'kD_' num2str(kFall) 'kF_'  num2str(BoundEffect) 'c_' num2str(kWalk) 'kW_' num2str(kAssist) 'kA_' num2str(kLand) 'kO_' num2str(NumberofRuns) 'r_L' num2str(StartingLength) '_P' num2str(TotalProteins)]; 
filename=strrep(filename,'.','-'); %Replaces '.' in variables with '-' so it can be read





%% ~~~LENGTH VERSUS TIME PLOT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


FigArray(1)=figure;

%---PLOTTING EXAMPLE RUNS--------------------------------------------------
    % This plots individual runs of the simulation. The number chosen is
    % specified by ExampleRuns. The plot of the average of all runs is
    % still the average of ALL runs, not just the number chosen by
    % ExampleRuns
    
for r=1:ExampleRuns
    
    x=[0 TimeAtLengthCum(r,:)]; % in seconds
    y=(StartingLength-(0:ShrinkAmount))*MonomerMeasurement;  %   times the length of 1 monomer
    LVTplotEx=plot(x,y);
    LVTplotEx.LineWidth=2;
    LVTplotEx.Color=[.62 .455 .765];
    
    hold on

end
    
    hold on
    
%---PLOTTING AVERAGE OF ALL RUNS-------------------------------------------

for l=1:size(lengths,2)
    
for p=1:size(proteins,2)
    
    StartingLength=lengths(l)
    
    x=avgCumTimeCell{l,p}; % in seconds
    y=(StartingLength-(0:ShrinkAmount))*MonomerMeasurement;  %times the length of 1 monomer
    
    color=MasterColorGradient{p};
    color=color(l,:);
    
    LVTplot=plot(x,y)
    LVTplot.DisplayName=['Starting Length = ' num2str(lengths(l)) ' | Proteins = ' num2str(proteins(p))];
    LVTplot.LineWidth=8;
    ax=gca;
    ax.LineWidth=6; %Linewidth of axises
%     LVTplot.Color=proteincolors(i,:); % for changing protein concentration
    LVTplot.Color=[0.737 0.031 0.298]; %for changing starting lengths
    
    hold on
    
end

end



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
set(gca, 'YLim',[MinFilamentSize*MonomerMeasurement,max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)

%---SAVING FIGURE----------------------------------------------------------
set(gcf, 'Position', get(0, 'Screensize'))
lh=legend([LVTplot, LVTplotEx], 'Simulation Average', 'Sample Simulation Runs');

%---.fig Format------------------------------------------------------------
FigName=[filename 'LengthTime'];
if savefigures==1 
saveas(gcf,FigName, 'fig'); %saves current figure (gcf) as a .fig (MATLAB format) (extension specified in name)
end

%---Vector Format----------------------------------------------------------
FigName=[filename 'LengthTime'];
if savefigures==1 
saveas(gcf,FigName, 'epsc2'); %saves current figure (gcf) as a eps (color) for Adobe Illustrator (extension specified in name)
end

%---JPEG Format------------------------------------------------------------
if savefigures==1
FigName=[filename 'LengthTime'];
saveas(gcf,FigName, 'png'); %saves current figure (gcf) as a jpeg (extension specified in name)
end


 hold off



%% ~~~DEPOL RATE VERSUS LENGTH PLOT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


FigArray(2)=figure;

   
for l=1:size(lengths,2)
    
    
for p=1:size(proteins,2)
   
    StartingLength=lengths(l);
    
%     y=avgStepTime; %This is in seconds
    y=MonomerMeasurement./diff(avgCumTimeCell{l,p})*60; %*60=um/min % THis uses the diff function on the LVT plot instead of the avgStepTimeMatrix
    x=(StartingLength-(0:ShrinkAmount-1))*MonomerMeasurement;  %times the length of 1 monomer; % one less since trying to show x-> (x-1) not (x+1)-> x
    
    %---Line of Best Fit-------------------------------------------------------
    % Done before the averages plot so that the dots are on top 
    P = polyfit(x,y,1);
    yfit = P(1)*x+P(2);

    hold on

    bf=plot(x,yfit);
    bf.LineWidth=8;
    bf.Color=reds(3,:);
    bf.DisplayName='Linear Fit'
    %--------------------------------------------------------------------------
    
    DEPOLplot=plot(x,y, 'o')
    DEPOLplot.DisplayName='Simulation Data';
    DEPOLplot.MarkerSize=20;
    DEPOLplot.LineWidth=4; % The size of the marker edge
    DEPOLplot.MarkerFaceColor=greens(3,:);
    DEPOLplot.MarkerEdgeColor=greens(2,:);
 
    
    hold on
    hold on
    
end
end


legend show

%---Setting Titles
xlabel('Length (\mum)');
ylabel('Depolymerization Rate (\mum / min)');
title('Multiple Protein Diffusion');

%---Setting Figure Properties 

set(gca, 'fontsize',30);
set(gca, 'fontweight', 'bold');
ax=gca;
ax.LineWidth=6; %Linewidth of axises

% set(gca, 'TitleFontSizeMultiplier', .6); % Makes title size smaller so it doeant run off the page
set(gca, 'XLim',[min(x),max(x)]); %for some reason there was extra space on both sides of x axis
set(gca, 'YLim', [0, max(y)*2]); % puts extra space above and below y 

set(gca, 'XDir','reverse'); %so x is shown shrinking instead of growing, must be under setting XLim

%--Saving Vector Figure Before Textboxes
set(gcf, 'Position', get(0, 'Screensize'))
FigName=[filename 'DepolRate'];
saveas(gcf,FigName, 'epsc2'); %saves current figure (gcf) as a eps (color) for Adobe Illustrator (extension specified in name)



set(gcf, 'Position', get(0, 'Screensize'))

%---.fig Format------------------------------------------------------------
FigName=[filename 'DepolLength'];
if savefigures==1 
saveas(gcf,FigName, 'fig'); %saves current figure (gcf) as a .fig (MATLAB format) (extension specified in name)
end

%---Vector Format----------------------------------------------------------
FigName=[filename 'DepolLength'];
if savefigures==1 
saveas(gcf,FigName, 'epsc2'); %saves current figure (gcf) as a eps (color) for Adobe Illustrator (extension specified in name)
end

%---JPEG Format------------------------------------------------------------
if savefigures==1
FigName=[filename 'DepolLength'];
saveas(gcf,FigName, 'png'); %saves current figure (gcf) as a jpeg (extension specified in name)
end

hold off

%% ~~~DEPOL RATE VERSUS TIME PLOT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


FigArray(3)=figure;

   
for l=1:size(lengths,2)
    
    
for p=1:size(proteins,2)
   
    StartingLength=lengths(l);
    
    y=MonomerMeasurement./diff(avgCumTimeCell{l,p})*60; %*60= um/min %depolymerization rate in mon/sec
    x=avgCumTimeCell{l,p}; % cumulative time of simulation
    x=x(1:end-1); %removes final time so vectors are same length
    
    %---Line of Best Fit-------------------------------------------------------
    % Done before the averages plot so that the dots are on top 
    P = polyfit(x,y,1);
    yfit = P(1)*x+P(2);

    hold on

    bf=plot(x,yfit);
    bf.LineWidth=8;
    bf.Color=reds(3,:);
    bf.DisplayName='Linear Fit'
    %--------------------------------------------------------------------------
    
    DEPOLplot=plot(x,y, 'o')
    DEPOLplot.DisplayName='Simulation Data';
    DEPOLplot.MarkerSize=20;
    DEPOLplot.LineWidth=4; % The size of the marker edge
    DEPOLplot.MarkerFaceColor=greens(3,:);
    DEPOLplot.MarkerEdgeColor=greens(2,:);
    
    hold on
    hold on
    
end
end


legend show

%---Setting Titles
xlabel('Time (sec)');
ylabel('Depolymerization Rate (\mum / min)');
title('Multiple Protein Diffusion');

%---Setting Figure Properties 

set(gca, 'fontsize',30);
set(gca, 'fontweight', 'bold');
ax=gca;
ax.LineWidth=6; %Linewidth of axises

% set(gca, 'TitleFontSizeMultiplier', .6); % Makes title size smaller so it doeant run off the page
set(gca, 'XLim',[min(x),max(x)]); %for some reason there was extra space on one side of x axis
set(gca, 'YLim', [0, max(y)*2]); % puts extra space above and below y 

%--Saving Vector Figure Before Textboxes
set(gcf, 'Position', get(0, 'Screensize'))
FigName=[filename 'DepolRate'];
saveas(gcf,FigName, 'epsc2'); %saves current figure (gcf) as a eps (color) for Adobe Illustrator (extension specified in name)



set(gcf, 'Position', get(0, 'Screensize'))

%---.fig Format------------------------------------------------------------
FigName=[filename 'DepolTime'];
if savefigures==1 
saveas(gcf,FigName, 'fig'); %saves current figure (gcf) as a .fig (MATLAB format) (extension specified in name)
end

%---Vector Format----------------------------------------------------------
FigName=[filename 'DepolTime'];
if savefigures==1 
saveas(gcf,FigName, 'epsc2'); %saves current figure (gcf) as a eps (color) for Adobe Illustrator (extension specified in name)
end

%---JPEG Format------------------------------------------------------------
if savefigures==1
FigName=[filename 'DepolTime'];
saveas(gcf,FigName, 'png'); %saves current figure (gcf) as a jpeg (extension specified in name)
end 

