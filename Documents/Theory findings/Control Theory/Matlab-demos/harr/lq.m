Fontsize=16;
set(0,'DefaultLineLineWidth',1.5);
set(0,'DefaultAxesFontSize',Fontsize);
m=4;J=0.0475;r=0.25;g=9.81;c=0.05;
A=[0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1;0 0 -g -c/m 0 0;0 0 0 0 -c/m 0;0 0 0 0 0 0]    
B=[0 0;0 0;0 0;1/m 0;0 1/m;r/J 0];
C=[1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0];
D=[0 0;0 0;0 0;1 0;0 1];
%%
% F=place(A,B,[-1 -1.5 -2 -2.5 -3 -3.5]/2);
% cls=ss(A-B*F,B,C-D*F,D);
% t=linspace(0,10,100);
% x0=[1;-1;1;0;0;0];
% [y,to]=lsim(cls,[0*t;0*t],t,x0);
% subplot(211);plot(t,y(:,4:5));grid;hold on
% subplot(212);plot(t,y(:,1:3));grid;hold on
%%
rho=1;Q=eye(6);R=rho*eye(2);
[F,P,E]=lqr(A,B,Q,R);
