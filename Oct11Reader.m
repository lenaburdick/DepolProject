%---One Sided-----------------------------

fileID=fopen('OneSidedOct11.txt','r')

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
theory1.DisplayName=('Theory ');
theory1.LineWidth=3;


xlabel('Starting Position (Monomer)');
ylabel('Time Until Protein Reaches End (unit time=number of steps)');
title('Time Until Protein Diffuses To One End From Each Monomer');
set(gca, 'fontsize',20);

legend show

hold off



%---Two Sided-----------------------------

fileID=fopen('TwoSidedOct11.txt','r')

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
w2=((v2.*(LengthofFilament-v2))/(2*DiffusionConstant2));
theory2=plot(v2,w2, 'g:');
theory2.DisplayName=('Theory ');
theory2.LineWidth=3;


xlabel('Starting Position (Monomer)');
ylabel('Time Until Protein Reaches Either End (unit time=number of steps)');
title('Time Until Protein Diffuses To Either End From Each Monomer');
set(gca, 'fontsize',20);

legend show

hold off