%close all
clear all 
clc

%Load prev data
load 'Q9.mat'
load 'Q9d.mat'
load 'Q9disc.mat'

xinit=[0 0 0 0];

%Calcualte desired poles
[y,t]=step(cl);
stepRes=stepinfo(y,t,'SettlingTimeThreshold',0.01);
%%
%change values from 2-10-100
[cp,dp,h] = polePlacement(0.01/100,stepRes.PeakTime,10)
%%
%change values from 2-10-100
h=stepRes.RiseTime/11 %*2 *1 /3

DiscPlant=c2d(ss(P),h,'tustin'); 

%Fill matrices for simulink
A=DiscPlant.A
B=DiscPlant.B
C=DiscPlant.C
D=DiscPlant.D

rho=1e6; % e10 e12 e15

Q=rho*C'*C
R=1;
[K,~,~]=dlqr(A,B,Q,R)

Lcorr=inv(dcgain(ss(A-B*K,B,C,D,h)))

run Q9pole.slx
