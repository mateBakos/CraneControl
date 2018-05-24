%% Import Simulation data;
close all
simData = loadfiles('initial_angle_14.mat');
%plot_timeseries(simData)
beginSample  = 326;%162;
timevector   =  simData.Time(beginSample:end)-(beginSample-1)*0.01;
positiondata = -simData.Data(beginSample:end,1);
angledata    = -simData.Data(beginSample:end,5);
angledata = angledata - mean(angledata);
figure(1)
subplot(2,1,1)
plot(timevector,positiondata)
subplot(2,1,2)
plot(timevector,angledata)

%% Building Model
M   = 0.95; % Trolley mass [kg]
m   = 1.30; % Container mass [kg]
L   = 1;   % Cable length [m]
k_m = -10;  % Nm
b_x = 10;  % kgs-1
b_phi = 0.9; %pdf value: 0.75;% kgs-1
g = 9.81;
Ts=0.01;

linear_model = idgrey('LinCraneSS',{M,m,L,k_m,b_x,b_phi},'d');
CraneModel = greyest(
% step(Crane);
% figure
% impulse(Crane);

% figure
 modelData = initial(Crane,[0,deg2rad(10),0,0],timevector)
