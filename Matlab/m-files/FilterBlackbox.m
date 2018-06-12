%% Import Simulation data;
%close all
clear all
clc

simData = loadfiles('Bernoulli_1m_10.mat');
%'Signal_xSin_yCos_4.mat'
%'initial_angle_14.mat'
plot_timeseries(simData)

beginSample  = 1;%162;
time   =  simData.Time(beginSample:end)-(beginSample-1)*0.01;
position = simData.Data(beginSample:end,2);
cable = simData.Data(beginSample:end,3);
inputx = simData.Data(beginSample:end,4);
inputy = simData.Data(beginSample:end,5);
angle    = -simData.Data(beginSample:end,1);
angle = angle - mean(angle)
% 
% beginSample  = 376;%326;%162;
% time   =  simData.Time(beginSample:end)-(beginSample-1)*0.01;
% position = -simData.Data(beginSample:end,1);
% position = position - position(end);
% cable = simData.Data(beginSample:end,2);
% inputx = simData.Data(beginSample:end,3);
% inputy = simData.Data(beginSample:end,4);
% angle    = -simData.Data(beginSample:end,5);
% angle = angle - mean(angle);
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

%% Filter Data
cutoff = 0.8 ;%0.2:0.1:0.9;
%for i = 1:length(cutoff)
i = 1;
clc
disp(['Iteration: ',num2str(i)])
data = iddata([position,angle],inputx,Ts,'Name','Measurement Data',...
    'OutputName',{'Position','Angle'}, ...
    'OutputUnit',{'m','rad'},...
    'InputName',{'x-velocity'}, ...
    'InputUnit',{'m/s'});

    [b,a] = butter(2,cutoff(i),'low');           % IIR filter design
    filteredPosition = filtfilt(b,a,position);                    % zero-phase filtering
    filteredAngle = filtfilt(b,a,angle);                    % zero-phase filtering
    %y2 = filter(b,a,x);                     % conventional filtering
    

filteredData = iddata([filteredPosition,filteredAngle],inputx,Ts,'Name','Measurement Data',...
    'OutputName',{'Position','Angle'}, ...
    'OutputUnit',{'m','rad'},...
    'InputName',{'x-velocity'}, ...
    'InputUnit',{'m/s'});

%% Black Box with 
%close all


%for order = 3:10
order = 5;
Blackbox_model_filtered = ssest(filteredData,order,'InitialState','estimate','Display','off');

% opt = greyestOptions('InitialState','estimate','Display','on');
% opt.EnforceStability = true;
% Greybox_model = greyest(data,Greybox_model,opt);
%figure
%[~, FIT, ~] = compare(data,Blackbox_model_unfiltered,Blackbox_model_filtered)
[~, FIT, ~] = compare(data,Blackbox_model_filtered);
 Fitstore(:,i) = FIT;
 %title(['The order of the black box = ',num2str(order)]) 
%end
Blackbox_model_unfiltered = ssest(data,order,'InitialState','estimate','Display','off');
[~, FITunfiltered, ~] = compare(data,Blackbox_model_unfiltered);
Fitstore
figure
compare(data,Blackbox_model_unfiltered);
title('The order of the black box =5 mean of angle array substracted')
 %save('initial_angle_14_Blackbox_model.mat','Blackbox_model')

% step(Crane);
% figure
% impulse(Crane);

 %figure
 %initial(Blackbox_model,[0,deg2rad(10),0,0])
