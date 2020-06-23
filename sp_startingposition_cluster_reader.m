clear all
close all

%---One Sided-----------------------------

fileID=fopen('sp.startingposition.onesided.cluster.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec);


 FindNumberofRuns1=A(1);
 FindLengthofFilament1=A(2);
 FindNumberofMonomers1=A(3);
 FindAverageTimeMatrix1=A(4);
 FindDiffCons1=A(5);
 FindDiffusionConstant1=A(6);
 FindEveryRunArray1=A(7);
 
 NumberofRuns1=A(FindNumberofRuns1);
 LengthofFilament1=A(FindLengthofFilament1);
 NumberofMonomers1=A(FindNumberofMonomers1);
 AverageTimeMatrix1=A(FindAverageTimeMatrix1:FindDiffCons1-1);
 DiffCons1=A(FindDiffCons1:FindDiffusionConstant1-1);
 DiffusionConstant1=A(FindDiffusionConstant1);
 EveryRunArray1=A(FindEveryRunArray1:(FindEveryRunArray1+NumberofMonomers1*NumberofRuns1-1));
 
 
 EveryRunMatrix1=reshape(EveryRunArray1, [NumberofRuns1, NumberofMonomers1])';
 
 
 
 figure(1)

x1=(0:LengthofFilament1);
y1=AverageTimeMatrix1;
onesidedplot1=plot(x1,y1','m')

onesidedplot1.LineWidth=3;
onesidedplot1.DisplayName=('Simulation Data');

hold on

%~~~Theory~~~~~~~~

v1=(0:LengthofFilament1);
w1=(-v1.^2)/(2*DiffusionConstant1)+(LengthofFilament1^2)/(2*DiffusionConstant1);
theory1=plot(v1,w1, 'g:');
theory1.DisplayName=('Theory With Fitted Diffusion Constant');
theory1.LineWidth=3;

hold on

f1=(0:LengthofFilament1);
g1=(-v1.^2)+(LengthofFilament1^2); %The diffusion constant is monomerlength^2/avgsteptime*2=1/2
dtheory1=plot(f1,g1, 'c:');
dtheory1.DisplayName=('Theory With Diffusion Constant= MonomerSize^2/(2*AverageStepTime)=1/2')
dtheory1.LineWidth=3;

hold on

xlabel('Starting Position (Monomer)');
ylabel('Time Until Protein Reaches End (unit time=number of steps)');
title('Time Until Protein Diffuses To One End From Each Monomer');
set(gca, 'fontsize',20);

legend show

hold off


%---Two Sided-----------------------------

fileID=fopen('sp.startingposition.twosided.cluster.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec);


 FindNumberofRuns2=A(1);
 FindLengthofFilament2=A(2);
 FindNumberofMonomers2=A(3);
 FindAverageTimeMatrix2=A(4);
 FindDiffCons2=A(5);
 FindDiffusionConstant2=A(6);
 FindEveryRunArray2=A(7);
 
 NumberofRuns2=A(FindNumberofRuns2);
 LengthofFilament2=A(FindLengthofFilament2);
 NumberofMonomers2=A(FindNumberofMonomers2);
 AverageTimeMatrix2=A(FindAverageTimeMatrix2:FindDiffCons2-1);
 DiffCons2=A(FindDiffCons2:FindDiffusionConstant2-1);
 DiffusionConstant2=A(FindDiffusionConstant2);
 EveryRunArray2=A(FindEveryRunArray2:(FindEveryRunArray2+NumberofMonomers2*NumberofRuns2-1));
 
 
 EveryRunMatrix2=reshape(EveryRunArray2, [NumberofRuns2, NumberofMonomers2])';
 
 
figure(2) 

x2=(0:LengthofFilament2);
y2=AverageTimeMatrix2;
onesidedplot2=plot(x2,y2','m')

onesidedplot2.LineWidth=3;
onesidedplot2.DisplayName=('Simulation Data');

hold on

%~~~Theory~~~~~~~~

v2=(0:LengthofFilament1);
w2=((v2.*(LengthofFilament2-v2))/(2*DiffusionConstant2));
theory2=plot(v2,w2, 'g:');
theory2.DisplayName=('Theory With Fitted Diffusion Constant');
theory2.LineWidth=3;

hold on

f2=(0:LengthofFilament1);
g2=v2.*(LengthofFilament2-v2); %The diffusion constant is monomerlength^2/avgsteptime*2=1/2
dtheory2=plot(f2,g2, 'c:');
dtheory2.DisplayName=('Theory With Diffusion Constant= MonomerSize^2/(2*AverageStepTime)=1/2')
dtheory2.LineWidth=3;

hold on

xlabel('Starting Position (Monomer)');
ylabel('Time Until Protein Reaches Either End (unit time=number of steps)');
title('Time Until Protein Diffuses To Either End From Each Monomer');
set(gca, 'fontsize',20);

legend show

hold off


%--------------------------------------------------------------------------

%Plots both on same graph

figure(3)

twosidedplot=plot(x2,y2,'m')

twosidedplot.LineWidth=3
twosidedplot.DisplayName=('Two Sided')

hold on

onesidedplot=plot(x1,y1,'g')
onesidedplot.LineWidth=3
onesidedplot.DisplayName=('One Sided')

hold on

legend show

xlabel('Starting Position (Monomer)')
ylabel('Time Until Protein Reaches End (unit time=number of steps)')
title('Average Time Until Protein Diffuses To End In One And Two Sided System')
set(gca, 'fontsize',20)
