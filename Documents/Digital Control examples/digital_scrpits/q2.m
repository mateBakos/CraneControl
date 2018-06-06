close all;
clear;
set(0,'defaultfigurecolor',[1 1 1])

sys = tf(1,[0.1, 1, 0, 0]); % G(s)
q1 = 2209*(tf([0.1, 1],[0.0008 1]))^2; % PDD from q1
contr = 20000*(tf([0.03, 1],[0.0009 1]))^2;
%contr = 310000*(tf([0.01, 1],[0.0007 1]))^2; % PDD for q2
%contr = 4500*(tf([0.04, 1],[0.004 1]))^2;
%contr = 300000*(tf([0.01, 1],[0.001 1]))^2;
CI = tf([0.08, 1],[0.08, 0]); % I term
controller = contr*CI; % PIDD
D_sys = sys/(controller*sys+1); % closed loop
D_sys_q1 = sys/(q1*sys+1);
step(D_sys_q1);
title('Disturbance rejection with the controller from q1')
figure;
u = 1/(1+controller*sys); % control action tf
D_sys2 = feedback(controller*sys,1); % step response only to check if stable
step(u);
title('Control action for disturbance rejection')
figure;
step(D_sys);
title('Disturbance rejection')
figure;
step(D_sys2);
title('Step responce of the disturbance controller')
figure;
bode(controller*sys);
title('Bode plot of controller*plant (open loop)')