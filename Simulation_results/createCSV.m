function createCSV(filename)
%filename = 'Signal_xSin_yCos_5';
matfile = [filename,'.mat'];
load(matfile);
data = Simulation_results.data;
data = data';
if size(data,2)>size(data,1)
    data = data';
end
angdata = data(:,1)';
posdata = data(:,2)';
ldata   = data(:,3)';
inputxdata = data(:,4)';
inputydata = data(:,5)';



csvwrite(['pos_',filename,'.csv'],posdata);
csvwrite(['ang_',filename,'.csv'],angdata);
csvwrite(['length_',filename,'.csv'],ldata);

end