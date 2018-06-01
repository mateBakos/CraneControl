function [A,B,C,D] = GreyBoxDiffModel(par,Ts,g)
%[dx,y]
%[A,B,C,D]
%[Ad,Bd,Cd,Dd]
M=par(1);
m=par(2);
L=par(3);
k_m=par(4);
b_x=par(5);
b_phi=par(6);

% y=[x(1);... %Trolley position
%    x(2)];  %Container angle

% A = [0,0,1,0;
%     0,0,0,1;
%     0,m*g/M,-b_x,-m*b_phi;
%     0,(-m*g-M*g)/(M*L),-b_x,(-m*b_phi-M*b_phi)/(M*L)];
% %A=[0,0,1,0;0,0,0,1;0,9.02699525028192,-47.9098273603651,-0.131550909299465;0,-19.9016470579787,-47.9098273603651,-0.316169448072896];
% B = [0;0;1/M;1/(M*L)];
% %B=[0;0;1.09013489274679;1.15174843932232];
% C = [1,0,0,0;
%     0,1,0,0];
% D = [0;0];
% 

A = [0,0,1,0;
    0,0,0,1;
    0,m*g/M,-b_x/M,-L*b_phi/M;
    0,(-m*g-M*g)/(M*L),b_x/M/L,(-m*b_phi-M*b_phi)/(M*m)];
B = [0;0;k_m/M;k_m/(M*L)];
C = [1,0,0,0;
    0,1,0,0];
D = [0;0];


% A = [0,0,1,0;
%     0,0,0,1;
%     par(1),par(2),par(3),par(4);
%     par(5),par(6),par(7),par(8)];
% B = [0;0;par(9);par(10)];
% C = [1,0,0,0;
%     0,1,0,0];
% D = [0;0];

% contsys=ss(A,B,C,D);
% 
% sysd = c2d(contsys,Ts,'tustin');
% Ad=sysd.A;
% Bd=sysd.B;
% Cd=sysd.C;
% Dd=sysd.D;

%dx=Ad*x+Bd*u;
%y=Cd*x+Dd*u;
