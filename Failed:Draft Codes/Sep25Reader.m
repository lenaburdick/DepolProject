clear all
close all

% TWO SIDED

fileID=fopen('TwoSidedSep25.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)

FindLengthsofFilament2=A(1)
FindNumberofRuns2=A(2)
FindLengthStartingPositionsArray2=A(3)
FindDiffCons2=A(4)
FindAverageTimeMatrix2=A(5)

LengthsofFilament2=A(FindLengthsofFilament2:FindNumberofRuns2-1)
NumberofRuns2=A(FindNumberofRuns2:FindLengthStartingPositionsArray2-1)
LengthStartingPositionsArray2=A(FindLengthStartingPositionsArray2:FindDiffCons2-1)
DiffCons2=A(FindDiffCons2:FindAverageTimeMatrix2-1)
AverageTimeMatrix2=A(FindAverageTimeMatrix2:end)


LengthStartingPositionsMatrix2=reshape(LengthStartingPositionsArray2,LengthsofFilament2(end)+1,size(LengthsofFilament2,1))' %%%

figure(1)

x2=LengthsofFilament2
y2=AverageTimeMatrix2
AvgLengthTime2=plot(x2,y2, 'd-m')
AvgLengthTime2.DisplayName=('Simulation Data')
AvgLengthTime2.LineWidth=5

hold on
%~~~Theory~~~~~~~

Equation2='b*(x^2)';

g=fit(x2 , y2 , Equation2);
FitofLengthTimeSim2=plot(g, 'c:'); 
FitofLengthTimeSim2.LineWidth=3;
FitofLengthTimeSim2.DisplayName=('Polynomial Fitted to Simulation');

%~~~Finding Diffusion Constant~~~~~~~    
    DiffusionConstant2=1/(2*coeffvalues(g));
v=LengthsofFilament2+1. %%%
w=(v.^2)./(DiffusionConstant2*2)
TheoryLengthTime=plot(v,w,'-*g')
TheoryLengthTime.LineWidth=3
TheoryLengthTime.DisplayName=('Theory')

xlabel('Length of Filament')
ylabel('Average Time Until Protein Reaches End')
title('Average Time For A Diffusing Protein To Reach Either End of A Filament')
set(gca, 'fontsize',20)

%---------------------------------------------------------------

% ONE SIDED

fileID=fopen('OneSidedSep25.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)

FindLengthsofFilament=A(1)
FindNumberofRuns=A(2)
FindLengthStartingPositionsArray=A(3)
FindDiffCons=A(4)
FindAverageTimeMatrix=A(5)

LengthsofFilament=A(FindLengthsofFilament:FindNumberofRuns-1)
NumberofRuns=A(FindNumberofRuns:FindLengthStartingPositionsArray-1)
LengthStartingPositionsArray=A(FindLengthStartingPositionsArray:FindDiffCons-1)
DiffCons=A(FindDiffCons:FindAverageTimeMatrix-1)
AverageTimeMatrix=A(FindAverageTimeMatrix:end)


LengthStartingPositionsMatrix=reshape(LengthStartingPositionsArray,LengthsofFilament(end)+1,size(LengthsofFilament,1))'%%%

figure(2)

x=LengthsofFilament
y=AverageTimeMatrix
AvgLengthTime=plot(x,y, 'd-m')
AvgLengthTime.DisplayName=('Simulation Data')
AvgLengthTime.LineWidth=5

hold on


%~~~Theory~~~~~~~

Equation='b*(x^2)';

g=fit(x , y , Equation);
FitofLengthTimeSim=plot(g, 'c:'); 
FitofLengthTimeSim.LineWidth=3;
FitofLengthTimeSim.DisplayName=('Polynomial Fitted to Simulation');

%~~~Finding Diffusion Constant~~~~~~~    
    DiffusionConstant=1/(2*coeffvalues(g));
v=LengthsofFilament
w=(v.^2)./(DiffusionConstant*2)
TheoryLengthTime=plot(v,w,'-*g')
TheoryLengthTime.LineWidth=3
TheoryLengthTime.DisplayName=('Theory')

hold on

xlabel('Length of Filament')
ylabel('Average Time Until Protein Reaches End')
title('Average Time For A Diffusing Protein To Reach One End of A Filament')
set(gca, 'fontsize',20)


%------------------------------------------------------

%Plots both on same graph

figure(3)

twosidedplot=plot(x2,y2,'m')

twosidedplot.LineWidth=3
twosidedplot.DisplayName=('Two Sided')

hold on

onesidedplot=plot(x,y,'g')
onesidedplot.LineWidth=3
onesidedplot.DisplayName=('One Sided')

hold on

legend show

xlabel('Starting Position (Monomer)')
ylabel('Time Until Protein Reaches End (unit time=number of steps)')
title('Average Time Until Protein Diffuses To End In One And Two Sided System')
set(gca, 'fontsize',20)



