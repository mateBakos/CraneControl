load('BlackBoxID_meas9_order4')
Plant = ss(Blackbox_model);
[A,B,C,D] = ssdata(Plant);
gainAngle = 0;
gainPos   = 1;
% P = 1;
% I = 0;
% D = 0;

%% Observer-building

rank(obsv(Plant))
rank(ctrb(Plant))

%% Pole placement
t = 0:0.01:2;
u = zeros(size(t));
x0 = [0 1 0 0];

p1 = -10 + 10i;
p2 = -10 - 10i;
p3 = -50;
p4 = -0.01;
K = place(A,B,[p1 p2 p3 p4]);
sys_cl = ss(A-B*K,B,C,0);


lsim(sys_cl,u,t,x0);

xlabel('Time (sec)')
ylabel('Ball Position (m)')

