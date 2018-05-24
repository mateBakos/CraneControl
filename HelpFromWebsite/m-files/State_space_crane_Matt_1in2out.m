%% Import Simulation data;
close all
clear all
clc

simData = loadfiles('initial_angle_14.mat');
%'Signal_xSin_yCos_4.mat'
%'initial_angle_14.mat'
plot_timeseries(simData)

beginSample  = 376;%326;%162;
time   =  simData.Time(beginSample:end)-(beginSample-1)*0.01;
position = -simData.Data(beginSample:end,1);
position = position - position(end);
cable = simData.Data(beginSample:end,2);
inputx = simData.Data(beginSample:end,3);
inputy = simData.Data(beginSample:end,4);
angle    = -simData.Data(beginSample:end,5);
angle = angle - mean(angle);
% figure(1)
% subplot(2,1,1)
% plot(timevector,positiondata)
% subplot(2,1,2)
% plot(timevector,angledata)

%% Building Model
M   = 0.95; % Trolley mass [kg]
m   = 1.30; % Container mass [kg]
L   = 1;   % Cable length [m]
k_m = 10;  % Nm
b_x = 10;  % kgs-1
b_phi = 0.9; %pdf value: 0.75;% kgs-1
g = 9.81;
Ts=0.01;

data = iddata([position,angle],inputx,Ts,'Name','Measurement Data',...
    'OutputName',{'Position','Angle'}, ...
    'OutputUnit',{'m','rad'},...
    'InputName',{'x-velocity'}, ...
    'InputUnit',{'m/s'});

%% Greybox setup

FileName      = 'GreyBoxDiffModel_1in2out';        % File describing the model structure.
Order         = [2 1 4];%[3 2 4];             % Model orders [ny nu nx].
Parameters    = [M,m,L,b_x,b_phi];   % Initial parameters.
InitialStates = [0,deg2rad(20),0,0]';              % Initial initial states.
nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts);

nlgr.OutputName = {'Position','Angle'};
nlgr.OutputUnit = {'m','rad'};
nlgr.TimeUnit = 's';
nlgr = setinit(nlgr, 'Name', {'Trolley position' 'Container Angle'...
                    'Trolley velocity' 'Container Angular velocity'});
nlgr = setinit(nlgr, 'Unit', {'m' 'rad' 'm/s' 'rad/s'});
nlgr = setpar(nlgr, 'Name', {'Trolley mass' 'Container Mass' ...
                      'Initial Cable Length' ...
                      'Trolley damping' 'Cable Damping'});
nlgr = setpar(nlgr, 'Unit', {'kg' 'kg' 'm' 'kgs-1' 'kgs-1*m'});
nlgr = setpar(nlgr, 'Minimum', {eps(0) eps(0) eps(0) eps(0) eps(0)});   % All parameters > 0.

% A. Model computed with first-order Euler forward ODE solver.
nlgref = nlgr;
nlgref.SimulationOptions.Solver = 'ode1';        % Euler forward.
nlgref.SimulationOptions.FixedStep = Ts*0.1;   % Step size.

% B. Model computed with adaptive Runge-Kutta 23 ODE solver.
nlgrrk23 = nlgr;
nlgrrk23.SimulationOptions.Solver = 'ode23';     % Runge-Kutta 23.

% C. Model computed with adaptive Runge-Kutta 45 ODE solver.
nlgrrk45 = nlgr;
nlgrrk45.SimulationOptions.Solver = 'ode45';     % Runge-Kutta 45.

figure(1)
%compare(data, nlgref)%, nlgrrk23, nlgrrk45)
%sim(nlgref,data)
compare(data, nlgref, nlgrrk23, nlgrrk45, 1, ...
compareOptions('InitialCondition', 'model'));


%Greybox_model = idgrey('LinCraneSS',{M,m,L,k_m,b_x,b_phi},'d');

% 
% Blackbox_model = ssest(data,100,'InitialState','estimate','Display','on');
% 
% 
% 
% % opt = greyestOptions('InitialState','estimate','Display','on');
% % opt.EnforceStability = true;
% % Greybox_model = greyest(data,Greybox_model,opt);
% figure
%  compare(data,Blackbox_model)
%  
%  save('initial_angle_14_Blackbox_model.mat','Blackbox_model')
% 
% % step(Crane);
% % figure
% % impulse(Crane);
% 
%  %figure
%  %initial(Blackbox_model,[0,deg2rad(10),0,0])
