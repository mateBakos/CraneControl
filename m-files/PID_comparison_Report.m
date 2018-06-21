%% Create PID Comparison
% Load measurements as timeseries
%clear all
load('SR14_PID_4th_order_onlyP')
PID_optimal = simout;

load('SR11_PID_4th_order')
PID_no_control = simout;
clear simout

%% Supply Title and Dataset labels
plotTitle    = 'PID vs no control';
datasetName1 = 'P-Control';
datasetName2 = 'PD-Control';

plotCompare(PID_optimal,PID_no_control,plotTitle,datasetName1,datasetName2)
