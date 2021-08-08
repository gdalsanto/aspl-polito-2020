% Assignment 1 - Pitch estimation

clear -variables
close all
clc

addpath ./functions 

filename='A2_guitar.wav';
infoRec=audioinfo(filename);
[y,fs]=audioread(filename);
y1=y(:,1)';                 % first channel 

N=length(y1);
t=(0:(N-1))/fs;

%---------------------------Plot

figure
plot(t,y1); grid on
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('Guitar - \textbf{A2} $110Hz$','interpreter','latex')

%---------------------------Spectrum Estimation

NFFT=6000;                  % D - samples in  a segment
n_overlap=NFFT/2;           % 50% overlap
[Sx,f]=pwelch(y1, hamming(NFFT), n_overlap, NFFT, fs, 'centered');
figure; plot(f,10*log10(Sx)); grid on;
axis([-fs/2 fs/2 -inf inf]);
title('\textbf{A2} $S_x -\:D = 6000$, Hamming, $50\%$','interpreter','latex'); 
xlabel('$f/Hz$','interpreter','latex'); 
ylabel('$S_x /dB$','interpreter','latex');

%---------------------------Autocorrelation

n=(-(N-1):(N-1))/fs;
R=xcorr(y1,y1,'coeff');     % nomalized autocorr
figure
plot(n,R); grid on
title('\textbf{A2} - Normalized Autocorrelation','interpreter','latex');
xlabel('$lag/s$','interpreter','latex'); 
ylabel('amplitude','interpreter','latex');


[~,loc]=findpeaks(R((N):end),'NPeaks',1,'MinPeakHeight',0);
F1=fs/(loc-1);             % estimated frequency

%---------------------------Recording
% % Recording of cheese.wav
% infoDev=audiodevinfo; 
% fs2=8e3;                    % sampling frequency  
% T0=5;                       % audio length s
% nBits=16;                   % bits per sample
% nChannel=1;
% ID=-1;                       % default input device
% recObj = audiorecorder(fs2, nBits, nChannel, ID) 
% disp('Start speaking');
% recordblocking(recObj, 5); 
% disp('Stop speaking');
% play(recObj);
% y2=getaudiodata(recObj)';
% audiowrite('cheese.wav',y2,fs2,'BitsPerSample',nBits);

%---------------------------Plot

[y2,fs2]=audioread('cheese.wav');   
y2=y2';
N2=length(y2);
t2=(0:(N2-1))/fs2;

figure
plot(t2,y2); grid on
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{cheese.wav} $f_s=8kHz$, $16$ bits','interpreter','latex');

%---------------------------Spectrum-Estimation

NFFT=2000;                  % D - samples in  a segment
n_overlap=NFFT/2;           % 50% overlap
[Sx2,f]=pwelch(y2, hamming(NFFT), n_overlap, NFFT, fs2, 'centered');
figure
plot(f,10*log10(Sx2)); grid on;
axis([-fs2/2 fs2/2 -inf inf]);
title('\textbf{cheese.wav} $S_x -\:D = 2000$, Hamming, $50\%$','interpreter','latex'); 
xlabel('$f/Hz$','interpreter','latex'); 
ylabel('$S_x /dB$','interpreter','latex');

%---------------------------Resize

t0=floor(0.8599*fs2);
t1=floor(1.681*fs2);
y2_cut=y2(t0:t1);

figure
plot(t2(t0:t1),y2_cut); grid on
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('cut \textbf{cheese.wav} $f_s=8kHz$, $16$ bits','interpreter','latex')

%---------------------------Autocorrelation

N3=length(y2_cut);
n2=(-(N3-1):(N3-1))/fs;
R2=xcorr(y2_cut,y2_cut,'coeff');     % nomalized autocorr
figure
plot(n2,R2); grid on
title('\textbf{cheese.wav} - Normalized Autocorrelation','interpreter','latex');
xlabel('$lag/s$','interpreter','latex'); 
ylabel('amplitude','interpreter','latex');

[~,loc]=findpeaks(R2(N3:end),'NPeaks',1,'MinPeakHeight',0);
F2=fs2/(loc-1);             % estimated pitch







