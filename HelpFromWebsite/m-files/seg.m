Fontsize=16;
set(0,'DefaultLineLineWidth',1.5);
set(0,'DefaultAxesFontSize',Fontsize);
n=4;integrator=ss(zeros(n),eye(n),eye(n),zeros(n));
Te=20;t=linspace(0,Te,100*Te)';
%% Linearization 
xe=[0;pi/360;0;0];ue=[0;0];
[dx,A,B]=fseg([xe;ue]);
[ye,C,D]=hseg([xe;ue]);
sy=ss(A,B,C,D);
svd(ctrb(A,B))
%% Choice of desired pole-locations
om1=2;z1=.5;
om2=.5;z2=.7;   
p1=[1 2*om1*z1 om1^2];
p2=[1 2*om2*z2 om2^2];
%g1=tf(om1^2,p1);g2=tf(om2^2,p2);figure(2);step(g1,g2)
% Computation of state-feedback matrix
B1=B(:,1);
%p=conv(conv([1 2],[1 2]),conv([1 1],[1 1]));
p=conv(p1,p2);
Fp=place(A,B1,roots(p));
eig(A-B1*Fp)
Fp
Q=eye(4);Q(1,1)=100;
[Fl,P,E]=lqr(A,B(:,1),Q,.1)
%
figure(1);clf
F=Fp
u=zeros(length(t),1);
T=zeros(length(t),1);
T=T+10*(t<10).*(t>8);
in.time=t;
in.signals.values=[u T];
in.signals.dim=2;
x0=[0;pi/360*0.95;0;0];
sim('lseg')
tl=out.time;
ly=out.signals.values;
subplot(411);plot(tl,ly(:,3),tl,ly(:,4),'r');title('control input and disturbance torque (red)');hold on;grid on;
subplot(412);plot(tl,ly(:,1));title('p');hold on;grid on;
subplot(413);plot(tl,ly(:,2));title('\theta');hold on;grid on;
%%
sim('sseg');
to=out.time;
y=out.signals.values;
subplot(411);plot(to,y(:,3),'b',to,y(:,4),'r');hold on;
subplot(412);plot(to,y(:,1),'b');title('p');hold on;
subplot(413);plot(to,y(:,2),'b');title('\theta');hold on;
F=Fl
sim('sseg');
to=out.time;
y=out.signals.values;
subplot(411);plot(to,y(:,3),'g',to,y(:,4),'r');hold on;
subplot(412);plot(to,y(:,1),'g');title('p');hold on;
subplot(413);plot(to,y(:,2),'g');title('\theta');hold on;
%P epdfdelft('fig1')
%%
Ll=ss(A,B1,Fl,0);
Lp=ss(A,B1,Fp,0);
figure(2);clf
nyquist(Lp,'b',Ll,'g');
%%  
figure(3);clf
C=[1 1 0 0];
G=ss(A,B1,C,zeros(size(C,1),size(B1,2)));
z=zero(G);
p=eig(A);
plot(real(z(1)),imag(z(1)),'g*');hold on;
plot(real(p(3:4)),imag(p(3:4)),'m*');hold on;
for rho=logspace(-6,2,200);
    [Fl,P,E]=lqr(A,B1,C'*C,rho);
    plot(real(E(1:2)),imag(E(1:2)),'r.');
    plot(real(E(3:4)),imag(E(3:4)),'b.');hold on;
end;
plot(real(z(1)),imag(z(1)),'g*');hold on;
plot(real(p(3:4)),imag(p(3:4)),'y*');hold on;
grid on;axis('equal')
%P epdfdelft('fig1bw')
%%
rho=.00000000000001;
C=[1 0 0 0];
R=rho*eye(1);
[F,P,E]=lqr(A,B1,C'*C,R);
G=ss(A,B1,C,zeros(size(C,1),size(B1,2)));
zero(G)
E


