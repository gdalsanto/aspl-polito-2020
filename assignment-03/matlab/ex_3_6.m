% Assignment 5 - Bartlett vs. Welch periodogram

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

%-----------------------LP-Filter

n=-200:200;
h=0.5*sinc(n./2);
y=filter(h,1,x);

%-----------------------Simple-Periodogram
N=length(t)-1;          % number of intervals in X(t) 
NFFT=N;                 % D=N, M=1
n_overlap=0;
[Sx0,f0]=pwelch(y, rectwin(NFFT), n_overlap, NFFT, fs, 'centered');

%-----------------------Bartlett
M=25;                   % number of segments 
NFFT=N/M;               % D - samples in  a segment
n_overlap=0;
[Sx1,f]=pwelch(y, rectwin(NFFT), n_overlap, NFFT, fs, 'centered');

%-----------------------Welch
% {50% overlap, Hamming win}
[Sx2,f]=pwelch(y, hamming(NFFT), NFFT/2, NFFT, fs, 'centered');

figure; subplot(1,3,1); plot(f0,10*log10(Sx0)); 
title('Simple Periodogram'); xlabel('f/Hz'); ylabel('E\{PSD\}/dB');
axis([-inf inf -inf inf]);
subplot(1,3,2); plot(f,10*log10(Sx1)); 
title('E\{PSD\} D=800 Bartlett'); xlabel('f/Hz'); ylabel('E\{PSD\}/dB');
axis([-inf inf -inf -5]);
subplot(1,3,3); plot(f,10*log10(Sx2)); 
title('E\{PSD\} D=800 Welch-Hamming window, 50% overlap'); xlabel('f/Hz'); ylabel('E\{PSD\}/dB');
axis([-inf inf -inf -5]);

sgtitle('Estimated PSD of the filtered signal Y(t)');

%-----------------------Welch
% {50% overlap, Hann win}
[Sx3,f]=pwelch(y, hann(NFFT), NFFT/2, NFFT, fs, 'centered');

%-----------------------Welch
% {50% overlap, Rect win}
[Sx4,f]=pwelch(y, rectwin(NFFT), NFFT/2, NFFT, fs, 'centered');

figure; hold on
plot(f,10*log10(Sx2)); plot(f,10*log10(Sx3)); plot(f,10*log10(Sx4));  
xlabel('f/Hz'); ylabel('E\{PSD\}/dB');
legend('Hamming','Hann','Rectangular');
sgtitle('Welch periodograms of Y(t)');