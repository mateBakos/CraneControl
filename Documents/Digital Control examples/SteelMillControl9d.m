%clf(f2)
%close all
%clear all 
clc

%%
s=tf('s')
%plant
P=tf({1},{[1,102,2800,5200,0]})

%controller
Ki=85 %85
Ap=960   %960; %50000 45000


Cod=Ap+Ki/s
Co=Ap+Ki/s

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
subplot 222
step(cld);grid on
%stepChar(cld);title('Step Response')
% opt= timeoptions;
% opt.SettleTimeThreshold=0.01
% opt.Grid='on'
% stepplot(cl,opt)
subplot 121
bode(P);hold on
bode(Cod*P);
[Gm,Pm,Wgmd,Wpmd]=margin(old);grid on
margin(old)
legend('Plant','Controller','Open Loop')

%fig2=figure('units','normalized','outerposition',[0 0 1 1])
subplot 224
step(ud);grid on
title('Control effort')

save('Q9d.mat','Cod','P','old','cld','Wgmd','Wpmd')


%open loop 
ol=P*Cod;
%closed loop
cl=feedback(ol,1)
%input
u=Cod/(1+P*Cod);

poles=pole(cl)

fig2=figure('units','normalized','outerposition',[0 0 1 1])
subplot 222
%step(cl)
stepChar(cl);title(['Step Response: Gain=',num2str(Ap)])
% opt= timeoptions;
% opt.SettleTimeThreshold=0.01
% opt.Grid='on'
% stepplot(cl,opt)

subplot 121
bode(P);hold on
bode(Cod);
[Gm,Pm,Wgm,Wpm]=margin(ol);grid on
margin(ol)
legend('Plant','Controller','Open Loop')

%fig1=figure('units','normalized','outerposition',[0 0 1 1])
subplot 224
step(u);grid on
title('Control effort')

save('Q9.mat','Co','P','ol','cl','Wgm','Wpm')