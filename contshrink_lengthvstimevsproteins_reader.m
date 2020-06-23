clear all
close all

%---Graphs data for the cont shrink model


%% PARAMETERS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NumberofRuns=1000;

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100; %Set very high to approximate true koff =0
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kOn*NumberofBoundMotors

parameters=join({'PARAMETERS' num2str([]); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});

%% ~~~Color Gradients~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
    
 MasterColorGradient= {reds, oranges,greens, blues, purples};
 
 %% ---MasterColorGradient Description-------------------------------------
    % {1,1}:{5,1} = Proteins=20:Proteins=1
       % Rows: Starting Lengths

%% IMPORTING DATA~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Currently imports data for starting lengths: 20,15,10,5 with each protein
% number: 20,15,10,5,1

%Could potentially be automated better, for now add by hand


    %---20 Starting Length------------------------------------------------------

    %---20=Proteins
    fileID=fopen('ContShrinkCLP20L20.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL20(1,:)=1./A(5:4+A(3))';
    LVTL20(1,:)=A(5+A(3):end)';

    %---15=Proteins
    fileID=fopen('ContShrinkCLP15L20.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL20(2,:)=1./A(5:4+A(3))';
    LVTL20(2,:)=A(5+A(3):end)';


    %---10=Proteins
    fileID=fopen('ContShrinkCLP10L20.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL20(3,:)=1./A(5:4+A(3))';
    LVTL20(3,:)=A(5+A(3):end)';

    %---5=Proteins
    fileID=fopen('ContShrinkCLP5L20.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL20(4,:)=1./A(5:4+A(3))';
    LVTL20(4,:)=A(5+A(3):end)';

    %---1=Proteins
    fileID=fopen('ContShrinkCLP1L20.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL20(5,:)=1./A(5:4+A(3))';
    LVTL20(5,:)=A(5+A(3):end)';
    
    
    DepolRateCell{1,:,:}=DepolRateL20;
    LVTCell{1,:,:}=LVTL20;
    

    %---15 Starting Length------------------------------------------------------

    %---20=Proteins
    fileID=fopen('ContShrinkCLP20L15.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL15(1,:)=1./A(5:4+A(3))';
    LVTL15(1,:)=A(5+A(3):end)';

    %---15=Proteins
    fileID=fopen('ContShrinkCLP15L15.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL15(2,:)=1./A(5:4+A(3))';
    LVTL15(2,:)=A(5+A(3):end)';


    %---10=Proteins
    fileID=fopen('ContShrinkCLP10L15.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL15(3,:)=1./A(5:4+A(3))';
    LVTL15(3,:)=A(5+A(3):end)';

    %---5=Proteins
    fileID=fopen('ContShrinkCLP5L15.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL15(4,:)=1./A(5:4+A(3))';
    LVTL15(4,:)=A(5+A(3):end)';

    %---1=Proteins
    fileID=fopen('ContShrinkCLP1L15.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL15(5,:)=1./A(5:4+A(3))';
    LVTL15(5,:)=A(5+A(3):end)';
    
    DepolRateCell{2,:,:}=DepolRateL15;
    LVTCell{2,:,:}=LVTL15;


    %---10 Starting Length------------------------------------------------------

    %---20=Proteins
    fileID=fopen('ContShrinkCLP20L10.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL10(1,:)=1./A(5:4+A(3))';
    LVTL10(1,:)=A(5+A(3):end)';

    %---15=Proteins
    fileID=fopen('ContShrinkCLP15L10.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL10(2,:)=1./A(5:4+A(3))';
    LVTL10(2,:)=A(5+A(3):end)';


    %---10=Proteins
    fileID=fopen('ContShrinkCLP10L10.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL10(3,:)=1./A(5:4+A(3))';
    LVTL10(3,:)=A(5+A(3):end)';

    %---5=Proteins
    fileID=fopen('ContShrinkCLP5L10.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL10(4,:)=1./A(5:4+A(3))';
    LVTL10(4,:)=A(5+A(3):end)';

    %---1=Proteins
    fileID=fopen('ContShrinkCLP1L10.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL10(5,:)=1./A(5:4+A(3))';
    LVTL10(5,:)=A(5+A(3):end)';
    
    DepolRateCell{3,:,:}=DepolRateL10;
    LVTCell{3,:,:}=LVTL10;


    %---5 Starting Length------------------------------------------------------

    %---20=Proteins
    fileID=fopen('ContShrinkCLP20L5.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL5(1,:)=1./A(5:4+A(3))';
    LVTL5(1,:)=A(5+A(3):end)';

    %---15=Proteins
    fileID=fopen('ContShrinkCLP15L5.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL5(2,:)=1./A(5:4+A(3))';
    LVTL5(2,:)=A(5+A(3):end)';


    %---10=Proteins
    fileID=fopen('ContShrinkCLP10L5.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL5(3,:)=1./A(5:4+A(3))';
    LVTL5(3,:)=A(5+A(3):end)';

    %---5=Proteins
    fileID=fopen('ContShrinkCLP5L5.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);

    DepolRateL5(4,:)=1./A(5:4+A(3))';
    LVTL5(4,:)=A(5+A(3):end)';

    %---1=Proteins
    fileID=fopen('ContShrinkCLP1L5.txt','r');
    formatSpec='%f';
    A=fscanf(fileID, formatSpec);
    
    DepolRateL5(5,:)=1./A(5:4+A(3))';
    LVTL5(5,:)=A(5+A(3):end)';
    
    
    DepolRateCell{4,:,:}=DepolRateL5;
    LVTCell{4,:,:}=LVTL5;
        
%% ---Data Cells Description------------------------------------------------

    % DepolRateCell and LVTCell:
            % {1,1}=Starting Length 20
            % {2,1}=Starting Length 15
            % {3,1}=Starting Length 10
            % {4,1}=Starting Length 5
            
                % Rows: Proteins
                % Columns: Length
                
                
%% ~~~Finding Depol Instantaneous Slopes~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%Finds the instantaneous slope of the DepolRate at each L

Proteins=[20 15 10 5 1];
StartingLengths=[20 15 10 5];

for h=1:size(StartingLengths,2)
    
    DepolSlopeMatrix=[0];
    
    for i=1:size(Proteins,2)
        
        ProteinNumber=Proteins(i);
        StartingLength=StartingLengths(h);
        
        shrink=StartingLength-(0:(StartingLength-3));
        
        DepolMatrix=DepolRateCell{h,1};
        y=DepolMatrix(i,:);
        
       
        
        for j=2:(size(shrink,2))
            
            DepolSlopeMatrix(i,j-1)=(y(j)-y(j-1))/(shrink(j)-shrink(j-1))
            
        end

    end
    
    DepolSlopeCell{h,1}=DepolSlopeMatrix;
end

%% PLOTTING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%% ---Length V Time--------------------------------------------------------


figure(1)

ProteinNumbers=[20 15 10 5 1];
StartingLengths=[20 15 10 5];

for h=1:size(StartingLengths,2)
    
    LVT=LVTCell{h,1};
    StartingLength=StartingLengths(h)

for i=1:size(ProteinNumbers,2)
    
    x=LVT(i,:);
    y=StartingLength-(0:StartingLength-2);
    
    color=MasterColorGradient{i};
    color=color(h,:);
    
    p=plot(x,y)
    p.DisplayName=['Starting Length = 20 | Proteins = ' num2str(ProteinNumbers(i))];
    p.LineWidth=4;
%     p.Color=proteincolors(i,:); % for changing protein concentration
    p.Color=color; %for changing starting lengths
    
    hold on
    
end

end

 legend show

%---Setting Titles
xlabel('Total Time Elapsed (in units time)');
ylabel('Length of Filament (in Monomers)');
title('Total Time For Filament To Depolymerize From L to L-x');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'YLim',[2,20]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)


% %---Parameter Textbox
ParTextbox=annotation('textbox', [0.5, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=20;
ParTextbox.FontName='FixedWidth'; % To match data figure 2

% hold off

%% ---Depol V Length, by Starting Length-----------------------------------



figure(2)

    ProteinNumbers=[20 15 10 5 1];
    StartingLengths=[20 15 10 5];
   
for h=1:size(StartingLengths,2)
    
    DepolRate=DepolRateCell{h,1};
    StartingLength=StartingLengths(h);
    
for i=1:size(ProteinNumbers,2)
    
    x=StartingLength-(0:StartingLength-3); % one less since trying to show x-> (x-1) not (x+1)-> x
    y=DepolRate(i,:);
    
    color=MasterColorGradient{i};
    color=color(h,:);
    
    p=plot(x,y)
    p.DisplayName=[num2str(ProteinNumbers(i)) ' Proteins, Starting Length = ' num2str(StartingLength)];
    p.LineWidth=2;
    p.Color=color; % For plotting graph individually
%     set(get(get(p(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %makes this line not show up in the legend (when graphing all at once, only want each color once)
   
    
    hold on
    
    xstart=max(x);
    yfind=find(x==xstart);
    ystart=y(yfind);
    m=plot(xstart,ystart,'<')
    m.MarkerSize=10;
    m.MarkerFaceColor=p.Color;
    m.MarkerEdgeColor=p.Color;
    set(get(get(m(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %makes this dot not show up in the legend
   
    hold on
    
end
end

legend show

%---Setting Titles
xlabel('L = Length of Filament Before Depolymerization (in monomers)');
ylabel('Depolymerization Rate (in units time)');
title('Depolymerization Rate At L to L-1');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'XLim',[3,20]);

% %---Parameter Textbox
ParTextbox=annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=20;
ParTextbox.FontName='FixedWidth'; % To match data figure 2

%Labelling triangles
TriAn=annotation('textarrow',[.8 .9],[.2 .15],'String','Triangles Show Starting Length');
TriAn.FontSize=20;
TriAn.FontName='FixedWidth';


%---Zoom Views

%     % Zoom 1
%         set(gca, 'XLim',[10,20]);
%         
%         %Labelling triangles
%         TriAn=annotation('textarrow',[.6 .9],[.5 .15],'String','Triangles Show Starting Length');
%         TriAn.FontSize=20;
%         TriAn.FontName='FixedWidth';
%         
%     % Zoom 2
%         set(gca, 'XLim',[3,10]);
%         set(gca, 'YLim',[0,3]);
%         
%         %Labelling triangles
%         TriAn=annotation('textarrow',[.8 .9],[.22 .15],'String','Triangles Show Starting Length');
%         TriAn.FontSize=20;
%         TriAn.FontName='FixedWidth'
        
%% ---Depol V Length, by Protein Number------------------------------------

    ProteinNumbers=[20 15 10 5 1];
    StartingLengths=[20 15 10 5];
   
for i=1:size(ProteinNumbers,2)
    
    figure(2+i)
    
    
    for h=1:size(StartingLengths,2)
        
        
        DepolRate=DepolRateCell{h,1};
        StartingLength=StartingLengths(h);
    
        x=StartingLength-(0:StartingLength-3); % one less since trying to show x-> (x-1) not (x+1)-> x
        y=DepolRate(i,:);
        
        color=MasterColorGradient{i};
        color=color(h,:);

        p=plot(x,y)
        p.DisplayName=['Starting Length = ' num2str(StartingLength)];
        p.LineWidth=2;
        p.Color=color;
    %     set(get(get(p(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %makes this line not show up in the legend (when graphing all at once, only want each color once)


        hold on

        xstart=max(x);
        yfind=find(x==xstart);
        ystart=y(yfind);
        m=plot(xstart,ystart,'<')
        m.MarkerSize=10;
        m.MarkerFaceColor=p.Color;
        m.MarkerEdgeColor=p.Color;
        set(get(get(m(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %makes this dot not show up in the legend

        hold on

    end
    
    legend show

%---Setting Titles
xlabel('L = Length of Filament Before Depolymerization (in monomers)');
ylabel('Depolymerization Rate (in units time)');
title(['Depolymerization Rate At L to L-1 for ' num2str(ProteinNumbers(i)) ' Proteins at Four Different Starting Lengths'] );

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'XLim',[3,20]);
    % If you want to zoom in on lower x values
%     set(gca, 'XLim',[17,20]); % Zoom 3
%     set(gca, 'YLim',[0,.3]); % Zoom 3

% %---Parameter Textbox
ParTextbox=annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=20;
ParTextbox.FontName='FixedWidth'; % To match data figure 2

%Labelling triangles
TriAn=annotation('textarrow',[.8 .9],[.3 .15],'String','Triangles Show Starting Length');
TriAn.FontSize=20;
TriAn.FontName='FixedWidth';    
    
end


 
