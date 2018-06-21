function sensWeightPlot(transf_vec,label_transf,label_output,start,stop,mode)
% transf_vec: cell vector, 1st element: thick line

clf;
for i=1:length(transf_vec)
    transf = transf_vec{i};

    w = logspace ( start ,stop ,1000)' ;
    Nw = length (w) ;
    [ re , im] = nyquist(-transf ,w) ;
    re = reshape( re ,Nw, 1 ) ;
    im = reshape( im,Nw, 1 ) ;
    mg11 = 20*log10( sqrt ( re.^2+im.^2 ) ) ;

%     clf ;
    if( strcmp(mode,'n'))
    % normal
     semilogx (w,mg11,'linewidth',1 + 1*(i==1) ); grid on, hold on;
    end
    if( strcmp(mode,'p'))
    % perturbed
    bodemag(transf); grid on, hold on;
    end
end
    ylabel('|\cdot|'); legend (strcat('|',label_transf,'|'));
    xlabel(label_output);
    axis([10^start 10^stop -Inf Inf]);