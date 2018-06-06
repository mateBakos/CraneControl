close all;
clear;
set(0,'defaultfigurecolor',[1 1 1])

sys = tf(1,[0.1, 1, 0, 0]); % G(s)
% wc = 2;
% angle = 80;
% alpha = (1-sin(angle*pi/180))/(1+sin(angle*pi/180));
% T = 1/(wc*sqrt(alpha));
controller = tf(0.25*[8 1],[0.05 1]);
D_sys = feedback(controller*sys,1); % closed loop
u = controller/(1+controller*sys); % control action tf
% figure
% rlocus(D_sys);
figure
step(u);
title('Control action for reference tracking');
figure;
step(D_sys);
%xlim([0 0.5])
title('Step response of the controlled plant');
figure;
% bode(sys);
% hold on;
bode(controller*sys);
title('Bode plots');
%legend('Plant','Controlled plant');
% figure;
% nyquist(controller*sys)
% title('Nyquist plot of the controlled plant');
[Gm, Pm, Wgm, Wpm] = margin(controller*sys);
% figure;
% bode(sys);
% title('Bode plots of the plant')
%export_fig bode_plant.pdf