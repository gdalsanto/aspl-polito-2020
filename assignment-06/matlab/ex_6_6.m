% Assignment 6 - Subtractive synthesis 

clear -variables
close all
clc

addpath ./functions

fs=44100;                   % sampling frequnecy Hz
T=1.25;                     % duration of each chord s

%---------------------------envelope  

[y1,t]=chord_gen(fs,T,'D',5,0);

t_env=[0 0.2 0.4 0.75 1.25];
a_env=[0 1 0.7 0.7 0];
env=interp1(t_env,a_env,t,'pchip');

figure
plot(t,env); grid on
xlabel('amplitude','interpreter','latex');
ylabel('t/s','interpreter','latex');
title('Envelope function','interpreter','latex');

%---------------------------progression

y1=y1.*env;
y=[y1 ...
    chord_gen(fs,T,'A',4,0).*env ...
    chord_gen(fs,T,'B',4,1).*env ...
    chord_gen(fs,T,'F#',4,1).*env ...
    chord_gen(fs,T,'G',4,0).*env ...
    chord_gen(fs,T,'D',5,0).*env ...
    chord_gen(fs,T,'G',4,0).*env ...
    chord_gen(fs,T,'A',4,0).*env];

playObj=audioplayer(y,fs);
playblocking(playObj);
audiowrite('canonD.wav',y,fs);

%% -------------------------Chord generation


% note generation
function [y,t]=note_gen(f0,fs,T)

    t=(0:1/fs:T-1/fs);
    x=sawtooth(2*pi*f0*t);
    lfo=f0/240;
    s=sin(2*pi*lfo*t);
    y=double(x<s);          % PWM signal 
    % filtering 
    h=filter_imp(f0,fs);  
    y=filter(h,1,y);
end

% normalized filter impulse response
function h=filter_imp(f0,fs)
    f0=f0/fs;        % frequency normalization
    Bt=15*f0;            % transition band
    wp=f0;               % bandpass frequency edge Hz
    ws=16*f0;            % bandstop frequeucy edge Hz
    fc=(wp+ws)/2;        % cutoff frequency Hz
    M=ceil(6.1/Bt);    
    n=(-(M-1)/2:(M-1)/2);
    x=2*fc*sinc(2*fc*(n));
    w=bartlett(M);                 % window vector
    h=x.*w';
    h=h/sum(h);
end

% chord generation
function [y,t]=chord_gen(fs,T,note,oct,min)
    fA4=440;
    st=2^(1/12);            % semitone interval
    C={'A',1;'B',st^2;'C',st^(-9);'D',st^(-7);...
        'E',st^(-5);'F',st^(-4);'G',st^(-2);'#',st;'b',st^-1};
    I=find(contains(C(:,1),note(1)));
    f1=fA4*cell2mat(C(I,2));
    
    if length(note)>=2
        I=find(contains(C(:,1),note(2)));
        f1=f1*cell2mat(C(I,2));
    end
    
    % octave 3-5
    if oct==3
        f1=f1/st^12;
    elseif oct==5
        f1=f1*st^12;
    else
    end
   
    if min==0
        y=note_gen(f1,fs,T)+note_gen(f1*2^(4/12),fs,T)+...
            note_gen(f1*2^(7/12),fs,T);
    else
        y=note_gen(f1,fs,T)+note_gen(f1*2^(3/12),fs,T)+...
            note_gen(f1*2^(7/12),fs,T);
    end
    [maxy,~] = max(abs(y));
    y=y/maxy;
    t=(0:1/fs:T-1/fs);
end
