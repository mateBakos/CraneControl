 %close all 
 clear all
 clc
% Example 1:
    %   Zero-phase filter a noisy ECG waveform using an IIR filter.
    samplingRate = 1e3;
    finalTime= 0.2;
    timeVector = linspace(0,finalTime,finalTime * samplingRate);
    A = 0.1;
    f = 100;
    w = 2*pi*f; % angular frequency 
    x  = A* sin(timeVector*w);
%     plot(timeVector,x)
%     axis([0 timeVector(end) -1 1])
    %% 
    %clf(9)
    figure
    %load noisysignals x;                   % noisy waveform
    [b,a] = butter(20,0.7,'low');           % IIR filter design
    y = filtfilt(b,a,x);                    % zero-phase filtering
    y2 = filter(b,a,x);                     % conventional filtering
    
    axis([0 timeVector(end) -1 1])
    figure
    plot(timeVector,[y ;y2],'LineWidth',2); grid on ; hold on;
    plot(timeVector,x,'k-');
    axis([0 0.2 -0.1 0.1]);
    legend('Zero-phase Filtering','Conventional Filtering','noisy signal');