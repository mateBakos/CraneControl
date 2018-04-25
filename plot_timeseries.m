function plot_timeseries(timeseries)
% the Void function Plot_timeseries plots the simulation results in 1 figure. 
% Inputs: Timeseries structure generated by simulink 'To Workspace' Block.
clf(23)
figure(23);
labels = {'Trolley position','Cable length','Input x-velocity','Input y-velocity','Angle'};

    for i = 1:size(timeseries.Data,2)
        subplot(size(timeseries.Data,2),1,i);
        plot(timeseries.Time,timeseries.Data(:,i))
        if i == size(timeseries.Data,2)
           xlabel('Time[s]');
        end
        ylabel(labels(i));
    end
end 