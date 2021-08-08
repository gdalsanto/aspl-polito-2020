%% fnote function
% note generation by additive synthesis given amplitude, frequency and
% phase of the partials 
% --- OUT
% tone      -> normalized complex tone 
% t         -> time vector
% --- IN
% a         <- vector of amplitudes of each partial
% f         <- vector of frequencies
% p         <- vector of phases
% T         <- tone duration s
% fs        <- sampling frequency Hz

function [tone,t]=fnote(a,f,p,T,fs)
    if length(a)~=length(f)
        msg = 'Error occurred. The size of the first two arguments must coincide';
        error(msg)
    end
    N=length(a);
    if length(p)<N
        p=[p zeros(1,N-length(p))];
    end
    t=(0:1/fs:T-1/fs);
    tone=zeros(1,length(t));
    for i=1:N
        tone=tone+a(i)*sin(2*pi*f(i).*t+p(i));
    end
    [maxt,~] = max(abs(tone));
    tone=tone/maxt;
end
