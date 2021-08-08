% Assignment 4 - Additive synthesis

clear -variables
close all
clc

addpath ./functions

%% vowel sequence 

% Helmholtz loudness values 
H_ff=1; H_mf=0.7; H_f=0.3; H_p=0.1; H_pp=0.07;
fs=22050;               % sampling frequency Hz
T=2;                    % time duration s
p1=216.22;
ph=0;
f=[1 2 3 4 5 6 8 16]*p1;
aU=[H_ff H_mf H_pp 0 0 0 0 0];
aO=[H_mf H_f H_mf H_p 0 0 0 0];
aA=[H_p H_p H_p H_mf H_mf H_p H_p 0];
aE=[H_mf 0 H_mf 0 0 H_ff 0 0];
aI=[H_mf H_p 0 0 0 H_p 0 H_mf];
[toneU,~]=fnote(aU,f,ph,T,fs);
[toneO,~]=fnote(aO,f,ph,T,fs);
[toneA,~]=fnote(aA,f,ph,T,fs);
[toneE,~]=fnote(aE,f,ph,T,fs);
[toneI,~]=fnote(aI,f,ph,T,fs);

y=[toneA toneE toneI toneO toneU];

% playObj=audioplayer(y,fs);
% playblocking(playObj);
audiowrite('AEIOUsequence.wav',y,fs);

%% Bell sound

fs=44100;               % sampling frequency Hz
F0=440;                 % fundamental frequency Hz
f=[1 2 2.4 3 4.5 5.33 6]*F0; 
T=5;                    % time duration s
A=2;                    % amplitude
a=A*ones(1,length(f));
Ph=2*pi*rand();
ph=Ph*ones(1,length(f));    % phases

[tone,t]=fnote(a,f,ph,T,fs);
Tau=0.9;
y=tone.*exp(-t/Tau);

figure;
plot(t,y);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{bell\_1.wav}','interpreter','latex')

% playObj=audioplayer(y,fs);
% playblocking(playObj);
audiowrite('bell_1.wav',y,fs);








