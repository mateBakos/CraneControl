function [A,B,C,D] = LinCraneSS(M,m,L,k_m,b_x,b_phi,Ts)
g=9.81;

A = [0,0,1,0;
    0,0,0,1;
    0,m*g/M,-b_x,-m*b_phi;
    0,(-m*g-M*g)/(M*L),-b_x,(-m*b_phi-M*b_phi)/(M*L)];
B = [0;0;1/M;1/(M*L)];
C = [1,0,0,0;
    0,1,0,0];
D = [0;0];

% figure
% Crane = ss(A,B,C,D);
