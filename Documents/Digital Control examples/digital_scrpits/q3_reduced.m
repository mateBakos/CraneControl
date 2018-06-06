% BELOW, CHOOSE ONE CONTROLLER1 BY COMMENTING THE OTHER
close all;
clear;
set(0,'defaultfigurecolor',[1 1 1])

sys = tf(1,[0.1, 1, 0, 0]); % G(s)
[A, B, C, D] = ssdata(sys);
% wc = 2;
% angle = 80;
% alpha = (1-sin(angle*pi/180))/(1+sin(angle*pi/180));
% T = 1/(wc*sqrt(alpha));

% CHOOSE ONE PD CONTROLLER BELOW

controller1 = tf(0.25*[8 1],[0.05 1]); % PD
h1 = 0.15; % sampling for q1

% controller1 = tf(0.2*[16 1],[0.15 1]); % PD
% h1 = 0.08; % sampling for q1

[contA, contB, contC, contD] = ssdata(controller1);
contr = 20000*(tf([0.03, 1],[0.0009 1]))^2; % PDD q2
CI = tf([0.08, 1],[0.08, 0]); % I term
controller2 = contr*CI; % q2
h2 = 0.003; % sampling for q2
opt_sys = c2dOptions('Method', 'zoh'); % discrete options for system
opt_con = c2dOptions('Method', 'tustin'); % discrete options for controlers

sysd1 = c2d(ss(sys), h1, opt_sys) % discr of sys for q1
[A1, B1, C1, D1, h1] = ssdata(sysd1);
sysd2 = c2d(ss(sys), h2, opt_sys);
[A2, B2, C2, D2, h2] = ssdata(sysd2); % discr of sys for q2
controller_1d = c2d(ss(controller1), h1, opt_con); % discr of contr for q1
controller_2d = c2d(ss(controller2), h2, opt_con); % discr of contr for q2
[A_sc, B_sc, C_sc, D_sc, h1] = ssdata(controller_1d);
[A_dr, B_dr, C_dr, D_dr, h2] = ssdata(controller_2d);

% continuous model
D_sys11 = feedback(controller1*sys,1);
step(D_sys11);
hold on;

% discrete model
D_sys1 = feedback(controller_1d*sysd1,1);
step(D_sys1);
title('Reference tracking');
legend('Continuous-time','Discrete-time')

figure;
u = controller1/(1+controller1*sys);
step(u)
hold on;
u1 = controller_1d/(1+controller_1d*sysd1);
step(u1);
title('Control action for reference tracking');
figure;

% continuous model
D_sys22 = sys/(controller2*sys+1);
step(D_sys22);
hold on;

% discrete model
D_sys2 = sysd2/(controller_2d*sysd2+1);
step(D_sys2);
title('Disturbance rejection');
legend('Continuous-time','Discrete-time')
% figure;
% D_sys3 = feedback(controller_2d*sysd2,1);
% step(D_sys3);
% title('Step response of discrete disturbance controller');
figure;
u2 = 1/(1+controller_2d*sysd2);
step(u2);
title('Control action for disturbance rejection');