% Assignment 2 - Spectrogram and filtering

clear -variables
close all
clc

addpath ./functions

filename='A_major_scale.wav';
[y,~]=audioread(filename);
info=audioinfo(filename);
fs=info.SampleRate;         % sampling frequency
N=info.TotalSamples;        % number of samples
[maxy,~] = max(abs(y));
y=y/maxy;                   % normalization

% playObj=audioplayer(y,fs);
% playblocking(playObj);

%---------------------------Plot

t0=3.704;
t1=4.212;

t=(0:(N-1))/fs;
figure
plot(t,y); grid on
xline(t0,'r:'); xline(t1,'r:');
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{A} major scale','interpreter','latex')

%---------------------------Spectrogram

M=10001;                    % length of the Hamming window
n_overlap=8e3;              % number of overlapping samples 
nfft=2^14;                  % FFT dimension
[S,f,t]=spectrogram(y,hamming(10001),n_overlap,nfft,fs,'yaxis'); 
figure; 
imagesc(t, f/1e3, 20*log10(abs(S))); axis xy; ylim([0 5]);
h=colorbar;
xlabel('t/s','interpreter','latex'); 
ylabel('f/kHz','interpreter','latex'); 
ylabel(h,'dB/Hz','interpreter','latex');
title('Spectrogram - \textbf{A} major scale','interpreter','latex');

%---------------------------Autocorrelation

n0=floor(t0*fs);
n1=floor(t1*fs);
N2=n1-n0+1;
n=(-(N2-1):(N2-1))/fs;
R=xcorr(y(n0:n1),y(n0:n1),'coeff');     % nomalized autocorr
figure;
plot(n,R); grid on
title('Normalized Autocorrelation - \textbf{A} major scale','interpreter','latex','FontSize',18);
xlabel('$lag/s$','interpreter','latex','FontSize',18); 
ylabel('amplitude','interpreter','latex','FontSize',18);

% pitch estimation
[~,loc]=findpeaks(R((N2):end),'NPeaks',1,'MinPeakHeight',0);
F=fs/(loc-1);               % estimated frequency

%---------------------------Filtering

fc=5e3/fs;                  % cut-off frequency Hz
Bt=2*5e2/fs;                % transition band Hz

Nw=ceil(6.2/Bt);     
n=(-(Nw-1)/2:(Nw-1)/2);
x=2*fc*sinc(2*fc*(n));
w=hann(Nw);                 % window vector
b=x.*w';
% alternative 
% fc=2*fc;                  % fir1 needs this normalization
% b=fir1(Nw-1,fc,hann(Nw));
y_fil=filter(b,1,y);

%undersampling
y_fil_us=y_fil(1:4:end)';   

figure
[S,f,t]=spectrogram(y_fil_us,hamming(10001),n_overlap,nfft,fs/4,'yaxis'); 
imagesc(t, f/1e3, 20*log10(abs(S))); axis xy; ylim([0 5]);
h=colorbar;
xlabel('t/s','interpreter','latex'); 
ylabel('f/kHz','interpreter','latex'); 
ylabel(h,'dB/Hz','interpreter','latex');
title('Spectrogram - filtered, undersampled $f_s/4$','interpreter','latex');

[maxy,~] = max(abs(y_fil_us));
y_fil_us=y_fil_us/maxy;     % normalization

% playObj=audioplayer(y_fil_us,fs/4);
% playblocking(playObj);

%---------------------------Filtering2

fc=2.5e3/fs;                % cut-off frequency Hz
x=2*fc*sinc(2*fc*(n));
w=hann(Nw);                 % window vector
b2=x.*w';
y_fil2=filter(b2,1,y);

%undersampling
y_fil2_us=y_fil2(1:8:end)'; 

figure
[S,f,t]=spectrogram(y_fil2_us,hamming(10001),n_overlap,nfft,fs/8,'yaxis');
imagesc(t, f/1e3, 20*log10(abs(S))); axis xy; ylim([0 fs/8/2e3]);
h=colorbar;
xlabel('t/s','interpreter','latex'); 
ylabel('f/kHz','interpreter','latex'); 
ylabel(h,'dB/Hz','interpreter','latex');
title('Spectrogram - filtered, undersampled $f_s/8$','interpreter','latex');

[maxy2,~] = max(abs(y_fil2_us));
y_fil2_us=y_fil2_us/maxy2;
% playObj=audioplayer(y_fil2_us,fs/8);
% playblocking(playObj);


