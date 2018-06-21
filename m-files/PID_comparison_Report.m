%% Create PID Comparison
% Load measurements as timeseries
%clear all
load('SR16_LQR_4th_400')
PID_optimal = simout;

load('SR19_LQR_4th_400_R_2')
PID_no_control = simout;
clear simout

%% Supply Title and Dataset labels
plotTitle    = 'PID vs no control';
datasetName1 = 'R 1';%'P-Control';
datasetName2 = 'R = 2';%'LQR-Control';

plotCompare(PID_optimal,PID_no_control,plotTitle,datasetName1,datasetName2)
