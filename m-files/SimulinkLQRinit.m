%close all
clear all 
clc

xinit=[0,0,0,0];
Ts=0.01

load('BlackBoxID_meas9_order4')
Plant = ss(Blackbox_model);

% DiscPlant=c2d(ss(Blackbox_model),Ts,'tustin');
% [A,B,C,D] = ssdata(DiscPlant);
[A,B,C,D] = ssdata(Plant);
gainAngle = 0;
gainPos   = 1;

rho=1e12; % e10 e12 e15

poles=[0,-15, -20 + 10i, -20 - 10i]
L=(place(A',C',poles)')

Q=rho*C'*C
R=1;
[F,~,~]=lqr(A,B,Q,R)

%Lcorr=pinv(dcgain(ss(A-B*K,B,C,D,Ts)))
Lcorr=1