function [dx,A,B]=f(x);
%x=[p;theta;dp;dtheta;u;T];
g=9.81;
%segway
M=10;m=80;l=1;c=.1;ga=0.01;J=100;
%model
u=x(5);
T=x(6);
Ui=inv([M+m -m*l*cos(x(2));-m*l*cos(x(2)) J+m*l^2]);
v=[c*x(3)+m*l*sin(x(2))*x(4)^2;ga*x(4)-m*g*l*sin(x(2))];
w=Ui*([u;T]-v);
dx=[x(3);x(4);w];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Jacobians
d2U=[0 m*l*sin(x(2));m*l*sin(x(2)) 0];
d2v=[m*l*cos(x(2))*x(4)^2;-m*g*l*cos(x(2))];
d3v=[c;0];
d4v=[2*m*l*sin(x(2))*x(4);ga];

d1w=[0;0];
d2w=Ui*d2U*Ui*(v-[u;T])-Ui*d2v;
d3w=-Ui*d3v;
d4w=-Ui*d4v;

A=[0 0 1 0;0 0 0 1;[d1w d2w d3w d4w]];
B=[0 0;0 0;Ui];




