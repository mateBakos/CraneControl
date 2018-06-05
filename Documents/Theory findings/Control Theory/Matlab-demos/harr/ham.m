Fontsize=16;
set(0,'DefaultLineLineWidth',1.5);
set(0,'DefaultAxesFontSize',Fontsize);

m=4;J=0.0475;r=0.25;g=9.81;c=0.05;
A=[0 0 0 1 0 0;0 0 0 0 1 0;0 0 0 0 0 1;0 0 -g -c/m 0 0;0 0 0 0 -c/m 0;0 0 0 0 0 0]    
B=[0 0;0 0;0 0;1/m 0;0 1/m;r/J 0];
C=[1 0 0 0 0 0;0 1 0 0 0 0;0 0 1 0 0 0;0 0 0 0 0 0;0 0 0 0 0 0];
D=[0 0;0 0;0 0;1 0;0 1];
%%
rho=1;Q=eye(6);R=rho*eye(2);
[F,P,E]=lqr(A,B,Q,R);
%%
[l,u]=lu(ctrb(A,B));
u
[l,u]=lu(ctrb(A',Q));
u
%%
H=[A -B*inv(R)*B';-Q -A'];
[n,n]=size(A);[T,D]=eig(H);Z=[];
for j=1:2*n;
    if real(D(j,j))<0;Z=[Z T(:,j)];end;
end;
T11=Z(1:n,:);T22=Z(n+1:2*n,:);
myP=T22*T11^(-1);
%%
norm(P-myP)
myP=real(myP)

