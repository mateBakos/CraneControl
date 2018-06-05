function showFit(yactual,yfit)

plotFit(yactual, yfit)

R2_Final = R2(yactual,yfit);

fprintf('\nTest Data R^2: %f\n',R2_Final);

end

function R_Sqr = R2(Y, YHat )
%RSQUARED

SStot = sum((Y - mean(Y)).*(Y - mean(Y)));

% Calculate residuals
resid = Y - YHat;

% Square residuals
resid_sqrd = resid.*resid;

% Take the sum of the squared residuals
SSerr = sum(resid_sqrd);

% Calculate R^2
R_Sqr = 1 - (SSerr/SStot);

end

function  plotFit(y,varargin)
% Plot fit
% Copyright 2017 The MathWorks, Inc.

figure
legendName = cell(length(varargin),1);
hold all

for ii = 1:length(varargin)
    yfit = varargin{ii};
    scatter(yfit, (y- yfit)./yfit,'o','filled')
    rs = R2(y,yfit);
    legendName{ii,1} = sprintf('%s (R^2=%0.3f)', inputname(ii+1), rs);
end

ylim([-1.5 1.5])

hold off

legend(legendName)

refline(0,0)
xlabel('Estimated Fuel Economy (MPG)')
ylabel('Error/Estimated Fuel Economy')

figure;
hold all
axis square

linesymbols = {'+','o','*','x'};

for ii = 1:length(varargin)
    counter = 1 + mod((ii-1),4);
    yfit = varargin{ii};
    plot(y, yfit,linesymbols{counter})
end
hold off

line([0 max(y)] ,[0 max(y)],'Color','k')

xlabel('Actual Fuel Economy (MPG)')
ylabel('Estimated Fuel Economy (MPG)')

legend(legendName)
end