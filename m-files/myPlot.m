function myPlot(transf,label_transf,label_output)
% transf: matlab system
% label_transf: string, function name, eg '\phi(-G)'
% label_output: string, eg '\omega [rad/ s]'


w = logspace ( -4 ,4 ,1000)' ;
Nw = length (w) ;
[ re , im] = nyquist(-transf ,w) ;
re = reshape( re ,Nw, 1 ) ;
im = reshape( im,Nw, 1 ) ;
mg11 = 20*log10( sqrt ( re.^2+im.^2 ) ) ;
pg11 = 180*phase( re+1i*im)/ pi ;

figure; clf ;
subplot(2,1,1) ;
semilogx (w,mg11,'linewidth',2 ); grid;
ylabel('|\cdot|'); legend (strcat('|',label_transf,'|'));
subplot(2,1,2);
semilogx(w,pg11,'linewidth',2);grid
legend(strcat('\phi(',label_transf,')')) ; % '\phi(-G_{11})'
xlabel(label_output);ylabel('\phi(\cdot)'); % '\omega [rad/ s]'

end