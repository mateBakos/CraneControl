%% Import Simulation data;
close all
simData = loadfiles('initial_angle_14.mat');
%plot_timeseries(simData)
beginSample  = 162;
timevector   =  simData.Time(beginSample:end);
positiondata = -simData.Data(beginSample:end,1);
angledata    = -simData.Data(beginSample:end,5);
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

A = [0,0,1,0;
    0,0,0,1;
    0,m*g/M,-b_x,-m*b_phi;
    0,(-m*g-M*g)/(M*L),-b_x,(-m*b_phi-M*b_phi)/(M*L)];
B = [0;0;1/M;1/(M*L)];
C = [1,0,0,0;
    0,1,0,0];
D = [0;0];
% figure
 Crane = ss(A,B,C,D);
% step(Crane);
% figure
% impulse(Crane);
figure
initial(Crane,[0,deg2rad(10),0,0])