function [dx,y] = GreyBoxDiffModel(t,x,u,M,m,L,k_m,b_x,b_phi,varargin)
g=9.81;

y=[x(1);... %Trolley position
    x(2)];  %Container angle

A = [0,0,1,0;
    0,0,0,1;
    0,m*g/M,-b_x,-m*b_phi;
    0,(-m*g-M*g)/(M*L),-b_x,(-m*b_phi-M*b_phi)/(M*L)];
B = [0;0;1/M;1/(M*L)];
C = [1,0,0,0;
    0,1,0,0];
D = [0;0];

dx=A*x+B*u;
