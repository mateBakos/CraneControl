close all
clear all 
clc

xinit=[0 0 0 0 0 0];
Ts=0.01

load('BlackBoxID_meas8_order6')
Plant6 = ss(Blackbox_model);
load('BlackBoxID_meas9_order4')
Plant4 = ss(Blackbox_model);

plantPosition = Plant6(1,1);
plantAngle = Plant6(2,1);

% DiscPlant=c2d(ss(Blackbox_model),Ts,'tustin');
[A,B,C,D] = ssdata(Plant6);
[Ao,Bo,Co,Do] = ssdata(Plant6);

rho=1; % e10 e12 e15

poles=[-15, -16, -17, -18, -19, -20]
L=(place(Ao',Co',poles)')

Q= diag([1,1,1,1,1,1,1])
% [1 0 0 0 0 0;...
%     0 1 0 0 0 0;
%     0 0 1 0 0 0;
%     0 0 0 1 0 0;
%     0 0 0 0 1 0;
%     0 0 0 0 0 1];

R=1;

[F,~,~]=lqi(Plant6(1),Q,R)

Lcorr=1
