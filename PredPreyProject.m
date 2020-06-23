% Simulation of a two-dimensional dynamical system:
%   x(n+1)=F(x(n),y(n))
%   y(n+1)=G(x(n),y(n))

close all
clear all

% % original initial conditions
% x=0.2;  
% y=0.3;

% initial conditions to play with
x=1;  
y=1;


% % Original Parameters
% alpha=0.2; % prey growth (from birth)
% beta=0.8; % prey death (from interaction)
% gamma=0.2;% predator death (from starvation)
% delta=0.8; % predator growth (from eating prey)
% lambda=0.1;

%Parameters to play with
alpha=2/3; % prey growth (from birth)
beta=4/3; % prey death (from interaction)
gamma=1;% predator death (from starvation)
delta=1; % predator growth (from eating prey)

constant1=0;
constant2=0;

% % Original Functions
% F=@(x,y) x+alpha*x-beta*x.*y - lambda*x^3; %original
% G=@(x,y) y-gamma*y+delta*x.*y - lambda*y^3; %original

% % Functions to play with
% F=@(x,y) x+alpha*x-beta*x.*y;
% G=@(x,y) y-gamma*y+delta*x.*y-x.*(constant1+y*constant2);

C=0

% Functions to play with
F=@(x,y) x+alpha*x-beta*x.*y;
G=@(x,y) y+(delta-C)*x.*y-gamma*y;

% Final time
n=1000;       

% Computing the sequence recursively
for i=1:n % Find x and y as a function of time (n)
   
    
    
    if x(i)>0
       x(i)=x(i);
    else
       x(i)=0;
    end
            
    if y(i)>0
       y(i)=y(i);
    else
       y(i)=0;
    end
     
    
%     x(i+1)=F(x(i),y(i));
%     y(i+1)=G(x(i),y(i));

x(i+1)= x(i)+alpha*x(i)-beta*x(i).*y(i);
y(i+1)= y(i)+(delta-C)*x(i).*y(i)-gamma*y(i);
    
    
end

% Various Plots:

% Plot of the trajectories as a function of time
figure (1)
plot(x,'LineWidth',2);
hold on
plot(y,'LineWidth',2);

title('Predator and Prey Population Vs. Time')
xlabel('Time (in steps n)')
ylabel('Predator & Prey Populations')
legend('Prey Population','Predator Population')

% axis([0 n 0 5])

% Plot of the first vs second variable
figure(2)
plot(x,y,'LineWidth',4)

title('Prey Vs. Predator Population')
xlabel('Prey Population')
ylabel('Predator Population')





% Plot with multiple initial conditions
n=1000; %Time
xic=[0.1:0.1:1]; % x initial conditions
yic=[0.1:0.1:1]; % y initial conditions

%  axis([0 5 0 5])


figure(3);
hold on;

% set(gca, 'ColorOrder', jet(size(xic,2)*size(yic,2)), 'NextPlot', 'replacechildren') ; % makes colors rainbow
colors=jet(size(xic,2)*size(yic,2))
c=0

for x=xic
    for y=yic
        for i=1:n
            
            if x(i)>0
                x(i)=x(i);
            else
                x(i)=0;
            end
            
            if y(i)>0
                y(i)=y(i);
            else
                y(i)=0;
            end
    
            x(i+1)=F(x(i),y(i));
            y(i+1)=G(x(i),y(i));
            
            
        end
        c=c+1;
        name=char(join({'y=' num2str(y(1)) ' & x=' num2str(x(1))}));
        p=plot(x,y,'*-','DisplayName', name); % changed from x(ceil(end/2):end),y(ceil(end/2):end) to x,y  Not sure why
        p.Color=colors(c,:);
    end
    legend show
end

title('Prey Vs. Predator Population With Different Initial Conditions')


% ic={'Prey Initial Conditions=' num2str(xic), 'Predator Initial Conditions=' num2str(yic)}
% icTextBox=annotation('textbox', [0.2, 0.8, 0.1, 0.1], 'String', ic, 'FitBoxToText','on'); %horizontally offset (from left) 20% of figure's width & vertically offset (from bottom) 80%. Box fits around text. Default Height is 10% of height x 10% width

legend show
lgd=legend
title(lgd,'Initial Conditions')
lgd.Location='northeast'
xlabel('Prey Population')
ylabel('Predator Population')
axis([0 5 0 5])
            