% Bartlett periodogram custom function
% x <- signal
% N <- length of signal
% M <- number of segments

function [Sx, f] = my_Bartlett(x,N,M)
    if mod(N,M)~=0
        x=[x zeros(1,M-mod(N,M))];     % zero padding
    end
    N=length(x);    
    D=N/M;                  % segment size

    X=zeros(1,D);
    for i=0:(M-1)
        X=X+abs(my_DFT(x((i*D+1):(i+1)*D),D)).^2/D;
    end
    Sx=X/M;                 % periodogram vector
    f=[-D/2:(D/2-1)]/D;     % normalized frequencies vector
end