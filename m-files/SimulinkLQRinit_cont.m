close all
clear all 
clc

xinit=[0,0,0,0];
Ts=0.01

load('BlackBoxID_meas8_order6')
Plant = ss(Blackbox_model);
plantPosition = Plant(1,1);
plantAngle = Plant(2,1);

figure
margin(plantPosition)
figure
margin(plantAngle)
% DiscPlant=c2d(ss(Blackbox_model),Ts,'tustin');
% [A,B,C,D] = ssdata(DiscPlant);
[A,B,C,D] = ssdata(Plant);
gainAngle = 0;
gainPos   = 1;

rho=1; % e10 e12 e15

poles=[0,-15, -20 + 10i, -20 - 10i, -30, -31]
L=(place(A',C',poles)')

Q=rho*C'*C
R=1;
[F,~,~]=lqr(A,B,Q,R)

%Lcorr=pinv(dcgain(ss(A-B*K,B,C,D,Ts)))
Lcorr=1


figure
impulse(Blackbox_model,5)

figure
step(Blackbox_model,5)



