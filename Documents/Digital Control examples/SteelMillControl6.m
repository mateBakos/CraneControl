close all
clear all 
clc

%Load prev data
load 'Q1.mat'
load 'Q2.mat'
load 'Q3.mat'

xinitObs=[0 0 0 0];
xinit=[-17 5 -8 0.5];

%Calcualte desired poles
[y,t]=step(cl);
stepRes=stepinfo(y,t,'SettlingTimeThreshold',0.01);
[cp,dp,h] = polePlacement(stepRes.Overshoot/100,stepRes.PeakTime,10)

%Fill matrices for simulink
A=DiscPlant.A;
B=DiscPlant.B;
C=DiscPlant.C;
D=DiscPlant.D;

K=place(A,B,dp)

L=(place(A',C',dp/1.5))'

Lcorr=inv(dcgain(ss(A-B*K,B,C,D,h)))

save('Q6.mat','h','cp','A','B','C','D','K','xinitObs','xinit')

run Q6.slx