clear all
close all


%---One Sided-----------------------------

fileID=fopen('sp.filamentlength.onesided.cluster.txt','r')

formatSpec='%f'

A1=fscanf(fileID, formatSpec);


 FindNumberofRuns1=A1(1);
 FindLengthsofFilament1=A1(2);
 FindAverageTimeMatrix1=A1(3);
 FindDiffusionConstant1=A1(4);
 FindTimePerMonomerArray1=A1(5);

 NumberofRuns1=A1(FindNumberofRuns1);
 LengthsofFilament1=A1(FindLengthsofFilament1:FindAverageTimeMatrix1-1);
 AverageTimeMatrix1=A1(FindAverageTimeMatrix1:FindDiffusionConstant1-1);
 DiffusionConstant1=A1(FindDiffusionConstant1);
 TimePerMonomerArray1=A1(FindTimePerMonomerArray1:FindTimePerMonomerArray1+(size(LengthsofFilament1,1)*(LengthsofFilament1(end)+1)-1));
 
 
 TimePerMonomerMatrix1=reshape(TimePerMonomerArray1, [size(LengthsofFilament1,1) , LengthsofFilament1(end)+1])';
 
 
 figure(1)
 
 x1=LengthsofFilament1;
 y1=AverageTimeMatrix1;
 onesidedplot1=plot(x1,y1','m')

 onesidedplot1.LineWidth=3;
 onesidedplot1.DisplayName=('Simulation Data');

 hold on
 
 %~~~Theory~~~~~~~~~~~
 
v1=LengthsofFilament1;
w1=v1.^2/(3*DiffusionConstant1)
 
theory1=plot(v1,w1, 'g:');
theory1.DisplayName=('Theory With Fitted Diffusion Constant');
theory1.LineWidth=3;


hold on

f1=LengthsofFilament1;
g1=(v1.^2)/(3/2); %The diffusion constant is monomerlength^2/avgsteptime*2=1/2

dtheory1=plot(f1,g1, 'c:');
dtheory1.DisplayName=('Theory With Diffusion Constant= MonomerSize^2/(2*AverageStepTime)=1/2')
dtheory1.LineWidth=3;

hold on


xlabel('LengthofFilament');
ylabel('Average Time Until Any Protein Reaches End (unit time=number of steps)');
title('Time Until Protein Diffuses To One End of a Filament of Varying Lengths');
set(gca, 'fontsize',20);

legend show

hold off


%--------------------------------------------------------------------------


%---Two Sided-----------------------------

fileID=fopen('sp.filamentlength.twosided.cluster.txt','r')

formatSpec='%f'

A2=fscanf(fileID, formatSpec);


 FindNumberofRuns2=A2(1);
 FindLengthsofFilament2=A2(2);
 FindAverageTimeMatrix2=A2(3);
 FindDiffusionConstant2=A2(4);
 FindTimePerMonomerArray2=A2(5);

 NumberofRuns2=A2(FindNumberofRuns2);
 LengthsofFilament2=A2(FindLengthsofFilament2:FindAverageTimeMatrix2-1);
 AverageTimeMatrix2=A2(FindAverageTimeMatrix2:FindDiffusionConstant2-1);
 DiffusionConstant2=A2(FindDiffusionConstant2);
 TimePerMonomerArray2=A2(FindTimePerMonomerArray2:FindTimePerMonomerArray2+(size(LengthsofFilament2,1)*(LengthsofFilament2(end)+1)-1));
 
 
 TimePerMonomerMatrix2=reshape(TimePerMonomerArray2, [size(LengthsofFilament2,1) , LengthsofFilament2(end)+1])';
 
 
 figure(2)
 
 x2=LengthsofFilament2;
 y2=AverageTimeMatrix2;
 twosidedplot=plot(x2,y2','m')

 twosidedplot.LineWidth=3;
 twosidedplot.DisplayName=('Simulation Data');

 hold on
 
 %~~~Theory~~~~~~~~~~~
 
 v2=LengthsofFilament2;
 w2=v2.^2/(12*DiffusionConstant2)
 
theory1=plot(v2,w2, 'g:');
theory1.DisplayName=('Theory ');
theory1.LineWidth=3;

hold on

f2=LengthsofFilament2;
g2=(v2.^2)/6; %The diffusion constant is monomerlength^2/avgsteptime*2=1/2

dtheory2=plot(f2,g2, 'c:');
dtheory2.DisplayName=('Theory With Diffusion Constant= MonomerSize^2/(2*AverageStepTime)=1/2')
dtheory2.LineWidth=3;

hold on



xlabel('LengthofFilament');
ylabel('Average Time Until Any Protein Reaches End (unit time=number of steps)');
title('Time Until Protein Diffuses To Either End of a Filament of Varying Lengths');
set(gca, 'fontsize',20);

legend show

hold off


%--------------------------------------------------------------------------

%Plots both on same graph

figure(3)

twosidedplot=plot(x2,y2,'c')

twosidedplot.LineWidth=3
twosidedplot.DisplayName=('Two Sided')

hold on

onesidedplot=plot(x1,y1,'r')
onesidedplot.LineWidth=3
onesidedplot.DisplayName=('One Sided')

hold on

legend show

xlabel('Starting Position (Monomer)')
ylabel('Time Until Protein Reaches End (unit time=number of steps)')
title('Average Time Until Protein Diffuses To End In One And Two Sided System')
set(gca, 'fontsize',20)


