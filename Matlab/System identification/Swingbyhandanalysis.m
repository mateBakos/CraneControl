clear all
swingdata = load(fullfile('..','Simulation_results','Hand-swing_1m_8.mat'),'Simulation_results');
swingdata = swingdata.Simulation_results;  


plot_timeseries(swingdata);

%Read off peak times: First peak: 4.1 sec. Twelft Peak 28.23 sec
T = (28.2 - 4.1)/12;
f = 1/T; %[1/s]
g = 9.81; %[m/s^2]
L = (T/(2*pi))^2 * g ;% [m]

offset = - 0.2224;
Peakvalues = [0.02848 , 0.006871 ,0.008585 ,0.0002227];
normPeakvalues = Peakvalues - ones(1,size(Peakvalues,2))*offset;

dampingCoefficient = log(normPeakvalues(2:4)./normPeakvalues(1:3));
