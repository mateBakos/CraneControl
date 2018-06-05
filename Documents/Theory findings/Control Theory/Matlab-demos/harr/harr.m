Fontsize=16;
set(0,'DefaultLineLineWidth',1.5);
set(0,'DefaultAxesFontSize',Fontsize);
%%
m=4;J=0.0475;r=0.25;g=9.81;c=0.05;
A=[0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1;0 0 -g -c/m 0 0;0 0 0 0 -c/m 0;0 0 0 0 0 0]    
B=[0 0;0 0;0 0;1/m 0;0 1/m;r/J 0];
C=[1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0];
D=[0 0;0 0;0 0;1 0;0 1];
%%
figure(1);clf;nf=2;
Te=7;
rho=1;
Q=eye(6);
R=rho*eye(2);
[F,P,E]=lqr(A,B,Q,R)
cls=ss(A-B*F,B,C-D*F,D);
t=linspace(0,Te,100);
x0=[1;-1;20*2*pi/360;0;0;0];
[y,to]=lsim(cls,[0*t;0*t],t,x0);
subplot(nf,1,1);plot(t,y(:,4:5));grid on;hold on;title('Control')
subplot(nf,1,2);plot(t,y(:,1:3));grid on;hold on;title('First 3 States')
%epdf('fig1')
%%
figure(2);clf
Q=eye(6);
Q(1,1)=10;
Q(2,2)=100;
R=eye(2);
[F,P,E]=lqr(A,B,Q,R);
cls=ss(A-B*F,B,C-D*F,D);
[y,to]=lsim(cls,[0*t;0*t],t,x0);
subplot(nf,1,1);plot(t,y(:,4:5),'.');
subplot(nf,1,2);plot(t,y(:,1:3),'.');
%epdf('fig2')
%%
Te=2
figure(3);clf
t=linspace(0,Te,100);
Q=eye(6);
Q(1,1)=10;
Q(2,2)=100;
R=eye(2);
[F,P,E]=lqr(A,B,Q,R);
F
cls=ss(A-B*F,B,C-D*F,D);
[y,to]=lsim(cls,[0*t;0*t],t,x0);
subplot(nf,1,1);plot(t,y(:,4:5),'.');grid on;hold on;title('Control')
subplot(nf,1,2);plot(t,y(:,1:3),'.');grid on;hold on;title('First 3 States')
%%
Q=eye(6);
Q(1,1)=10;
Q(2,2)=100;
rho=.001;
R=rho*eye(2);
[F,P,E]=lqr(A,B,Q,R);
F
cls=ss(A-B*F,B,C-D*F,D);
t=linspace(0,Te,100);
x0=[1;-1;1;0;0;0];
[y,to]=lsim(cls,[0*t;0*t],t,x0);
subplot(nf,1,1);plot(t,y(:,4:5));grid on;hold on
subplot(nf,1,2);plot(t,y(:,1:3));grid on;hold on
%epdf('fig3')
%%


