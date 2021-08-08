% Assignment 1 - Pulse Oximetry 

clear all
close all
clc

addpath ./data

fs=100;             % sampling frequency Hz

%---------------------------Data Aquisition

filename='pulse.txt';
delimiterIn=' ';
headerlinesIn=1;
Data_struct=importdata(filename,delimiterIn,headerlinesIn);
Led_R=Data_struct.data([10*fs:70*fs],1);            % Red Light data
Led_IR=Data_struct.data([10*fs:70*fs],2);           % InfraRed Light data

%---------------------------

N=length(Led_R);
t=[0:N-1]/fs;
figure
subplot(2,1,1); plot(t,Led_R);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{RED}','interpreter','latex');
axis([0 60 2.004e5 2.016e5])
subplot(2,1,2); plot(t,Led_IR);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{INFRARED}','interpreter','latex');
axis([0 60 2.62e5 2.65e5])

%---------------------------Low Pass Filter design

f=[-N/2:N/2-1]*fs/N;
% 5th order Butterworth LP filter - fc = 3Hz
[B,A]=butter(5,3/(fs/2),'low'); 
[H,f]=freqz(B,A,[0:0.1:10],fs);
figure; plot(f,20*log10(abs(H))); grid on;
xline(3,'r:'); yline(-3,'r:','-3dB');
xlabel('f/Hz','interpreter','latex')
ylabel('magnitude/dB','interpreter','latex')
title('Butterworth LP filter','interpreter','latex');

%---------------------------Filtering

Led_R_fil_LP=filtfilt(B,A,Led_R);
Led_IR_fil_LP=filtfilt(B,A,Led_IR);

%---------------------------High Pass Filter design
     
[B,A]=butter(3,0.5/(fs/2),'high');
% 3rd order Butterworth HP filter - fc = 0.5Hz 
[H,f]=freqz(B,A,[0:0.05:3],fs);
figure; plot(f,20*log10(abs(H))); grid on;
xline(0.5,'r:'); yline(-3,'r:','-3dB'); axis([0 3 -40 10]);
xlabel('f/Hz','interpreter','latex')
ylabel('magnitude/dB','interpreter','latex')
title('Butterworth HP filter','interpreter','latex');

%---------------------------Filtering

Led_R_fil_HP=filtfilt(B,A,Led_R_fil_LP);
Led_IR_fil_HP=filtfilt(B,A,Led_IR_fil_LP);

figure
subplot(3,2,1); plot(t,Led_R);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('Original \textbf{RED} signal','interpreter','latex');
axis([0 60 2.004e5 2.016e5])
subplot(3,2,3); plot(t,Led_R_fil_LP);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{RED} signal - LP Filter','interpreter','latex');
axis([0 60 2.004e5 2.016e5])
subplot(3,2,5); plot(t,Led_R_fil_HP);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{RED} signal - HP Filter','interpreter','latex');
axis([0 60 -300 300])
subplot(3,2,2); plot(t,Led_IR);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('Original \textbf{INFRARED} signal','interpreter','latex');
subplot(3,2,4); plot(t,Led_IR_fil_LP);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{INFRARED} signal - LP Filter','interpreter','latex');
axis([0 60 2.62e5 2.65e5])
subplot(3,2,6); plot(t,Led_IR_fil_HP);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{INFRARED} signal - HP Filter','interpreter','latex');
axis([0 60 -800 800])

%---------------------------Pulse Rate computation

[pks_M_R,locs_M_R] = findpeaks(Led_R_fil_HP);

avrg_t=0;
M_R=length(locs_M_R);
for m=1:(M_R-1)   
    avrg_t=avrg_t+locs_M_R(m+1)-locs_M_R(m);   
end
avrg_t=(avrg_t/(M_R-1))/fs;
bpm=60/avrg_t;

figure;
findpeaks(Led_R_fil_HP,t);
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title(['filtered \textbf{RED} signal - BPM=' num2str(bpm)],'interpreter','latex');
axis([0 60 -300 300])

%---------------------------Interpolation

% Red
[pks_m_R,locs_m_R] = findpeaks(-Led_R_fil_HP);
[pks_DC_R,locs_DC_R] = findpeaks(-Led_R_fil_LP);

% InfraRed
[pks_M_IR,locs_M_IR] = findpeaks(Led_IR_fil_HP);
[pks_m_IR,locs_m_IR] = findpeaks(-Led_IR_fil_HP);
[pks_DC_IR,locs_DC_IR] = findpeaks(-Led_IR_fil_LP);

% Red
v_min_interpol_R = interp1( locs_m_R,pks_m_R,[0:(N-1)],'spline');
v_max_interpol_R = interp1( locs_M_R,pks_M_R,[0:(N-1)],'spline');
v_DC_R = interp1( locs_DC_R,pks_DC_R,[0:fs:(N-1)] ,'spline');

v_min_samp_R=resample(v_min_interpol_R,1,fs);
v_max_samp_R=resample(v_max_interpol_R,1,fs);
v_DC_samp_R=resample(v_max_interpol_R,1,fs);
v_AC_R=v_max_samp_R+v_min_samp_R;

% InfraRed
v_min_interpol_IR = interp1( locs_m_R,pks_m_IR,[0:(N-1)],'spline');
v_max_interpol_IR = interp1( locs_M_R,pks_M_IR,[0:(N-1)],'spline');
v_DC_IR = interp1( locs_DC_IR,pks_DC_IR,[0:fs:(N-1)] ,'spline');

v_min_samp_IR=resample(v_min_interpol_IR,1,fs);
v_max_samp_IR=resample(v_max_interpol_IR,1,fs);
v_DC_samp_IR=resample(v_max_interpol_IR,1,fs);
v_AC_IR=v_max_samp_IR+v_min_samp_IR;

%---------------------------Saturation

R=zeros(1,59);
for i=2:60
    R(i)=(v_AC_R(i)/v_DC_R(i))/(v_AC_IR(i)/v_DC_IR(i));
end
meanR=sum(R(:))/59;
Sat=110-25*meanR;

%---------------------------Plots

figure
subplot(2,1,1); hold on;
plot(t,Led_R_fil_HP);  plot(t,-v_min_interpol_R,'r'); plot(t,v_max_interpol_R,'r');
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{RED} signal','interpreter','latex');
axis([0 60 -300 300])
subplot(2,1,2);
plot(t,Led_IR_fil_HP); hold on; plot(t,-v_min_interpol_IR,'r'); plot(t,v_max_interpol_IR,'r');
xlabel('t/s','interpreter','latex');
ylabel('amplitude','interpreter','latex');
title('\textbf{INFRARED} signal','interpreter','latex');
axis([0 60 -800 800])

sgtitle(['$SaO_2=$' num2str(Sat) '\%'],'interpreter','latex')


