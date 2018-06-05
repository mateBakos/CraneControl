clear all
close all
clc

h=0.01

Bernoulli_1 = load(fullfile('Simulation_results','Step_by_hand_1m_12.mat'),'Simulation_results')
Bernoulli = Bernoulli_1.Simulation_results;  
plot_timeseries(Bernoulli);

IDdata=iddata(Bernoulli.Data(:,1:3),Bernoulli.Data(:,4:5),h);
sys = n4sid(IDdata,4)

figure()
impulse(sys)
