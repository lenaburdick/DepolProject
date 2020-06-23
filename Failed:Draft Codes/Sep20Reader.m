clear all
close all

fileID=fopen('TwoSidedSep20.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)

FindLengthsofFilament2=A(1)
FindNumberofRuns2=A(2)
FindTimeMatrix2=A(3)
FindDiffCons2=A(4)
FindAverageTimeMatrix2=A(5)

LengthsofFilament2=A(FindLengthsofFilament2:FindNumberofRuns2-1)
NumberofRuns2=A(FindNumberofRuns2:FindTimeMatrix2-1)
TimeMatrix2=A(FindTimeMatrix2:FindDiffCons2-1)
DiffCons2=A(FindDiffCons2:FindAverageTimeMatrix2-1)
AverageTimeMatrix2=A(FindAverageTimeMatrix2:end)


TimeMatrix2=reshape(TimeMatrix2,LengthsofFilament2(end)+1,size(LengthsofFilament2,1))' %%%

figure(1)

x2=(0:LengthsofFilament2) %%%
y2=TimeMatrix2
twosidedplot=plot(x2,y2,'m')

twosidedplot.LineWidth=3
twosidedplot.DisplayName=('Simulation Data') %Why will this not display??

hold on

%~~~Fit to Simulation Data~~~~~~~
Equation='a*(x)+b*(x^2)'; 
f=fit(x2' , y2' , Equation);
FitofSimulation=plot(f, 'c:');
ylim([0 inf]); %Prevents it from including negative values of this fit curve
FitofSimulation.LineWidth=3;
FitofSimulation.DisplayName=('Polynomial Fitted to Simulation');

hold on

%~~~Theory~~~~~~~

v2=(0:LengthsofFilament2);
DiffusionConstant2=mean(DiffCons2);
w2=((v2.*(LengthsofFilament2-v2))/2).*(1./DiffusionConstant2);
theory2=plot(v2,w2, 'g:');
theory2.DisplayName=('Theory');
theory2.LineWidth=3;

hold on

xlabel('Starting Position (Monomer)')
ylabel('Time Until Protein Reaches End (unit time=number of steps)')
title('Average Time Until Protein Diffuses To Either End')
set(gca, 'fontsize',20)

hold off


%--------------------------------------------------------------------------
fileID=fopen('OneSidedSep20.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)

FindLengthsofFilament=A(1)
FindNumberofRuns=A(2)
FindTimeMatrix=A(3)
FindDiffCons=A(4)
FindAverageTimeMatrix=A(5)

LengthsofFilament=A(FindLengthsofFilament:FindNumberofRuns-1)
NumberofRuns=A(FindNumberofRuns:FindTimeMatrix-1)
TimeMatrix=A(FindTimeMatrix:FindDiffCons-1)
DiffCons=A(FindDiffCons:FindAverageTimeMatrix-1)
AverageTimeMatrix=A(FindAverageTimeMatrix:end)


TimeMatrix=reshape(TimeMatrix,LengthsofFilament(end),size(LengthsofFilament,1))'

figure(2)

x=(1:LengthsofFilament)
y=TimeMatrix
onesidedplot=plot(x,y,'m')

onesidedplot.LineWidth=3
onesidedplot.DisplayName=('Simulation Data')

hold on

%~~~Theory~~~~~~~~

v=(0:LengthsofFilament2);
DiffusionConstant=mean(DiffCons);
w=(-v.^2)/(2*DiffusionConstant)+(LengthsofFilament^2)/(2*DiffusionConstant);
theory=plot(v,w, 'g:');
theory.DisplayName=('Theory');
theory.LineWidth=3;


xlabel('Starting Position (Monomer)')
ylabel('Time Until Protein Reaches End (unit time=number of steps)')
title('Average Time Until Protein Diffuses To One End')
set(gca, 'fontsize',20)

hold off
%------------------------------------------------------

%Plots both on same graph

figure(3)

twosidedplot=plot(x2,y2,'m')

twosidedplot.LineWidth=3
twosidedplot.DisplayName=('Two Sided')

hold on

onesidedplot=plot(x,y,'g')
onesidedplot.LineWidth=3
onesidedplot.DisplayName=('Two Sided')

hold on

legend show

xlabel('Starting Position (Monomer)')
ylabel('Time Until Protein Reaches End (unit time=number of steps)')
title('Average Time Until Protein Diffuses To End In One And Two Sided System')
set(gca, 'fontsize',20)
