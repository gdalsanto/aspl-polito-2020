% Kaiser window
% h -> filter coefficents
% N -> number of coefficents
% beta -> stop-band attenuation parameter 
% As <- required stop-band attenuation
% Bt <- transition band in Hz
% fs <- sampling frequency in Hz
% fc <- -3dB cutoff frequency in Hz
% type <- type of the filter 
%           -lp     low-pass
%           -hp     high-pass
%           -bp     band-pass
%           -bs     band-stop

function [h,N,beta] = my_Kaiser_filter(As,Bt,fs,fc,type)

if As>50
    beta=0.1102*(As-8.7);
elseif 20<As
    beta=0.5842*(As-21)^0.4+0.07886*(As-21);
else
    beta=0;
end

Bt=2*pi*Bt/fs;      % normalized transition band 
N=ceil((As-8)/(2.285*Bt));
n=0:(N-1);
x=beta*sqrt(1-((2*n-N+1)/(N-1)).^2);
w=besseli(0,x)./besseli(0,beta);


kdelta=zeros(1,length(n));              % kronecker delta
kdelta(round(N/2))=1;
M=floor(N/2);
if strcmp('-lp',type)
    fc=fc/fs;
    hi=2*fc*sinc(2*fc*(n-M));            % ideal impulse response
    h=w.*hi;
elseif strcmp('-hp',type)
    fc=fc/fs;
    hi=kdelta-2*fc*sinc(2*fc*(n-M));           
    h=w.*hi;
elseif strcmp('-bp',type)
    f1=fc(1)/fs;
    f2=fc(2)/fs;
    hi=(2*f2*sinc(2*f2*(n-M))-2*f1*sinc(2*f1*(n-M)));
    h=w.*hi;
elseif strcmp('-bs',type)
    f1=fc(1)/fs;
    f2=fc(2)/fs;
    hi=kdelta-(2*f2*sinc(2*f2*(n-M))-2*f1*sinc(2*f1*(n-M)));
    h=w.*hi;
else
    disp('Error: invalid entry for ''type'' argument');
    return 
end
end

