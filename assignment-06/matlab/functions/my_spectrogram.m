%% my_spectrogram
% [S,t,f] = my_spectrogram(x,M,L,N,fs,plot_flag)
% --- OUT
% S             -> spectrogram of x 
% t             -> vector of time snapshots
% f             -> vector of frequencies 
% --- IN
% x             <- input signal
% fs            <- sample rate 
% plot_flag==1  <- the function produces a plot
% M,L,N         <- short-time Fourier transform parameters
%                   M - window length
%                   L - number of overlapping samples 
%                   N - number of FFT points


function [S,t,f] = my_spectrogram(x,M,L,N,fs,plot_flag)
    if mod(M,2)==0
        M=M+1;
    end
    W=hamming(M);
    R=M-L;                  % hop size
    Nx=length(x);
    T=floor((Nx-L)/R);      % number of time snapshots
   
    S=zeros(N/2,T);         % spectrogram matrix
    idx=(0:R:R*(T-1));      % frames starting instants
    t=(idx+(M+1)/2)/fs;
    
    for m=1:(T-1)
        xm=x((idx(m)+1):(idx(m)+M)).*W;
        xm=[zeros(1,(N-M+1)/2) xm' zeros(1,(N-M-1)/2)];
        Xm=fft(xm);
        S(:,m)=Xm(1:N/2)';  
    end
    
    if plot_flag==1
        figure;
        f=(0:(N/2-1))*fs/N;
        imagesc(t, f/1e3, 20*log10(abs(S))); axis xy; h=colorbar;
        xlabel('t/s','interpreter','latex'); 
        ylabel('f/kHz','interpreter','latex'); 
        ylabel(h,'dB/Hz','interpreter','latex');
        title('my\_Spectrogram','interpreter','latex');
    end
end

