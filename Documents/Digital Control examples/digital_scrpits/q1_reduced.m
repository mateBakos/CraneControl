close all;
clear;
set(0,'defaultfigurecolor',[1 1 1])

sys = tf(1,[0.1, 1, 0, 0]); % G(s)
controller = (tf(0.06*[30, 1],[0.4 1]))^2; % PDD
D_sys = feedback(controller*sys,1); % closed loop
u = controller/(1+controller*sys); % control action tf
figure
rlocus(D_sys);
figure
step(u);
title('Control action for reference tracking');
figure;
step(D_sys);
xlim([0 80])
title('');
figure;
% bode(sys);
% hold on;
bode(controller*sys);
title('Bode plots');
%legend('Plant','Controlled plant');
figure;
nyquist(controller*sys)
title('Nyquist plot of the controlled plant');
[Gm, Pm, Wgm, Wpm] = margin(controller*sys);
% figure;
% bode(sys);
% title('Bode plots of the plant')
% export_fig bode_plant.pdf