fileID=fopen('draft.sp.filamentlength.onesided.cluster.txt','r')

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


LengthStartingPositionsMatrix=reshape(LengthStartingPositionsArray,LengthsofFilament(end),size(LengthsofFilament,1))'

figure(1)

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
    DiffusionConstant2=1/(2*coeffvalues(g));
v=LengthsofFilament
w=(v.^2)./(DiffusionConstant2*2)
TheoryLengthTime=plot(v,w,'-*g')
TheoryLengthTime.LineWidth=3
TheoryLengthTime.DisplayName=('Theory')

xlabel('Length of Filament')
ylabel('Average Time Until Protein Reaches End')
title('Average Time For A Diffusing Protein To Reach The End of A Filament')
set(gca, 'fontsize',40)