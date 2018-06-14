close all
clear all 
clc

xinit=[0 0 0 0];
Ts=0.01

load('BlackBoxID_meas8_order6')
Plant6 = ss(Blackbox_model);
load('BlackBoxID_meas9_order4')
Plant4 = ss(Blackbox_model);

plantPosition = Plant4(1,1);
plantAngle = Plant4(2,1);

% figure
% margin(plantPosition)
% figure
% margin(plantAngle)
% DiscPlant=c2d(ss(Blackbox_model),Ts,'tustin');
% [A,B,C,D] = ssdata(DiscPlant);
[A,B,C,D] = ssdata(Plant6);
%[A, B, C, D, P] = canon(A, B, C, D, 'companion')
[Ao,Bo,Co,Do] = ssdata(Plant4);
%[Ao, Bo, Co, Do, Po] = canon(Ao, Bo, Co, Do, 'companion')
%compan(Po)
rho=1; % e10 e12 e15

poles=[-15, -16, -17, -18]
L=(place(Ao',Co',poles)')

Q= [1 0 0 0;...
    0 1 0 0;
    0 0 1 0;
    0 0 0 100];
R=1;
[F,~,~]=lqr(Ao,Bo,Q,R)
%[F,~,~]=lqi(Plant4(1),Q,R)

%Lcorr=pinv(dcgain(ss(A-B*K,B,C,D,Ts)))
Lcorr=1
% 
% 
% figure
% impulse(Blackbox_model,5)
% 
% figure
% step(Blackbox_model,5)
% 
% 
% 
