%Single Step


clear all
close all

simulationtime=8000;
InitialFilamentSize= 1000;

L=zeros(1,InitialFilamentSize)

kMotorOn=15;
kMotorOff=20;

M(1)=size(L,2); %Shows length of filament over time
T(1)=1;

 InitialFilamentSize=[10:10:500];
for j=(1:size(InitialFilamentSize,2))
    

%~~~Concentration Versus Depolymerization Rate Stuff~~~~~~~~~~~~~~~~~~~~~~~
    %--(Comment Out Everything until next line when not changing concentration)
% Concentration=[1:10:100 100:50:1000 1100:100:2000];
% 
% for j=(1:size(Concentration, 2))
% 
%     C=Concentration(j);
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

%       C=1; %Use this when making the code concentration independent (Don't comment out when changing initial lengths)
    
%---Parameters, don't comment out------------------------------------------
    
    
    %Changing Initial Lengths
          L=zeros(1,InitialFilamentSize(j));
              M=zeros(1,InitialFilamentSize(j));
    %%Constant Initial Lengths
%         L=zeros(1,InitialFilamentSize);
%         M=zeros(1,InitialFilamentSize);
     
    
    M(1)=size(L,2); %Shows length of filament over time
    T=zeros(1,simulationtime-1);
    T(1)=0;
    
    i=1;
%--------------------------------------------------------------------------




while i<(simulationtime-1) && size(L,2)>1
    
    %k1
        k1=kMotorOff;
   
    
    %ktotal
    ktotal=k1;
    
    DT(i)=exprnd(1/ktotal);
    L(end)=[];
    
    
    
    
    M(i+1)=size(L,2);
    T(i+1)=T(i)+DT(i);
    i=i+1
end

t=T>0;
TReal=T(t);
TReal=[0 TReal]; %this makes it so the first zero column (when the time is truly zero) is added back in

m=M>0;
MReal=M(m);
%~~~FOR MULTIPLE CONCENTRATION LINE GRAPHS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% figure(1)
% colors=jet(size(Concentration,2));
%  p=plot(TReal,MReal);
% p.Color=colors(j,:);
% 
%  xlabel('Time')
%  ylabel('Length')
%  title('Length of Filament Versus Time')
% 
% FitofGraphs=polyfit(TReal.',MReal.',1);
% SlopeofGraphsMatrix1(j)=abs(FitofGraphs(1));
% 
% legendname=strcat('Concentration=',num2str(Concentration(j)),' & Slope=', num2str(SlopeofGraphsMatrix1(j)));
% p.DisplayName=legendname;
% legend show
% 
% hold on


% end

%~~~FOR MULTIPLE INITAL LENGTHS LINE GRAPH~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
figure(1)
colors=jet(size(InitialFilamentSize,2));
p=plot(TReal,MReal);
p.Color=colors(j,:);

xlabel('Time')
ylabel('Length')
title('Length of Filament Versus Time When kOn<kOff')

FitofGraphs=polyfit(TReal.',MReal.',1);
SlopeofGraphsMatrix(j)=abs(FitofGraphs(1));

legendname=strcat('InitialLength',num2str(InitialFilamentSize(j)),' & Slope=', num2str(SlopeofGraphsMatrix(j)));
p.DisplayName=legendname;
legend show

hold on

end
%--------------------------------------------------------------------------

%~~~FOR INITIAL LENGTHS VERSUS DEPOLYMERIZATION RATE SCATTER PLOT~~~~~~~~~~
figure(2)
 sz=200
 n=scatter(InitialFilamentSize,SlopeofGraphsMatrix, sz, 'filled','g')
 xlabel('Initial Lengths','fontsize',40)
 ylabel('Depolymerization Rates','fontsize',40)
 title('Initial Lengths Versus Depolymerization Rate','fontsize',40)
 n.DisplayName=('Simulated Data')
 hold on
 y=kMotorOff
 r=line([0,InitialFilamentSize(end)],[y,y],'LineWidth',3,'Color','m')
 r.DisplayName=('Theory=kOff')
 legend show
 LEGH=legend
 LEGH.FontSize=40

 
 hold off
%--------------------------------------------------------------------------
 

%~~~FOR CONCENTRATION VERSUS DEPOLYMERIZATION SCATTER PLOT~~~~~~~~~~~~~~~
% 
%  hold off
%  
%  
%  figure(2)
%  sz=200
%  n=scatter(Concentration,SlopeofGraphsMatrix1,sz)
%  xlabel('Concentration','fontsize',40)
%  ylabel('Depolymerization Rates','fontsize',40)
%  title('Depolymerization Rates Versus Concentration of Motors','fontsize',40)
%  
%  n.Marker=('o')
%  n.MarkerFaceColor=('g')
%  n.MarkerEdgeColor=('g')
%  n.DisplayName=('Simulated Data')
%  
%  hold on
%  
% %  err=ones(size(Concentration))
% %  o=errorbar(Concentration, SlopeofGraphsMatrix1, err,'LineStyle','none')
% %  o.DisplayName=('Error')
% %  o.Color=('m')
%  
%  hold on
%  
% 
%  y=kMotorOff;
%  r=line([0,Concentration(end)],[y,y],'LineWidth',3,'Color','m')
%  r.DisplayName=('Theory=kOff')
%  
%  legend show
%  LEGH=legend;
%  LEGH.FontSize=40
%  hold off
 
 %-------------------------------------------------------------------------

figure(3)
plot(TReal,M,'b')
xlabel('Time','fontsize',40)
ylabel('Length','fontsize',40)
title('Length of Filament Versus Time','fontsize',40)

figure(4)

histogram(DT,'Normalization','pdf','FaceColor','b')

xlabel('Waiting Time','fontsize',40)
ylabel('Probability','fontsize',40)

title('Simulated Probability Distribution With Theoretical Probability Distribution','fontsize',40)
hold on


y=(kMotorOn*kMotorOff/(kMotorOn-kMotorOff))*(exp(-kMotorOff*DT)-exp(-kMotorOn*DT));
 scatter(DT,y, 'c')
y1=kMotorOn*exp(-kMotorOn*DT)
scatter(DT,y1, 'm')
xlabel('Waiting Time','fontsize',40)
ylabel('Probability','fontsize',40)
y2=kMotorOff*exp(-kMotorOff*DT)
scatter(DT,y2, 'g')


hold off
