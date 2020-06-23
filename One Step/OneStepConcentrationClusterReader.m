fileID=fopen('OneStepConcentrationClusterCode.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)  %is this the right format spec?

simulationtime= A(1)
kMotorOn=A(2)
kMotorOff=A(3)
InitialFilamentSize=A(4)
Concentration=A(5:43)
SlopeofGraphsMatrix=A(44:82)
Errors=A(83:end)


 figure(1)
 
 sz=200
 n=scatter(Concentration,SlopeofGraphsMatrix,sz)
 xlabel('Concentration','fontsize',40)
 ylabel('Depolymerization Rates','fontsize',40)
 title('Depolymerization Rates Versus Concentration of Motors','fontsize',40)
 limits=[15 25]
 ylim(limits)
 set(gca, 'fontsize',40)
 
 n.Marker=('o')
 n.MarkerFaceColor=('g')
 n.MarkerEdgeColor=('g')
 n.DisplayName=('Simulated Data')
 
 hold on

 y=kMotorOff;
 r=line([0,Concentration(end)],[y,y],'LineWidth',3,'Color','m')
 r.DisplayName=('Theory=kOff')
 
 hold on
 
 err=Errors
 s=errorbar(Concentration,SlopeofGraphsMatrix,err, 'LineStyle','none')
 s.DisplayName=('Error')
 s.Color=([0.4940, 0.1840, 0.5560])
 
 hold on

 legend show
 LEGH=legend;
 LEGH.FontSize=40
 hold off