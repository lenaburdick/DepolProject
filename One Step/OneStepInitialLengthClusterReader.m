fileID=fopen('OneStepInitialLengthClusterCode.txt','r')

formatSpec='%f'

A=fscanf(fileID, formatSpec)  %is this the right format spec?

simulationtime= A(1)
kMotorOn=A(2)
kMotorOff=A(3)
InitialFilamentSize=A(4:53)
SlopeofGraphsMatrix=A(54:103)
Errors=A(104:end)

figure(1)
 sz=200
 n=scatter(InitialFilamentSize,SlopeofGraphsMatrix, sz, 'filled','g')
 xlabel('Initial Lengths','fontsize',40)
 ylabel('Depolymerization Rates','fontsize',40)
 title('Initial Lengths Versus Depolymerization Rate','fontsize',40)
 n.DisplayName=('Simulated Data')
 limits=[0 35]
 ylim(limits)
 set(gca, 'fontsize',40)
 
 hold on
 
 y=kMotorOff
 r=line([0,InitialFilamentSize(end)],[y,y],'LineWidth',3,'Color','m')
 r.DisplayName=('Theory=kOff')
 
 hold on
 
 err=Errors
 s=errorbar(InitialFilamentSize,SlopeofGraphsMatrix,err, 'LineStyle','none')
 s.DisplayName=('Error')
 s.Color=([0.4940, 0.1840, 0.5560])
 
 hold on
 
 legend show
 LEGH=legend
 LEGH.FontSize=40
 
 hold off