close all
clear all 
clc

xinit=[0,0,0,0]%[0.1,1,2,0.5,0.2,0.7];%[?,?,position,?,?,?]
Ts=0.01

load('BlackBoxID_meas8_order6')
load('BlackBoxID_meas9_order4')

Plant = ss(Blackbox_model);

DiscPlant=c2d(ss(Blackbox_model),Ts,'tustin');
[A,B,C,D] = ssdata(DiscPlant);
%[A,B,C,D] = ssdata(Plant);
gainAngle = 0;
gainPos   = 1;

rho=1; % e10 e12 e15

poles=[-3,-5,-11,-12]
L=(place(A',C',poles)')

Q=eye(size(A))%rho*C'*C
R=1;
[F,~,~]=dlqr(A,B,Q,R)

Lcorr1=inv(dcgain(ss(A-B*F,B,C(1,:),D(1),Ts)))
Lcorr2=inv(dcgain(ss(A-B*F,B,C(2,:),D(2),Ts)))
Lcorr=[Lcorr1;Lcorr2]
Lx=dcgain(ss(A-B*F,B,C,D,Ts))
Lcorr=inv(Lx(1))



% figure
% impulse(Blackbox_model)
% 
% figure
% step(Blackbox_model)


