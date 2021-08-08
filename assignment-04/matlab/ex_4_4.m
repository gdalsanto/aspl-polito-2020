% Assignment 4 - FIR filter design

close all
clear all
clc

addpath ./functions

wp=0.2*pi;              % pass-band edge
ws=0.3*pi;              % stop-band edge
Rp=0.2;                 % max pass-band ripple dB
As=40;                  % min stop-band attenuation dB

fc=((wp+ws)/2)/(2*pi);  % cut-off frequency

%-----------------------Hann

N=(6.2*pi)/(ws-wp);     
n=[-(N-1)/2:(N-1)/2];
x=2*fc*sinc(2*fc*n);
w=hann(N);              % window vector
h=x.*w';

figure
impz(h)
figure
freqz(h,1,1024,1)
