clear all
close all

%---Graphs data for the cont shrink model


%% PARAMETERS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NumberofRuns=1000;

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100; %Set very high to approximate true koff =0
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kOn*NumberofBoundMotors

parameters=join({'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});

%% ~~~Color Gradients~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    %% ---Protein Colors

    proteincolors =    [139, 0, 139
             0 191 255
             154 205 50
             255 165   0
             178 34 34]./255; %Taken from wiki/Web_Colors list (all divided by 255 bc that is MATLAB'S standard]
         
         % Gradient of each main protein color
         
         purplecolorsP=  [0.5451         0    0.5451
                        0.6588    0.2301    0.6967
                        0.7725    0.4601    0.8484
                        0.8863    0.6902    1.0000];
         bluecolorsP =  [ 0    0.7490    1.0000
                        0.2379    0.8327    0.9686
                        0.4758    0.9163    0.9373
                        0.7137    1.0000    0.9059];
         greencolorsP = [    0.6039    0.8118    0.1961
                            0.7359    0.8706    0.2889
                            0.8680    0.9294    0.3817
                            1.0000    0.9882    0.4745];
         orangecolorsP=[0.9980    0.6540         0
                        0.9973    0.7287    0.2917
                        0.9967    0.8033    0.5833
                        0.9960    0.8780    0.8750];
         redcolorsP=[0.6980    0.1333    0.1333
                        0.7412    0.2667    0.3281
                        0.7843    0.4000    0.5229
                        0.8275    0.5333    0.7176];
                    
                    
    ProteinColorGradient={purplecolorsP, bluecolorsP, greencolorsP, orangecolorsP, redcolorsP};

         
    %% ---Length Colors
    lengthcolors=[ 1.0000 0 1.0000
        0.6667    0.3333    1.0000
        0.3333    0.6667    1.0000
             0    1.0000    1.0000];       

            redcolorsL=[0.5451 0 0
                0.6588    0.1784    0.1892
                0.7725    0.3569    0.3784
                0.8863    0.5353    0.5676
                1.0000    0.7137    0.7569]; %gradients made using ColorGradient.m file

            orangecolorsL= [1.0000 0.5490 0
                0.9853    0.6373    0.1373
                0.9706    0.7255    0.2745
                0.9559    0.8137    0.4118
                0.9412    0.9020    0.5490];

            greencolorsL=[ 0.6039    0.8039    0.1961
                0.4529    0.7284    0.2725
                0.3020    0.6529    0.3490
                0.1510    0.5775    0.4255
                     0    0.5020    0.5020];

            bluecolorsL= [ 0    1.0000    1.0000
                0.0735    0.7500    0.8775
                0.1471    0.5000    0.7549
                0.2206    0.2500    0.6324
                0.2941         0    0.5098];


    LengthColorGradient={redcolorsL, orangecolorsL,greencolorsL,bluecolorsL};

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
        
%% ---Data Cell Description------------------------------------------------

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
    LengthColor=LengthColorGradient{h};

for i=1:size(ProteinNumbers,2)
    
    x=LVT(i,:);
    y=StartingLength-(0:StartingLength-2);
    
    p=plot(x,y)
    p.DisplayName=['Starting Length = 20 | Proteins = ' num2str(ProteinNumbers(i))];
    p.LineWidth=4;
%     p.Color=proteincolors(i,:); % for changing protein concentration
    p.Color=LengthColor(6-i,:); %for changing starting lengths
    
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
ParTextbox.FontSize=14;
ParTextbox.FontName='FixedWidth'; % To match data figure 2

% hold off

%% ---Depol V Length, by Starting Length-----------------------------------



figure(2)

    ProteinNumbers=[20 15 10 5 1];
    StartingLengths=[20 15 10 5];
   
for h=1:size(StartingLengths,2)
    
    DepolRate=DepolRateCell{h,1};
    StartingLength=StartingLengths(h);
    LengthColor=LengthColorGradient{h};
    
for i=1:size(ProteinNumbers,2)
    
    x=StartingLength-(0:StartingLength-3); % one less since trying to show x-> (x-1) not (x+1)-> x
    y=DepolRate(i,:);
    
    p=plot(x,y)
    p.DisplayName=[num2str(ProteinNumbers(i)) ' Proteins, Starting Length = ' num2str(StartingLength)];
    p.LineWidth=2;
    p.Color=proteincolors(i,:); % For plotting graph individually
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
    % If you want to zoom in on lower x values
%     set(gca, 'XLim',[17,20]); % Zoom 3
%     set(gca, 'YLim',[0,.3]); % Zoom 3

% %---Parameter Textbox
ParTextbox=annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=14;
ParTextbox.FontName='FixedWidth'; % To match data figure 2

%% ---Depol V Length, by Protein Number------------------------------------

    ProteinNumbers=[20 15 10 5 1];
    StartingLengths=[20 15 10 5];
   
for i=1:size(ProteinNumbers,2)
    
    figure(2+i)
    
    
    for h=1:size(StartingLengths,2)
        
        
        DepolRate=DepolRateCell{h,1};
        StartingLength=StartingLengths(h);
        ProteinColor=ProteinColorGradient{i};
    
        x=StartingLength-(0:StartingLength-3); % one less since trying to show x-> (x-1) not (x+1)-> x
        y=DepolRate(i,:);

        p=plot(x,y)
        p.DisplayName=['Starting Length = ' num2str(StartingLength)];
        p.LineWidth=2;
        p.Color=ProteinColor(h,:);
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
title(['Depolymerization Rate At L to L-1 for ' num2str(ProteinNumbers(i)) ' Protein at Four Different Starting Lengths'] );

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

    
    
end


 
