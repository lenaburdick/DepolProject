clear all
close all

%---Graphs data for the cont shrink model


NumberofRuns=1000;

kOn=1; %Chance of a single motor falling on filament. true kOn is kOn*NumberofFreeMotors*LengthofFilament
kOff=100; %Set very high to approximate true koff =0
kWalk=1; %Chance of a single motor walking on filament. true kWalk is kOn*NumberofBoundMotors


%~~~GENERATING DATA~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


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


%---10 Starting Length------------------------------------------------------

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


%~~~Finding Slopes~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ProteinNumber=[20 15 10 5 1];
x=5-(0:2); % one less since trying to show x-> (x-1) not (x+1)-> x

for i=1:size(ProteinNumber,2)
    
    for h=2:(size(x,2)-1)
        
        y=DepolRateL5(i,:);
        
        slopematrix(i,h-1)=(y(h)-y(h-1))/(x(h)-x(h-1));
    
    
    end
end





%~~~PLOTTING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%---Length V Time---------------------------------------------------------------

proteincolors =    [139, 0, 139
             0 191 255
             154 205 50
             255 165   0
             178 34 34]./255; %Taken from wiki/Web_Colors list (all divided by 255 bc that is MATLAB'S standard]

lengthcolors=[ 1.0000 0 1.0000
    0.6667    0.3333    1.0000
    0.3333    0.6667    1.0000
         0    1.0000    1.0000];       
         
redcolors=[0.5451 0 0
    0.6588    0.1784    0.1892
    0.7725    0.3569    0.3784
    0.8863    0.5353    0.5676
    1.0000    0.7137    0.7569]; %gradients made using ColorGradient.m file

orangecolors= [1.0000 0.5490 0
    0.9853    0.6373    0.1373
    0.9706    0.7255    0.2745
    0.9559    0.8137    0.4118
    0.9412    0.9020    0.5490];

greencolors=[ 0.6039    0.8039    0.1961
    0.4529    0.7284    0.2725
    0.3020    0.6529    0.3490
    0.1510    0.5775    0.4255
         0    0.5020    0.5020];

bluecolors= [ 0    1.0000    1.0000
    0.0735    0.7500    0.8775
    0.1471    0.5000    0.7549
    0.2206    0.2500    0.6324
    0.2941         0    0.5098];
    
   
    

%---20=Starting Length---
figure(1)

ProteinNumber=[20 15 10 5 1];
for i=1:size(LVTL20,1)
    
    x=LVTL20(i,:);
    y=20-(0:18);
    
    p=plot(x,y)
    p.DisplayName=['Starting Length = 20 | Proteins = ' num2str(ProteinNumber(i))];
    p.LineWidth=4;
%     p.Color=proteincolors(i,:); % for changing protein concentration
    p.Color=redcolors(6-i,:); %for changing starting lengths
    
    hold on
    
end

% legend show

%---Setting Titles
xlabel('Total Time Elapsed (in units time)');
ylabel('Length of Filament (in Monomers)');
title('Total Time For Filament To Depolymerize From L to L-x');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'YLim',[min(y),max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)


% %---Paremter Textbox
% parameters=join({'Starting Filament Length= ' num2str(20); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});
% 
% ParTextbox=annotation('textbox', [0.5, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=14;
% ParTextbox.FontName='FixedWidth'; % To match data figure 2

% hold off

%---15=Starting Length---
% figure(2)
ProteinNumber=[20 15 10 5 1];

for i=1:size(LVTL15,1)
    
    x=LVTL15(i,:);
    y=15-(0:13);
    
    p=plot(x,y)
    p.DisplayName=['Starting Length = 15 | Proteins = ' num2str(ProteinNumber(i))];
    p.LineWidth=2;
    %     p.Color=proteincolors(i,:); % for changing protein concentration
    p.Color=orangecolors(6-i,:); %for changing starting lengths
    
    
    hold on
    
end

% legend show

%---Setting Titles
xlabel('Total Time Elapsed (in units time)');
ylabel('Length of Filament (in Monomers)');
title('Total Time For Filament To Depolymerize From L to L-x');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'YLim',[min(y),max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)


% %---Paremter Textbox
% parameters=join({'Starting Filament Length= ' num2str(15); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});
% 
% ParTextbox=annotation('textbox', [0.3, 0.2, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=20;
% ParTextbox.FontName='FixedWidth'; % To match data figure 2

% hold off
%---10=Starting Length---
% figure(3)

ProteinNumber=[20 15 10 5 1];
for i=1:size(LVTL10,1)
    
    x=LVTL10(i,:);
    y=10-(0:8);
    
    p=plot(x,y)
    p.DisplayName=['Starting Length = 10 | Proteins = ' num2str(ProteinNumber(i))];
    p.LineWidth=2;
    %     p.Color=proteincolors(i,:); % for changing protein concentration
    p.Color=greencolors(6-i,:); %for changing starting lengths
    
    
    hold on
    
end

% legend show

%---Setting Titles
xlabel('Total Time Elapsed (in units time)');
ylabel('Length of Filament (in Monomers)');
title('Total Time For Filament To Depolymerize From L to L-x');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'YLim',[min(y),max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)


% %---Paremter Textbox
% parameters=join({'Starting Filament Length= ' num2str(10); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});
% 
% ParTextbox=annotation('textbox', [0.5, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=14;
% ParTextbox.FontName='FixedWidth'; % To match data figure 2

% hold off

%---5=Starting Length---

% figure(4)

ProteinNumber=[20 15 10 5 1];
for i=1:size(LVTL5,1)
    
    x=LVTL5(i,:);
    y=5-(0:3);
    
    p=plot(x,y)
    p.DisplayName=['Starting Length = 5 | Proteins = ' num2str(ProteinNumber(i))];
    p.LineWidth=2;
    %     p.Color=proteincolors(i,:); % for changing protein concentration
    p.Color=bluecolors(6-i,:); %for changing starting lengths
    
    
    hold on
    
end

legend show
legend('Location','northeast')

%---Setting Titles
xlabel('Total Time Elapsed (in units time)');
ylabel('Length of Filament (in Monomers)');
title('Total Time For Filament To Depolymerize From L to L-x');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'YLim',[min(y),max(y)]); %graph for some reason showing one blank data point at bottom, this fixes that (max(xavg)=LengthofFilament-1)
set(gca, 'OuterPosition', [0,0,1,1]); % graph starts 0 away from left edge, 20% away from bottom edge, takes up 100% space from left-to-right, & 85% space up-to-down (100%-15%)


%---Parameter Textbox
parameters=join({'Starting Filament Length= ' num2str(5); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});

ParTextbox=annotation('textbox', [0.6, 0.19, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=20;
ParTextbox.FontName='FixedWidth'; % To match data figure 2

% hold off

set(gca, 'YLim',[2,20]); %otherwise, ylim goes off of 5 from last plot
% % If you want to zoom in on lower x values
%     set(gca, 'XLim',[0,200]); % Zoom 1 (can see starting length =10 and =15 clearly)
    set(gca, 'XLim',[0,50]); % Zoom 2 (can see starting length =5 and =10 clearly)


%---Depol V Length---------------------------------------------------------------

%---20 Start Length

figure(2)


    ProteinNumber=[20 15 10 5 1];
for i=1:size(DepolRateL20,1)
    
    x=20-(0:17); % one less since trying to show x-> (x-1) not (x+1)-> x
    y=DepolRateL20(i,:);
    
    p=plot(x,y)
    p.DisplayName=[num2str(ProteinNumber(i)) ' Proteins, Starting Length = 20'];
    p.LineWidth=2;
    p.Color=proteincolors(i,:); % For plotting graph individually
%     p.Color=redcolors(i,:); % For plotting graph with others
    set(get(get(p(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %makes this line not show up in the legend (when graphing all at once, only want each color once)
   
    
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
title('Depolymerization Rate At L to L-1');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'XLim',[min(x),max(x)]);

% % %---Paremter Textbox
% parameters=join({'Starting Filament Length= ' num2str(20); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});
% 
% ParTextbox=annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=14;
% ParTextbox.FontName='FixedWidth'; % To match data figure 2

%---15 Start Length

% figure(3)

    ProteinNumber=[20 15 10 5 1];
for i=1:size(DepolRateL15,1)
    
    x=15-(0:12); % one less since trying to show x-> (x-1) not (x+1)-> x
    y=DepolRateL15(i,:);
    
    p=plot(x,y)
    p.DisplayName=[num2str(ProteinNumber(i)) ' Proteins, Starting Length = 15'];
    p.LineWidth=2;
     p.Color=proteincolors(i,:); % For plotting graph individually
%     p.Color=orangecolors(i,:); % For plotting graph with others
    set(get(get(p(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %makes this line not show up in the legend (when graphing all at once, only want each color once)
   
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
title('Depolymerization Rate At L to L-1');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'XLim',[min(x),max(x)]);

% % %---Paremter Textbox
% parameters=join({'Starting Filament Length= ' num2str(15); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});
% 
% ParTextbox=annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=14;
% ParTextbox.FontName='FixedWidth'; % To match data figure 2


%---10 Start Length

% figure(4)

    ProteinNumber=[20 15 10 5 1];
for i=1:size(DepolRateL10,1)
    
    x=10-(0:7); % one less since trying to show x-> (x-1) not (x+1)-> x
    y=DepolRateL10(i,:);
    
    p=plot(x,y)
    p.DisplayName=[num2str(ProteinNumber(i)) ' Proteins, Starting Length = 10'];
    p.LineWidth=2;
    p.Color=proteincolors(i,:); % For plotting graph individually
%     p.Color=greencolors(i,:); % For plotting graph with others
    set(get(get(p(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); %makes this line not show up in the legend (when graphing all at once, only want each color once)
   
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
xlabel('Length of Filament Before Depolymerization (in monomers)');
ylabel('Time Until Depolymerization (in units time)');
title('Time For Single Depolymerization Event From L to L-1');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'XLim',[min(x),max(x)]);


% % %---Paremter Textbox
% parameters=join({'Starting Filament Length= ' num2str(10); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});
% 
% ParTextbox=annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=14;
% ParTextbox.FontName='FixedWidth'; % To match data figure 2

%---5 Start Length

% figure(5)

    ProteinNumber=[20 15 10 5 1];
for i=1:size(DepolRateL5,1)
    
    x=5-(0:2); % one less since trying to show x-> (x-1) not (x+1)-> x
    y=DepolRateL5(i,:);
    
    p=plot(x,y)
%     p.DisplayName=[num2str(ProteinNumber(i)) ' Proteins, Starting Length = 5']; %when only making this graph
    p.DisplayName=[num2str(ProteinNumber(i)) ' Proteins']; %when plotting all graphs at once
    p.LineWidth=2;
     p.Color=proteincolors(i,:); % For plotting graph individually
%     p.Color=bluecolors(i,:); % For plotting graph with others
    
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
title('Depolymerization Rate At L to L-1');

%---Setting Figure Properties
set(gca, 'fontsize',20);
set(gca, 'XLim',[min(x),max(x)]);

% % %---Parameter Textbox
% parameters=join({'Starting Filament Length= ' num2str(5); 'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});
% 
% ParTextbox=annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
% ParTextbox.FontSize=14;
% ParTextbox.FontName='FixedWidth'; % To match data figure 2

set(gca, 'XLim',[3,10]);
set(gca, 'YLim',[0,3]);

% %---Parameter Textbox
parameters=join({'Runs=' num2str(NumberofRuns); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff)});

ParTextbox=annotation('textbox', [0.75, 0.6, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on'); %text box horizontally offset (from left) 70% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width
ParTextbox.FontSize=20;
ParTextbox.FontName='FixedWidth'; % To match data figure 2

%Labelling triangles
TriAn=annotation('textarrow',[.8 .9],[.3 .15],'String','Triangles Show Starting Length');
TriAn.FontSize=20;
TriAn.FontName='FixedWidth';

% % If you want to zoom in on lower x values
   set(gca, 'XLim',[17,20]); % Zoom 3
   set(gca, 'YLim',[0,.3]); % Zoom 3 
