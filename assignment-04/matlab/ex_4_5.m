% Assignment 5 Kaiser FIR filter

close all
clear all
clc

addpath ./functions

As=40;              % min stop-band attenaution dB
Bt=400;             % transition band Hz
fc=800;             % -6dB cut-off frequency Hz
fs=8e3;             % sampling frequency Hz
type='-lp';         % low pass filter 

[h,N,beta]=my_Kaiser_filter(As,Bt,fs,fc,type);
[H1, f1]=freqz(h,1,1024,fs); 

Wn=2*fc/fs;
b=fir1(N-1,Wn,kaiser(N,beta));
[H2, f2]=freqz(b,1,1024,fs);

figure;  hold on;
plot(f1, 20*log10(abs(H1))); 
plot(f2, 20*log10(abs(H2)),'--');
legend('my_Kaiser_function','fir1');
title('Low-pass FIR filter H_{LP}(f), f_c=800Hz')
xlabel('f/Hz'); ylabel('20log_{10}|H_{LP}(f)|');
xline(fc,'r:','HandleVisibility','off'); yline(-6,'r:','HandleVisibility','off');
xline(1000,'b:','HandleVisibility','off'); yline(-40,'b:','HandleVisibility','off');
xline(600,'b:','HandleVisibility','off'); 
xticks([500 600 800 1000 1500 2000 2500 3000 3500 4000])
yticks([-120 -100 -80 -60 -40 -20 -6 0 20])



