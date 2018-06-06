%close all
clear all 
clc

%Load prev data
load 'Q1.mat'
load 'Q2.mat'
load 'Q3.mat'

xinit=[0 0 0 0];

%Calcualte desired poles
[y,t]=step(cl);
stepRes=stepinfo(y,t,'SettlingTimeThreshold',0.01);
%%
%change values from 2-10-100
h=stepRes.RiseTime/10 %*2 *1 /3

DiscPlant=c2d(ss(P),h,'tustin'); 

%Fill matrices for simulink
A=DiscPlant.A
B=DiscPlant.B
C=DiscPlant.C
D=DiscPlant.D

load('BlackBoxID_meas9_order4')
Plant = ss(Blackbox_model);
[A,B,C,D] = ssdata(Plant);
gainAngle = 0;
gainPos   = 1;

rho=1e12; % e10 e12 e15

Q=rho*C'*C
R=1;
[K,~,~]=lqr(A,B,Q,R)

Lcorr=inv(dcgain(ss(A-B*K,B,C,D,h)))

run Q7.slx
