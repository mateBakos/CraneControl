function [continousPoles,discretePoles,samplingTime] = polePlacement(peakVal,peakTime,fastPoleMultiplier)

kszi=sqrt((log(peakVal))^2/((log(peakVal))^2+pi^2))
omega=-log(peakVal)/kszi/peakTime

eq=[1 2*kszi*omega omega^2];

sol=roots(eq);
continousPoles=[sol;real(sol(1))*fastPoleMultiplier*1.1;real(sol(1))*fastPoleMultiplier]';
samplingTime=2*pi/2/max(abs(continousPoles));

discretePoles=exp(samplingTime*continousPoles);