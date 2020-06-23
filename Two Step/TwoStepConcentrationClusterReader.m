fileID=fopen('TwoStepConcentrationClusterCode.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)  %is this the right format spec?

simulationtime= A(1)
kMotorOn=A(2)
kMotorOff=A(3)
InitialFilamentSize=A(4)
Concentration=A(5:43)
SlopeofGraphsMatrix=A(44:end)


 figure(1)
 sz=200
 n=scatter(Concentration,SlopeofGraphsMatrix,sz, 'filled','g')
 xlabel('Concentration','fontsize',40)
 ylabel('Depolymerization Rates','fontsize',40)
 title('Depolymerization Rates Versus Concentration of Motors','fontsize',40)
 
 n.Marker=('o')
 n.MarkerFaceColor=('g')
 n.MarkerEdgeColor=('g')
 n.DisplayName=('Simulated Data')
 set(gca, 'fontsize',40)
 
 hold on
 
 y=(kMotorOn*Concentration*kMotorOff)./(kMotorOn*Concentration+kMotorOff);
 x=Concentration;
 r=plot(x,y,'m')
 r.LineWidth=3
 r.DisplayName=('Theory')
 
 legend show
 LEGH=legend;
 LEGH.FontSize=40
 hold off
 