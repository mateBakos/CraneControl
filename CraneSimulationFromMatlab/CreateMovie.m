% This function will create a movie of the ensemble controlled crane
% Nathan Vervaeke
% Universiteit Gent
% 2014

% Open figure
figure(2);
cla;
set(gcf,'position',[400 50 640 640]);
axis equal;
hold on;
axis([-0.275 0.275 -0.41 0.05]);
set(gca,'units','pixels','position',[10 10 620 620]);
set(gca,'box','on','xtick',[],'ytick',[]);

% Create cart
boxX = [-0.04 -0.04 0.04 0.04 -0.04];
boxY = [0 0.015 0.015 0 0];
wheelLX = x_start-0.025;
wheelRX = x_start+0.025;
wheelY = -0.0042;

% Initialize position vectors
rod = zeros(1,length(eps));
massX = zeros(1,length(eps));
massY = zeros(1,length(eps));

% Create the ensemble of pendulums
for i=1:length(eps)
    rod(i) = 1/eps(i);
    massX(i) = x_start+sin(theta_start)*rod(i);
    massY(i) = 0-cos(theta_start)*rod(i);
    mass(i) = plot(massX(i),massY(i),'.r','linewidth',2);
    barX(i,:) = [x_start massX(i)];
    barY(i,:) = [0 massY(i)];
    bar(i) = line(barX(i,:),barY(i,:));
    hold on
    set(mass(i),'XDataSource','massX','YDataSource','massY');    
end

% Draw cart
cart = area(boxX,boxY,'facecolor',[.5 .2 .1]);
wheelL = plot(wheelLX,wheelY,'ok','linewidth',1);
wheelR = plot(wheelRX,wheelY,'ok','linewidth',1);

set(cart,'XDataSource','boxX','YDataSource','boxY');
set(wheelL,'XDataSource','wheelLX','YDataSource','wheelY');
set(wheelR,'XDataSource','wheelRX','YDataSource','wheelY');

pendulum = plot(0,0,'r.');
line([-0.21 0.21],[-0.0084 -0.0084])

f=1;
fill = 0;

% If a two-phase ensemble control is used, a small pause will be created in
% the movie
for p=1:phases
    
    if p==phases
        fill=1;
    end
    
    for q=(p-1)*(length(t)-1)/phases+1:(p-1)*(length(t)-1)/phases+(length(t)-1)/phases+fill
        
        boxX=[X(1,q)-0.04 X(1,q)-0.04 X(1,q)+0.04 X(1,q)+0.04 X(1,q)-0.04];
        wheelLX = X(1,q)-0.025;
        wheelRX = X(1,q)+0.025;

        refreshdata(cart,'caller')
        refreshdata(wheelL,'caller')
        refreshdata(wheelR,'caller')
    
        for i=1:length(eps)
            massX(i) = X(1,q)+sin(THETA(i,q))*rod(i);
            massY(i) = 0-cos(THETA(i,q))*rod(i);   
            barX(i,:) = [X(1,q) massX(i)];
            barY(i,:) = [0 massY(i)];
            set(bar(i),'XData',barX(i,:),'YData',barY(i,:));
        end
        refreshdata(mass,'caller')
        refreshdata(bar,'caller')
    
        drawnow;
        M(f) = getframe(gcf);
        f=f+1;
    end
    
    %Create pause at end of each phase
    time = 1; %1 second
    
    for r=1:round(time/stepsim)
        M(f) = getframe(gcf);
        f=f+1;
    end
end

% Save movie
% movie2avi(M,'EnsembleControlCraneMovie1.avi','compression','Cinepak','fps',24);