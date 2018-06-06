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
[cp,dp,h] = polePlacement(stepRes.Overshoot/100,stepRes.PeakTime,10)

%Fill matrices for simulink
A=DiscPlant.A;
B=DiscPlant.B;
C=DiscPlant.C;
D=DiscPlant.D;

K=place(A,B,dp)

Lcorr=inv(dcgain(ss(A-B*K,B,C,D,h)))

run Q5.slx
