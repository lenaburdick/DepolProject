
%---One Sided----------------------------

fileID=fopen('mp_filamentlength_onesided_cluster.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec);

FindNumberofRuns= A(1)
FindNumberofMotors=A(2)
FindLengthofFilamentArray=A(3)
FindkOn=A(4)
FindkOff=A(5)
FindkWalk=A(6)
FindTotalTimeArray=A(7)
FindAvgDTArray=A(8)
FindStepsArray=A(9)
FindMeanWalkStepArray=A(10)
FindSPTimeToEndArray=A(11)
FindSPDisplacementArray=A(12)

NumberofRuns= A(FindNumberofRuns);
NumberofMotors=A(FindNumberofMotors);
LengthofFilamentArray=A(FindLengthofFilamentArray:FindkOn-1);
kOn=A(FindkOn);
kOff=A(FindkOff);
kWalk=A(FindkWalk);
TotalTimeArray=A(FindTotalTimeArray:FindAvgDTArray-1);
AvgDTArray=A(FindAvgDTArray:FindStepsArray-1);
StepsArray=A(FindStepsArray:FindMeanWalkStepArray-1);
MeanWalkStepArray=A(FindMeanWalkStepArray:FindSPTimeToEndArray-1)
SPTimeToEndArray=A(FindSPTimeToEndArray:FindSPDisplacementArray-1);
SPDisplacementArray=A(FindSPDisplacementArray:end);

TotalTimeMatrix=reshape(TotalTimeArray, [NumberofRuns, size(LengthofFilamentArray,1)])
AvgDTMatrix=reshape(AvgDTArray, [NumberofRuns, size(LengthofFilamentArray,1)])
StepsMatrix=reshape(StepsArray, [NumberofRuns, size(LengthofFilamentArray,1)])
MeanWalkStepMatrix=reshape(MeanWalkStepArray, [NumberofRuns, size(LengthofFilamentArray,1)])
SPTimeToEndMatrix=reshape(SPTimeToEndArray, [NumberofRuns, size(LengthofFilamentArray,1)])
SPDisplacementMatrix=reshape(SPDisplacementArray, [NumberofRuns, size(LengthofFilamentArray,1)])


% Finding The Difussion Constant---------

DiffCon=mean(1./(2*mean(AvgDTMatrix,1)))
%---------------------------------------------------------   


parameters=join({'Runs=' num2str(NumberofRuns); 'Total Proteins=' num2str(NumberofMotors); 'kOn=' num2str(kOn); 'kWalk=' num2str(kWalk); 'kOff=' num2str(kOff); 'Filament Lengths=' num2str(LengthofFilamentArray'); 'Diffusion Constant=' num2str(DiffCon)})


AverageTotalTimeArray=sum(TotalTimeMatrix,1)/NumberofRuns;


figure(1)
x=LengthofFilamentArray;
y=AverageTotalTimeArray;


lengthtimeplot=plot(x,y,'m');

lengthtimeplot.LineWidth=3
lengthtimeplot.DisplayName=('Length Of Filament Versus Time For Protein To Reach One End')

hold on 


yt=LengthofFilamentArray.^2./(3*DiffCon)+1/(kOn*NumberofMotors)+1/kOff;
theoryplot=plot(x, yt, 'g:')
theoryplot.DisplayName= 'Theory, T=L^2/(3D)+1/(kOn*NumberofMotors*L)+1/kOff'
theoryplot.LineWidth=3
hold on

xlabel('Length (in Monomers) of Filament')
ylabel('Time Until Protein Reaches One End')
title('Time Until Protein Diffuses to One End of Different Length Filaments')
set(gca, 'fontsize',20)

legend show

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14

hold off

%----------------------------------------------------------

figure(2)

u=mean(SPTimeToEndMatrix,1); %The average amount of time the protein that reached end spent on filament per length
SPtimeplot=plot(x,u, 'm')
SPtimeplot.LineWidth=3
xlabel('Length (in Monomers) of Filament')
ylabel('Time Terminal Protein Spends On Filament Before Reaching End')
title('Time Terminal Protein Is Bound Before Reaching One End of Different Length Filaments')
set(gca, 'fontsize',20)

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14

figure(3)

v=mean(SPDisplacementMatrix,1); %The average number of monomers the protein that reached end travelled
SPdisplacementplot=plot(x,v, 'm')
SPdisplacementplot.LineWidth=3
xlabel('Length (in Monomers) of Filament')
ylabel('Average Displacement of Terminal Protein  Before Reaching End')
title('Average Number of Monomers Travelled By Terminal Protein Before Reaching One End of Different Length Filaments')
set(gca, 'fontsize',20)

an=annotation('textbox', [0.25, 0.5, 0.1, 0.1], 'String', parameters, 'FitBoxToText','on') %text box horizontally offset (from left) 25% of figure's width & vertically offset (from bottom) 50%. Box fits around text. Default Height is 10% of height x 10% width
an.FontSize=14