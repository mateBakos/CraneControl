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
[cp,dp,h] = polePlacement(0.0000001/100,stepRes.PeakTime,10)

%Fill matrices for simulink
A=DiscPlant.A;
B=DiscPlant.B;
C=DiscPlant.C;
D=DiscPlant.D;

K=place(A,B,dp)
Kd=100

Lcorr=inv(dcgain(ss(A-B*K,B,C,D,h)))

run Q9poledist.slx
