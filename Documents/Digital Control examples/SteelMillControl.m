%close all
clear all 
clc
%%
s=tf('s')
%plant
P=tf({1},{[1,102,2800,5200,0]})

% figure
% subplot 121
% step(P)
% subplot 122
% margin(P)


%Desired Phase Margin of controller
Phi=65; %80 75 65 60;
Cross=10; %10;
%controller
a=(1-sin(Phi*pi/180))/(1+sin(Phi*pi/180))
Td=1/Cross/sqrt(a)
Ap=45400; %31300 40000 45400 29000;

Co=Ap*((1+s*Td)/(1+s*Td*a))

%open loop 
ol=P*Co;
%closed loop
cl=feedback(ol,1)
%input
u=Co/(1+P*Co);

poles=pole(cl)

fig2=figure('units','normalized','outerposition',[0 0 1 1])
subplot 122
%step(cl)
stepChar(cl);title(['Step Response: Phase lead=',num2str(Phi)])
% opt= timeoptions;
% opt.SettleTimeThreshold=0.01
% opt.Grid='on'
% stepplot(cl,opt)

subplot 121
bode(P);hold on
bode(Co);
[Gm,Pm,Wgm,Wpm]=margin(ol);grid on
margin(ol)
legend('Plant','Controller','Open Loop')

fig1=figure('units','normalized','outerposition',[0 0 1 1])
step(u);grid on
title('Control effort')

save('Q1.mat','Co','P','ol','cl','Wgm','Wpm')