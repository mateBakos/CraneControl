%close all
clear all 
clc

Ts=0.01;
s=tf('s');

load('BlackBoxID_meas16_order6positive_angle')
P = tf(Blackbox_model(2));

% 
% figure
% subplot 121
% impulse(P)
% subplot 122
% margin(P)



%Desired Phase Margin of controller
Phi=70; %80 75 65 60;
Cross=0.005; %10;
%controller
a=(1-sin(Phi*pi/180))/(1+sin(Phi*pi/180));
Td=1/Cross/sqrt(a);
Ap=0.02; %31300 40000 45400 29000;

wnum=3.13;
dampnum=0.02;
wden=3.13;
dampden=20;
% wnum=2.7;

% wden=3.2;
% dampden=0.5;
notch=Ap*(s^2+dampnum*s+wnum^2)/(s^2+dampden*s+wden^2);
PD=Ap%*((1+s*Td)/(1+s*Td*a))
Co=PD/s%notch%*PD

%open loop 
ol=P*Co;
%closed loop
cl=feedback(ol,1);
%input
u=Co/(1+P*Co);

poles=pole(cl)

fig2=figure('units','normalized','outerposition',[0 0 1 1]);
%subplot 122
%step(cl)
%stepChar(cl);title(['Step Response: Phase lead=',num2str(Phi)])
% opt= timeoptions;
% opt.SettleTimeThreshold=0.01
% opt.Grid='on'
% stepplot(cl,opt)

subplot 121
bode(P);hold on
bode(Co);
%bode(PD);
[Gm,Pm,Wgm,Wpm]=margin(ol);grid on
margin(ol)
legend('Plant','Controller','Open Loop')

% fig1=figure('units','normalized','outerposition',[0 0 1 1])
subplot 222
step(1/(1+P*Co));grid on
title('Disturbance rejection')
subplot 224
step(cl);grid on
title('Control effort')

% figure(100)
% myPlot(ol,'System','[rad/sec]')%sensWeightPlot({ol,P,Co},'yes','no',-5,3,'p')