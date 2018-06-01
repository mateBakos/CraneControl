%% Import Simulation data;
close all
simData = loadfiles('initial_angle_14.mat');
%plot_timeseries(simData)
beginSample  = 326;%162;
timevector   =  simData.Time(beginSample:end)-(beginSample-1)*0.01;
positiondata = -simData.Data(beginSample:end,1);
angledata    = -simData.Data(beginSample:end,5);
angledata = angledata - mean(angledata);
figure(1)
subplot(2,1,1)
plot(timevector,positiondata)
subplot(2,1,2)
plot(timevector,angledata)
h = 0.01;
%% Building Model
M   = 0.95; % Trolley mass [kg]
m   = 1.30; % Container mass [kg]
L   = 1;   % Cable length [m]
k_m = -10;  % Nm
b_x = 10;  % kgs-1
b_phi = 0.9; %pdf value: 0.75;% kgs-1
g = 9.81;
Ts=0.01;


linear_model = idgrey('LinCraneSS',{M,m,L,k_m,b_x,b_phi},'d');
ydata = iddata([positiondata,angledata],zeros(size(positiondata)),h,'Name','Hand-induced initial angle of appr 30 degrees',...
    'OutputName',{'Position','Angle'}, ...
    'OutputUnit',{'m','rad'});
%CraneModel = greyest(ydata,linear_model,'InitialState','estimate','Display','on');
%% 
close all
[CraneModel,estimated_initial_state] = ssest(ydata,20,'InitialState','estimate','Display','on')
% modelData = initial(Crane,[0,deg2rad(10),0,0],timevector)
EstSSCrane = ss(CraneModel(1,1).a,CraneModel(1,1).b,[CraneModel(1,1).c;CraneModel(2,1).c],0)
%%Plot results
figure
hold on
[data,data2]=initial(EstSSCrane,estimated_initial_state,timevector(end));
%subplot(2,1,1)
plot(data2,data(:,1))
plot(timevector,positiondata)

figure
hold on
%subplot(2,1,2)
plot(data2,data(:,2))
plot(timevector,angledata)
%compare([positiondata,angledata],data)
% step(Crane);
% figure
% impulse(Crane);

% figure


