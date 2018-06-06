function stepChar(cl)

[y,t] = step(cl);

txScale=1.05;

stepResults = stepinfo(y,t,'SettlingTimeThreshold',0.01);
% Extract the settling time from the stepinfo structure
tSettle= stepResults.SettlingTime
% Other step response results of interest can be found by looking in
% the stepResults structure
% Find the first index where time exceeds the settling time
% To further improve this, you could interpolate between the points.
indexSettle = find(t >= tSettle,1,'first');
xSettle = t(indexSettle);
ySettle = y(indexSettle);
% Plot step response
plot(t,y); 
grid on;
hold on;
% Plot settling time point
plot(xSettle,ySettle,'ko');
% Plot chart lines to settling point
plot([0 xSettle],[ySettle ySettle],'k-.');
plot([xSettle xSettle],[0 ySettle],'k-.');

setText=['Time: ',num2str(xSettle)];
text(txScale*xSettle,txScale*ySettle,setText);
% Plot peak time point
plot(stepResults.PeakTime,stepResults.Peak,'ro');
% Plot chart lines to settling point
plot([0 stepResults.PeakTime],[stepResults.Peak stepResults.Peak],'r-.');
plot([stepResults.PeakTime stepResults.PeakTime],[0 stepResults.Peak],'r-.');
peakText=['Overshoot(%): ',num2str(stepResults.Overshoot)];
text(txScale*stepResults.PeakTime,txScale*stepResults.Peak,peakText);

hold off;