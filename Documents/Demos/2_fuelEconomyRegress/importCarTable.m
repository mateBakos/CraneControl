function tableout = importCarTable(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE1 Import data from a spreadsheet
%   DATA = IMPORTFILE1(FILE) reads data from the first worksheet in the
%   Microsoft Excel spreadsheet file named FILE and returns the data as a
%   table.
%
%   DATA = IMPORTFILE1(FILE,SHEET) reads from the specified worksheet.
%
%   DATA = IMPORTFILE1(FILE,SHEET,STARTROW,ENDROW) reads from the specified
%   worksheet for the specified row interval(s). Specify STARTROW and
%   ENDROW as a pair of scalars or vectors of matching size for
%   dis-contiguous row intervals. To read to the end of the file specify an
%   ENDROW of inf.
%
%	Rows with non-numeric cells are excluded.
%
% Example:
%   CarData = importfile1('2004dat.xlsx','Sheet1',2,2338);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2015/09/16 22:47:54

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 2338;
end

%% Import the data
[~, ~, raw1] = xlsread(workbookFile, sheetName, sprintf('A%d:T%d',startRow(1),endRow(1)));
[~, ~, raw2] = xlsread(workbookFile, sheetName, sprintf('V%d:W%d',startRow(1),endRow(1)));
raw = [raw1,raw2];
for block=2:length(startRow)
    [~, ~, tmpRawBlock1] = xlsread(workbookFile, sheetName, sprintf('A%d:T%d',startRow(block),endRow(block)));
    [~, ~, tmpRawBlock2] = xlsread(workbookFile, sheetName, sprintf('V%d:W%d',startRow(block),endRow(block)));
    raw = [raw;tmpRawBlock1,tmpRawBlock2]; %#ok<AGROW>
end
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[2,3,4,6,8,9,14,17]);
raw = raw(:,[1,5,7,10,11,12,13,15,16,18,19,20,21,22]);

%% Exclude rows with non-numeric cells
I = ~all(cellfun(@(x) (isnumeric(x) || islogical(x)) && ~isnan(x),raw),2); % Find rows with non-numeric cells
raw(I,:) = [];
cellVectors(I,:) = [];

%% Create output variable
J = cellfun(@(x) ischar(x), raw);
raw(J) = {NaN};
data = reshape([raw{:}],size(raw));

%% Create table
tableout = table;

%% Allocate imported array to column variable names
tableout.Year = data(:,1);
tableout.MfrName = cellVectors(:,1);
tableout.CarLine = cellVectors(:,2);
tableout.Car_Truck = cellVectors(:,3);
tableout.EngDisp = data(:,2);
tableout.Police = cellVectors(:,4);
tableout.RatedHP = data(:,3);
tableout.Transmission = cellVectors(:,5);
tableout.Drive = cellVectors(:,6);
tableout.Weight = data(:,4);
tableout.Comp = data(:,5);
tableout.AxleRatio = data(:,6);
tableout.EVSpeedRatio = data(:,7);
tableout.AC = cellVectors(:,7);
tableout.PRP = data(:,8);
tableout.FuelType = data(:,9);
tableout.City_Highway = cellVectors(:,8);
tableout.HC = data(:,10);
tableout.CO = data(:,11);
tableout.CO2 = data(:,12);
tableout.MPG = data(:,13);
tableout.Valves_Cyl = data(:,14);

idx = cellfun(@isnumeric,tableout.Drive);
tableout.Drive(idx) = {'4'};
