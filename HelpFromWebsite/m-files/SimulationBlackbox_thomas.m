load('Blackbox4thorder')
Plant = ss(Blackbox_model);
[A,B,C,D] = ssdata(Plant);
gainAngle = 0;
gainPos   = 1;
P = 1;
I = 0;
D = 0;
