% Assignment 5 - Spectral estimation 

close all
clear all
clc

addpath ./functions

f1=100;                 % Hz
f2=110;
fs=1e3;                 % sampling frequency
T=20;                   % duration of the signal in s
t=0:1/fs:T;             % time vector
var=25;                 % variance of WGN W
W=sqrt(var).*randn(1,length(t));    % zero mean, normal distribution

x=cos(2*pi*f1*t)+cos(2*pi*f2*t)+W;  % signal X(t)

%% PDS-estimation 

%-----------------------Welch-periodogram 
% {0% overlap, Hamming win}
              
NFFT=128;               % D - samples in  a segment
n_overlap=0;
[Sx,f]=pwelch(x, hamming(NFFT), n_overlap, NFFT, fs, 'centered');
subplot(1,3,1); plot(f,10*log10(Sx));
title('E\{PSD\} D = 128, Hamming, 0%'); xlabel('f/Hz'); ylabel('E\{PSD\}/dB');

%-----------------------Simple-periodogram 
N=length(t)-1;          % number of intervals in X(t)  
NFFT=N;                 % D=N, M=1
[Sx,f]=pwelch(x, rectwin(NFFT), n_overlap, NFFT, fs, 'centered');
subplot(1,3,2); plot(f,10*log10(Sx));
title('E\{PSD\} Simple Periodogram');  xlabel('f/Hz'); ylabel('E\{PSD\}/dB');

%-----------------------Adjusted-Welch-periodogram
NFFT=500;               % D - samples in  a segment
M=N/NFFT;
n_overlap=NFFT/4;
[Sx,f]=pwelch(x, hamming(NFFT), n_overlap, NFFT, fs, 'centered');
subplot(1,3,3); plot(f/fs,10*log10(Sx));
title('E\{PSD\} D = 500, Hamming, 25%'); xlabel('f [Hz]'); ylabel('E\{PSD\}/dB]');


%-----------------------Bartlett
M=25;
NFFT=N/M;               % D - samples in  a segment
n_overlap=0;
[Sx1,f]=pwelch(x, rectwin(NFFT), n_overlap, NFFT, fs, 'centered');

%-----------------------Welch
% {50% overlap, Hamming win}
[Sx2,f]=pwelch(x, hamming(NFFT), NFFT/2, NFFT, fs, 'centered');

figure; subplot(1,2,1); plot(f,10*log10(Sx1)); 
title('E\{PSD\} D=800 Bartlett'); xlabel('f/Hz'); ylabel('E\{PSD\}/dB');
axis([-inf inf -20 -5]);
subplot(1,2,2); plot(f,10*log10(Sx2)); 
title('E\{PSD\} D=800 Welch-Hamming window, 50% overlap'); xlabel('f/Hz'); ylabel('E\{PSD\}/dB');
axis([-inf inf -20 -5]);




