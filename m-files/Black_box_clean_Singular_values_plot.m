%% Import Simulation data;
%close all
clear all
%clc


%% Config variables
validateFlag=0;

% Validation Files 13-14
% Identification 7-10
measurementNum = 8;
validationNum = 14;

% choose 4th or 6th order
orderNum = 6;%1:10; 

% change name to get around overwriting models
saveName=['BlackBoxID_meas',num2str(measurementNum),'_order',num2str(orderNum),'.mat'];
%% Load files
simNames = loadmeasurementnames();

% Validation Files 12-14
% Identification 7-10
if validateFlag==0
    measChosen=simNames(measurementNum);
else 
    measChosen=simNames(validationNum);
end
    
simData = loadfiles(measChosen{1});

plotsimo(simData,'Open-loop measurement, Contructed signal')

if validateFlag==0
    titleTxt=['Estimation, order ',num2str(orderNum),' file ',measChosen{1}];
    disp('Estimating model!')
    disp(['   Order of model estimation: ',num2str(orderNum)]);
    disp(['   Measurement used: ',measChosen{1}]);
else
    titleTxt=['Validation, order ',num2str(orderNum),' file ',measChosen{1}];
    load(saveName)
    disp('Validating model!')
    disp(['   Order of model used: ',num2str(orderNum)]);
    disp(['   Measurement used: ',measChosen{1}]);
end

% Building Model

beginSample  = 1;%162;
time     =  simData.Time(beginSample:end)-(beginSample-1)*0.01;
position = simData.Data(beginSample:end,2);
inputx  = simData.Data(beginSample:end,4);
angle1  = -simData.Data(beginSample:end,1);
%angle1 = angle1 - angle1(1);
angle   =  detrend(angle1);
Ts=0.01;

% Import original data
data_orig = iddata([position,angle],inputx,Ts,'Name','Measurement Data',...
    'OutputName',{'Position','Angle'}, ...
    'OutputUnit',{'m','rad'},...
    'InputName',{'x-velocity'}, ...
    'InputUnit',{'m/s'});

% Filter original data for comparison
[b,a]=butter(2,0.1);
angle2   =  filtfilt(b,a,angle);
data_filt = iddata([position,angle2],inputx,Ts,'Name','Measurement Data',...
    'OutputName',{'Position','Angle'}, ...
    'OutputUnit',{'m','rad'},...
    'InputName',{'x-velocity'}, ...
    'InputUnit',{'m/s'});

%% Identify blackbox model
opt = ssestOptions;
if orderNum==4 || orderNum == 5
    opt.OutputWeight = [1 0;0 15];
end
if validateFlag==0
    opt.Display = 'on';
    Blackbox_model = ssest(data_orig,orderNum,opt); %6 works well
    disp(['Model saved as: ',saveName]);
    %save(saveName,'Blackbox_model')
end


%% DEBUG: Analyse captured frequencies
[~,FIT,~] = compare(data_filt,Blackbox_model);
disp('Model accuracy to filtered measurement:')
disp(['   Position: ',num2str(FIT(1)),' %']);
disp(['   Angle: ',num2str(FIT(2)),' %']);
% zeropolegain = tf(zpk(Blackbox_model))
% pole(zeropolegain)
% TargetDoublePoleGain = (0.5*2*pi)^2;
% [index,maximum] = max(FIT(:,2))

%% Display
figure
title(titleTxt)
compare(data_filt,Blackbox_model)

