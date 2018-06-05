%% Import Simulation data;
close all
clear all
clc

simData = loadfiles('Handmade_bernoulli_17.mat');
%plot_timeseries(simData)

beginSample  = 1;%162;
time     =  simData.Time(beginSample:end)-(beginSample-1)*0.01;
position = simData.Data(beginSample:end,2);
inputx  = simData.Data(beginSample:end,4);
angle1  = -simData.Data(beginSample:end,1);
angle1 = angle1 - angle1(1);
angle   =  detrend(angle1);
Ts=0.01;
%% Building Model
data = iddata([position,angle],inputx,Ts,'Name','Measurement Data',...
    'OutputName',{'Position','Angle'}, ...
    'OutputUnit',{'m','rad'},...
    'InputName',{'x-velocity'}, ...
    'InputUnit',{'m/s'});

[b,a]=butter(2,0.1);
angle2   =  filtfilt(b,a,angle);
%angle2   =  movmean(angle,21)
data2 = iddata([position,angle2],inputx,Ts,'Name','Measurement Data',...
    'OutputName',{'Position','Angle'}, ...
    'OutputUnit',{'m','rad'},...
    'InputName',{'x-velocity'}, ...
    'InputUnit',{'m/s'});


%% 
Weights = 15;%[15,16,26];
for i = 1:size(Weights,2)
disp(['Iteration ',num2str(i)])
opt = ssestOptions;

%opt.OutputWeight = [1 0;0 Weights(i)];

Blackbox_model = ssest(data,6,'Display','off',opt); %6 works well
%figure
[~,FIT(i,:),~] = compare(data,Blackbox_model)
zeropolegain = tf(zpk(Blackbox_model))
pole(zeropolegain)
TargetDoublePoleGain = (0.5*2*pi)^2;
end
[index,maximum] = max(FIT(:,2))

compare(data2,Blackbox_model)
%% 
% step(Crane);
figure
impulse(Blackbox_model,10);

 %figure
 %initial(Blackbox_model,[0,deg2rad(10),0,0])
