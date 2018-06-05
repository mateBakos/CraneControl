function names_cell = loadmeasurementnames()
cd ../../Simulation_results;
dinfo = dir();
names_cell = {dinfo.name};
names_cell=names_cell(3:end);
cd ../HelpFromWebsite/m-files;
end