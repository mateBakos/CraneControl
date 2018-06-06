close all;
clear;
set(0,'defaultfigurecolor',[1 1 1])

% initial conditions
%x0_plant = [10 -2 -3]; % for the plant
x0_plant = [-15 7 2]; % for the plant
x0_obs = [0 0 0]; % for observer
%% Q5
sys = tf(1,[0.1, 1, 0, 0]);
[A5c, B5c, C5c, D5c] = ssdata(sys);

% fastest_pole = -1000;
%P = [fastest_pole -8 -5];

ts = 0.08; % desired settling-time
% tr = 0.006 % desired rise time
dmp = 0.716; % damping calculated from the overshoot (2nd order sys)
wn = 3/(dmp*ts);
% wn = (1+1.1*dmp+1.4*dmp^2)/tr;
fastest_pole = -10*wn;
w = 2*abs(fastest_pole);

% calculation of two dominant poles
eqt = [1 2*dmp*wn wn^2];
r = roots(eqt);
P = [fastest_pole r']; % all poles in cont time

% sampling times
%h5 = 0.2/wn;
h5 = 2*pi/w;
opt_sys = c2dOptions('Method', 'zoh');
% discretization with new sampling time
sysd5 = c2d(ss(sys), h5, opt_sys);
[A5d, B5d, C5d, D5d] = ssdata(sysd5);
P_discr = exp(h5*P); % discrete locations of poles
K5_discr = place(A5d, B5d, P_discr); % K gain for the control law

% calculating steady-state
C5cl = C5d - D5d*K5_discr;
A5cl = A5d - B5d*K5_discr;
DCgain5 = D5d + C5cl*inv(eye(3)-A5cl)*B5d;

%% Q6
% observer poles and gain
P_obs = 1.1*[fastest_pole r']
P_discr6 = exp(h5*P_obs);
L = place(A5d', C5d', P_discr6);

% augumenting the plant
phi_w = 1;
phi_xw = B5d;
A6 = [A5d phi_xw; zeros(1,3) phi_w];
B6 = [B5d; 0];
C6 = [C5d 0];
D6 = D5d;

%augumented K for control law
K6_discr = [K5_discr 1]; 

% augumented observer gain
P6 = [fastest_pole fastest_pole-1 r'];
P6_obs = 1.1*P6;
P6_obsd = exp(h5*P6_obs);
L6 = place(A6', C6', P6_obsd);

% augumented steady-state
C6cl = C6 - D6*K6_discr;
A6cl = A6 - B6*K6_discr;
DCgain6 = D6 + C6cl*pinv(eye(4)-A6cl)*B6;

% augumented initial conditions
x0_plant6 = [x0_plant 0];
x0_obs6 = [x0_obs 0];

%% Q7
h7 = 0.006;
sysd7 = c2d(ss(sys), h7, opt_sys);
[A7d, B7d, C7d, D7d] = ssdata(sysd7);
ro = 10000000;
Q = ro*C7d'*C7d;
% Q = [1000 0 0;
%     0 1000 0;
%     0 0 100000];
R = 0.01;
[K7, S7, E7] = dlqr(A7d, B7d, Q, R);

% steady-state
C7cl = C7d - D7d*K7;
A7cl = A7d - B7d*K7;
DCgain7 = D7d + C7cl*inv(eye(3)-A7cl)*B7d