close all
clear all 
clc

xinit=[0 0 0 0 0 0];
Ts=0.01;

load('BlackBoxID_meas16_order6')
Plant6 = c2d(ss(Blackbox_model),Ts,'tustin');
load('BlackBoxID_meas16_order6')
Plant4 = c2d(ss(Blackbox_model),Ts,'tustin');

% DiscPlant=c2d(ss(Blackbox_model),Ts,'tustin');
[A,B,C,D] = ssdata(Plant6);
[Ao,Bo,Co,Do] = ssdata(Plant4);

[A,B,C,~,~] = obsvf(A,B,C)
[Ao,Bo,Co,~,~] = obsvf(Ao,Bo,Co)

%[kalmf,L,P,M] = kalman(Plant4,1,eye(2));

rho=1; % 0.042177e10 e12 e15

poles=[-15, -16, -17, -18, -19, -20];
L=(place(Ao',Co',exp(poles*Ts))');

Q=diag([0,0,0,0,100,100000000])% Co'*Co%%%% 
%
% [1 0 0 0 0 0;...
%     0 1 0 0 0 0;
%     0 0 1 0 0 0;
%     0 0 0 1 0 0;
%     0 0 0 0 1 0;
%     0 0 0 0 0 1];

R=1;

[F,~,~]=dlqr(Ao,Bo,Q,R);

Fcorr=pinv(dcgain(ss(Ao-Bo*F,Bo,Co,Do,Ts)))

RefFWD=Fcorr(1)%[0;0;0;0;0;Fcorr(1)]%[0;0;0;1/1209]
hwinit
% 
% 
% cd ../SimulinkModels/
% 
% sim('Crane_LQR_disc_noisy',30)
cov(simout2.Data)