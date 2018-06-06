close all
clear all 
clc

load 'Q1.mat'
load 'Q2.mat'
%%
s=tf('s')

method='tustin';

[y,t]=step(cl);
stepRes=stepinfo(y,t,'SettlingTimeThreshold',0.01);
%h=2*pi/Wpm/10
h=stepRes.RiseTime/10

[yd,td]=step(feedback(Cod*P,1));
stepResd=stepinfo(yd,td,'SettlingTimeThreshold',0.01);
%hd=2*pi/Wpmd/10
hd=stepResd.RiseTime/10

%plant
[Num,Den]=tfdata(P,'v');
[A,B,C,D]=tf2ss(Num,Den)
DiscPlant=c2d(ss(P),h,method);
DiscCont=c2d(ss(Co),h,method);
DiscCl=feedback(DiscCont*DiscPlant,1);

[Adi,Bdi,Cdi,Ddi]=ssdata(DiscPlant)

%%Q2 Disturbance rejection

DiscPlant=c2d(ss(P),hd,method); 
DiscContd=c2d(ss(Cod),hd,method);
DiscCld=DiscPlant/(DiscContd*DiscPlant+1);
DiscContAct=1/(1+DiscPlant*DiscContd);

%%Q1 Controller step input
fig1=figure('units','normalized','outerposition',[0 0 1 1])
subplot 121
step(cl)
hold on
step(DiscCl)
title('Discretized step response')

subplot 122
step(cld)
hold on
step(DiscCld)
title('Discretized disturbance rejection')




%control effort
fig2=figure('units','normalized','outerposition',[0 0 1 1])

subplot 121
step(Co)
hold on
step(DiscCont)
title('Discretized step response control effort')

subplot 122
step(1/(1+P*Cod))
hold on
step(DiscContAct)
title('Discretized disturbance rejection control effort')


save('Q3.mat','h','hd','DiscCl','DiscCont','DiscPlant','DiscContAct','DiscContd')




