close all
clear all 
clc

%Load prev data
load 'Q6.mat';

xinitObs=[xinitObs 0];
xinit=[xinit 0];

%h=0.02


w = 1;
xw = B;
A = [A xw; zeros(1,4) w]
B = [B; 0]
C = [C 0]
D = D

cp = [cp, -70]
dp = exp(h*cp)

K = [K 1]


L=(place(A',C',dp/1.5))'

Lcorr=inv(dcgain(ss(A-B*K,B,C,D,h)))

run Q6aug.slx