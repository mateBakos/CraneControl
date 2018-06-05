function Simdata = loadfiles(filename)
Simdata = load(fullfile('..','..','Simulation_results',filename),'Simulation_results');
Simdata = Simdata.Simulation_results;
end