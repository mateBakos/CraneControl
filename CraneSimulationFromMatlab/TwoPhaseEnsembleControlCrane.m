% Two-phase ensemble control for a crane system
% Nathan Vervaeke
% Universiteit Gent
% 2014

clc;
close all;
clear all;
syms epsilon
set(0,'defaultaxesfontsize',10);
set(0,'defaulttextfontsize',10);

% Initial, intermediate and final conditions
x_start = 0.2;
dxdt_start = 0;
theta_start = 0;
theta_epsilon_start = 0;
dthetadt_start = 0;

x_intermediate = 0;
dxdt_intermediate = 0;
theta_intermediate = 0.1;
theta_epsilon_intermediate = 0;
dthetadt_intermediate = 0;

x_final = 0.2;
dxdt_final = 0;
theta_final = 0;
theta_epsilon_final = 0;
dthetadt_final = 0;

% Model parameters
g = 9.81;
eps = [1/0.36 1/0.34 1/0.31 1/0.28 1/0.26]; % epsilon = 1/l, with l the cable length of the crane
                                            % Here we are creating an ensemble of
                                            % crane systems.
nominaleps = eps(round(length(eps)/2));
start = [x_start,dxdt_start,theta_start+theta_epsilon_start*(epsilon-nominaleps),dthetadt_start]; % Initial states
intermediate1 = [x_intermediate,dxdt_intermediate,theta_intermediate,dthetadt_intermediate]; % Intermediate states
intermediate2 = [x_intermediate,dxdt_intermediate,theta_intermediate+theta_epsilon_intermediate*(epsilon-nominaleps),dthetadt_intermediate]; % Intermediate states
final = [x_final,dxdt_final,theta_final,dthetadt_final]; % Final states
n = length(start); % Number of states

% Ensemble parameters
order = 3;                 % Number of steps of the ensemble control

% Simulation parameters
stepsim = 0.016;           % Simulation step size (in seconds)
ts = 20*stepsim;           % Step size (in seconds)
phases = 2;                % Number of phases
T = phases*ts*(2*order+2); % Total simulation time
t = 0:stepsim:T;           % Time vector

% Discrete-time state space model
Ad = [1,ts,0,0;0,1,0,0;0,0,0.5*(exp(-sqrt(-epsilon*g)*ts)+exp(sqrt(-epsilon*g)*ts)),...
   -0.5*(exp(-sqrt(-epsilon*g)*ts)-exp(sqrt(-epsilon*g)*ts))/sqrt(-epsilon*g);0,0,...
   0.5*epsilon*g*(exp(-sqrt(-epsilon*g)*ts)-exp(sqrt(-epsilon*g)*ts))/sqrt(-epsilon*g),...
   0.5*(exp(-sqrt(-epsilon*g)*ts)+exp(sqrt(-epsilon*g)*ts))];
Bd = [0.5*ts^2;ts;0.5*(exp(-sqrt(-epsilon*g)*ts)+exp(sqrt(-epsilon*g)*ts)-2)/g;0.5*(exp(-sqrt(-epsilon*g)*ts)-exp(sqrt(-epsilon*g)*ts))*epsilon/sqrt(-epsilon*g)];

% Calculate input
input1 = CalculateInputCrane(n,order,start,intermediate1,Ad,Bd,theta_epsilon_intermediate,nominaleps);
input2 = CalculateInputCrane(n,order,intermediate2,final,Ad,Bd,theta_epsilon_final,nominaleps);
input = [input1; input2];

% Transform input to a Simulink-capable input
in = zeros(1,length(t)-1);
for i = 1:length(input)
    for j = 1:(T/stepsim)/length(input)
        in(round((i-1)*ts/stepsim+j)) = real(input(i));
        fill = round((i-1)*ts/stepsim+j);
    end
end
for k = fill+1:length(t)
    in(k) = in(fill); % Fill input completely
end   
u = [t',in'];

% Preallocating data matrices
X = zeros(1,length(t));
DXDT = zeros(1,length(t));
THETA = zeros(length(eps),length(t));
DTHETADT = zeros(length(eps),length(t));

% Open figure
figure(1);
set(gcf,'position',[200 50 1000 640]);

% Simulation
for i=1:length(eps)
    
    theta=subs(theta_start+theta_epsilon_start*(epsilon-nominaleps),epsilon,eps(i));
    start = [x_start,dxdt_start,theta,dthetadt_start];
    
    % Continuous-time state space model
    A = [0 1 0 0;0 0 0 0;0 0 0 1;0 0 -eps(i)*g 0];
    B = [0;1;0;-eps(i)];
    C = eye([4 4]);
    D = [0;0;0;0];
    
    %Simulation
    sim('crane.mdl')
    
    %Plotting
    subplot(2,2,1)
    hold on
    plot(t,x.signals.values,'k')
    subplot(2,2,2)
    hold on
    plot(t,dxdt.signals.values,'k')
    subplot(2,2,3)
    hold on
    plot(t,theta.signals.values,'r')
    subplot(2,2,4)
    hold on
    plot(t,dthetadt.signals.values,'r')
    
    
    %Saving data
    THETA(i,:) = theta.signals.values;
    DTHETADT(i,:) = dthetadt.signals.values;
    
end

%Saving data
X(1,:) = x.signals.values;
DXDT(1,:) = dxdt.signals.values;

%Horizontal line
subplot(2,2,1)
hold on
plot(t,x_intermediate)
hold on
[AX] = plotyy(t,x_final,u(:,1),u(:,2));
set(get(AX(1),'Ylabel'),'String','Distance [m]')
set(get(AX(2),'Ylabel'),'String','Acceleration [m/s²]')
xlabel('Time [s]')
title(['x_{start} = ',num2str(x_start),'    x_{intermediate} = ',num2str(x_intermediate),'    x_{final} = ',num2str(x_final)])
subplot(2,2,2)
hold on
plot(t,dxdt_intermediate)
hold on
[AX] = plotyy(t,dxdt_final,u(:,1),u(:,2));
set(get(AX(1),'Ylabel'),'String','Speed [m/s]')
set(get(AX(2),'Ylabel'),'String','Acceleration [m/s²]')
xlabel('Time [s]')
title(['dx/dt_{start} = ',num2str(dxdt_start),'    dx/dt_{intermediate} = ',num2str(dxdt_intermediate),'    dx/dt_{final} = ',num2str(dxdt_final)])
subplot(2,2,3)
hold on
plot(t,theta_intermediate)
hold on
[AX] = plotyy(t,theta_final,u(:,1),u(:,2));
set(get(AX(1),'Ylabel'),'String','Angle [rad]')
set(get(AX(2),'Ylabel'),'String','Acceleration [m/s²]')
xlabel('Time [s]')
title(['\theta_{start} = ',num2str(theta_start),'    \theta_{intermediate} = ',num2str(theta_intermediate),'    \theta_{final} = ',num2str(theta_final)])
subplot(2,2,4)
hold on
plot(t,dthetadt_intermediate)
hold on
[AX] = plotyy(t,dthetadt_final,u(:,1),u(:,2));
set(get(AX(1),'Ylabel'),'String','Angular speed [rad/s]')
set(get(AX(2),'Ylabel'),'String','Acceleration [m/s²]')
xlabel('Time [s]')
title(['d\theta/dt_{start} = ',num2str(dthetadt_start),'    d\theta/dt_{intermediate} = ',num2str(dthetadt_intermediate),'    d\theta/dt_{final} = ',num2str(dthetadt_final)])