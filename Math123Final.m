


mu=[300 200]'

eta=[400 100]'

F= @(t,y) [(1-y(2)/mu(2))*y(1); -(1-y(1)/mu(1))*y(2)]

ode45(F,[0 25], eta) % integrates from 0 to 25

opt=odeset('RelTol',1.e-6,'event',@pitstop)

[t,y]=ode45(F,[0 inf], eta, opt)

t(end)

% period=6.5357
% 
% [t,y]=ode45(F,[0 3*period],eta,opt) %integrates over three periods