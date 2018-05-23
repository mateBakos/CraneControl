clear all
close all
clc
load(fullfile('Simulation_results','Signal_gbn_7.mat'))

%initial parameters
g=9.81 %gravity in m/s^2
M=0.95; %trolley mass kg
m=1.3; %container mass
L=1; %cable length in meters @ the initial position
km=-10; %motor gain in Nm
b1=10; %motor/trolley damping in kg/s
b2=0.75; %cable hinge damping in kg/s

%Sampling time
h=0.01;
T=30;

s=tf('s')

tf=[(L*s^2+g)/(M*L*s^4+(m+M)*g*s^2);...
    -s^2/(M*L*s^4+(m+M)*g*s^2)]

figure()
impulse(tf)


figure()
[u,t]=gensig('square',1,T,h)
u=[zeros(100,1);ones(100,1);zeros(2801,1)]
lsim(tf,u,t)


