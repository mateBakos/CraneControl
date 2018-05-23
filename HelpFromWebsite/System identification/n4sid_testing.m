clear all

Bernoulli_1 = load(fullfile('..','Simulation_results','Bernoulli_1m_10.mat'),'Simulation_results')
Bernoulli = Bernoulli_1.Simulation_results  


plot_timeseries(Bernoulli);
