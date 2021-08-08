% Assignment 3 - Function my_spectrogram

close all
clear -variables
clc

addpath ./functions

filename='A_major_scale.wav';
[y,~]=audioread(filename);
info=audioinfo(filename);
fs=info.SampleRate;             
Nx=info.TotalSamples;
[maxy,~] = max(abs(y));
y=y/maxy;

%---------------------------Spectrogram

M=10001;
L=8e3;
N=16384;
figure
[S,f,t]=spectrogram(y,hamming(10001),L,N,fs,'yaxis');
imagesc(t, f/1e3, 20*log10(abs(S))); axis xy; 
h=colorbar;
xlabel('t/s','interpreter','latex'); 
ylabel('f/kHz','interpreter','latex'); 
ylabel(h,'dB/Hz','interpreter','latex');
title('Matlab Spectrogram','interpreter','latex');

[S,t,f] = my_spectrogram(y,M,L,N,fs,1);
