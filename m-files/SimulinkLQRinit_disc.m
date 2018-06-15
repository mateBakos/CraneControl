close all
clear all 
clc

xinit=[0 0 0 0];
Ts=0.2

load('BlackBoxID_meas8_order6')
Plant6 = c2d(ss(Blackbox_model),Ts,'tustin');
load('BlackBoxID_meas9_order4')
Plant4 = c2d(ss(Blackbox_model),Ts,'tustin');

% DiscPlant=c2d(ss(Blackbox_model),Ts,'tustin');
[A,B,C,D] = ssdata(Plant6);
[Ao,Bo,Co,Do] = ssdata(Plant4);

[A,B,C,~,~] = obsvf(A,B,C)
[Ao,Bo,Co,~,~] = obsvf(Ao,Bo,Co)

%[kalmf,L,P,M] = kalman(Plant4,1,eye(2));

rho=1; % 0.042177e10 e12 e15

poles=[-15, -16, -17, -18];
L=(place(Ao',Co',exp(poles*Ts))');

Q= Co'*Co %diag([0,0,1,1])
% [1 0 0 0 0 0;...
%     0 1 0 0 0 0;
%     0 0 1 0 0 0;
%     0 0 0 1 0 0;
%     0 0 0 0 1 0;
%     0 0 0 0 0 1];

R=1;

[F,~,~]=dlqr(Ao,Bo,Q,R);

RefFWD=[0;0;0;1/1209]

%Lcorr=inv(dcgain(ss(Ao-Bo*F,Bo,Co,Do,Ts)))

cd ../SimulinkModels/

sim('Crane_LQR_disc_noisy',30)
