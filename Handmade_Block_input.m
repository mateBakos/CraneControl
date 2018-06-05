close all
clear all
h = 0.01; % Step size: sec.
T = 60; % Final time: sec
t = [0:h:T];

signal = (t > 1.5)-(t>5)+(t>8)-(t>12)+(t>15)-(t>18)+(t>25)-(t>29) ... 
   - (t > 33 ) + (t>39) - (t > 42 ) + (t>47) - (t > 51) + (t>55);% - (t>) ;
y = zeros(size(t,1),1)';
signalInput = timeseries(signal,t);
stepCoordinates = [0.5 , 2];%, 5 , 8 , 10 , 13 , 19,23,27,29,35,37,43,48,52,55];
stepsign = 1;   
for i = size(stepCoordinates,2)
    y = y + stepsign * (t>stepCoordinates(i));
    stepsign=stepsign*-1;
    if(i == 5)
        stepsign=stepsign*-1;
    end
%     close all ;
%     plot(t,y);
end
plot(t,y)