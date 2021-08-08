% Assignment 5 - FM synthesis
 
clear -variables
close all
clc

addpath ./functions

%% Allarm sound

T=5;                        % duration s
fs=11025;                   % sampling frequnecy Hz
fc=1760;                    % carrier frequency Hz
fm=4.4;                     % modulationg singal frequency Hz
I0=120;                     % modulation index
A=1;                        % amplitude

t=(0:1/fs:T-1/fs);

y1=A*cos(2*pi*fc*t+I0*sin(2*pi*fm*t));

%---------------------------Spectrogram
M=256;
L=128;
N=512;

[S,f,t]=spectrogram(y1,hamming(M),L,N,fs,'yaxis');

figure;
imagesc(t, f/1e3, 20*log10(abs(S))); axis xy; 
h=colorbar;
xlabel('t/s','interpreter','latex'); 
ylabel('f/kHz','interpreter','latex'); 
ylabel(h,'dB/Hz','interpreter','latex');
title('\textbf{Alarm.wav} Spectrogram','interpreter','latex');

%% Bell sound

T=10;                       % duration s
fs=11025;                   % sampling frequnecy Hz
fc=200;                     % carrier frequency Hz
fm=280;                     % modulationg singal frequency Hz
I0=10;                      % modulation index
A=1;                        % amplitude

t=(0:1/fs:T-1/fs);

Tau=2;
a=exp(-t/Tau);              % envelope

y2=A*a.*cos(2*pi*fc.*t+a*I0.*sin(2*pi*fm*t));

%---------------------------Spectrogram
[S,f,t]=spectrogram(y2,hamming(M),L,N,fs,'yaxis');

figure;
imagesc(t, f/1e3, 20*log10(abs(S))); axis xy; 
h=colorbar;
xlabel('t/s','interpreter','latex'); 
ylabel('f/kHz','interpreter','latex'); 
ylabel(h,'dB/Hz','interpreter','latex');
title('\textbf{bell\_2.wav} Spectrogram','interpreter','latex');


%%
% playObj1=audioplayer(y1,fs);
% playObj2=audioplayer(y2,fs);
% playblocking(playObj1);
% playblocking(playObj2);
audiowrite('Alarm.wav',y1,fs);
audiowrite('bell_2.wav',y2,fs);








