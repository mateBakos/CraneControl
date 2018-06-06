%clf(f2)
%close all
%clear all 
clc

%%
s=tf('s')
%plant
P=tf({1},{[1,102,2800,5200,0]})

%controller
wd=3; %3 2
w=100; %100
wi=3; %3 2
Ap=50000; %50000 45000


Cod=Ap*((1+s/wi)*(1+s/wd)/(s/wi)/(1+s/w))

% %Desired Phase Margin of controller
% Phi=65; %80 75 65 60;
% Cross=10; %10;
% %controller
% a=(1-sin(Phi*pi/180))/(1+sin(Phi*pi/180))
% Td=1/Cross/sqrt(a)
% Ap=45400; %31300 40000 45400 29000;
% 
% Cod=Ap*((1+s*Td)/(1+s*Td*a))

%open loop 
old=P*Cod
%closed loop
cld=P/(1+P*Cod)
ud=1/(1+P*Cod);


poles=pole(cld)

fig1=figure('units','normalized','outerposition',[0 0 1 1])
subplot 122
step(cld);grid on
%stepChar(cld);title('Step Response')
% opt= timeoptions;
% opt.SettleTimeThreshold=0.01
% opt.Grid='on'
% stepplot(cl,opt)
subplot 121
bode(P);hold on
bode(Cod);
[Gm,Pm,Wgmd,Wpmd]=margin(old);grid on
margin(old)
legend('Plant','Controller','Open Loop')

fig2=figure('units','normalized','outerposition',[0 0 1 1])
step(ud);grid on
title('Control effort')

save('Q2.mat','Cod','P','old','cld','Wgmd','Wpmd')