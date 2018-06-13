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
orderNum = 4; 

% change name to get around overwriting models
saveName=['BlackBoxID_disc_meas',num2str(measurementNum),'_order',num2str(orderNum),'.mat'];
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
plot_timeseries(simData);

%% Build model
beginSample = 1;
time     =  simData.Time(beginSample:end)-(beginSample-1)*0.01;
position = simData.Data(beginSample:end,2);
inputx  = simData.Data(beginSample:end,4);
angle1  = -simData.Data(beginSample:end,1);
angle1 = angle1 - angle1(1);
angle   =  detrend(angle1);
Ts=0.01;


load('BlackBoxID_meas9_order4.mat')
H = [tf([2 5 1],[1 2 3]);tf([1 -1],[1 1 5])];
%lsim(ss(Blackbox_model),inputx,time)
lsim(H,inputx,time)
%%

% indices to unique values in column 3
[~, ind] = unique(time, 'rows')
% duplicate indices
duplicate_ind = setdiff(time, ind)
% duplicate values
duplicate_value = time(duplicate_ind);



find(hist(time,unique(time))>1)