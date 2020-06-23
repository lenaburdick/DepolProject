% Simulation of a two-dimensional dynamical system:
%   x(n+1)=F(x(n),y(n))
%   y(n+1)=G(x(n),y(n))

close all
clear all

% set the initial conditions
x=0.2;  
y=0.3;


% Parameters
alpha=0.2;
beta=0.8;
gamma=0.2;
delta=0.8;
lambda=0.1;

% Functions
F=@(x,y) x+alpha*x-beta*x.*y;
G=@(x,y) y-gamma*y+delta*x.*y;

% Final time
n=800;       

% Computing the sequence recursively
for i=1:n
    x(i+1)=F(x(i),y(i));
    y(i+1)=G(x(i),y(i));
end

% Various Plots:

% Plot of the trajectories as a function of time
figure;
plot(x)
hold on
plot(y);

% Plot of the first vs second variable
figure()
plot(x,y)

% Plot with multiple initial conditions
n=200;

figure();
hold on;
for x=0.1:0.1:1
    for y=0.1:0.1:1
        for i=1:n
            x(i+1)=F(x(i),y(i));
            y(i+1)=G(x(i),y(i));
        end
        plot(x(ceil(end/2):end),y(ceil(end/2):end),'*-');
    end
end
% axis([-1 5 -1 5])