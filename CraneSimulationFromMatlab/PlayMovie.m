% This function will replay the movie of the ensemble controlled crane at
% ay desired framerate
% Nathan Vervaeke
% Universiteit Gent
% 2014

figure(3)
cla;
set(gcf,'position',[400 50 640 640]);
axis equal;
hold on;
axis([-0.275 0.275 -0.41 0.05]);
set(gca,'units','pixels','position',[10 10 620 620]);
set(gca,'box','on','xtick',[],'ytick',[]);

%fps = round(1/stepsim); % For realistic speed representation
fps = 24;
repeat = 5;
movie(M,repeat,fps)