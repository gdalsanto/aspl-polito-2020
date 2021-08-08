% Assignment 2 - MVDR Capon BF

close all
clear -variables
clc
%%
r2d=180/pi;                         % rad to deg conversion coefficent
d2r=pi/180;                         % deg to rad conversion coefficent
color1=[47 79 79]/255;
color2=[32 178 170]/255;
%-----------------------
N=8;                                % number of antennas ULA
fc=900e6;                           % carrier frequnecy Hz
c=3e8;                              % speed of light m/s
lambda=c/fc;                        % wavelength m
d=lambda/2;                         % distance between antennas - sampling theorem
theta1=0*d2r;                       % UE1 DoA deg
DoA=[20 -40 60 -75 80]*d2r;         % interferers DoA
% DoA(1)=10*d2r; 
% DoA(1)=5*d2r; 
%-----------------------
A=zeros(N,6);                       % matrix of interf steering vectors
A(:,1)=exp(1j*pi*sin(theta1)*(0:(N-1))');       % UE
for i=1:5
    A(:,i+1)=exp(1j*pi*sin(DoA(i))*(0:(N-1))'); % interferers
end

S=3601;
theta=linspace(-pi/2,pi/2,S);  
V=zeros(N,S);                       % array pattern
for i=1:S 
    V(:,i)=exp(1j*pi*sin(theta(i))*(0:(N-1))');
end
%----------------------- Beamformer     
sigman2=1e-5;                           % noise variance
Ry=A*A'+sigman2*eye(N);                 % spatial covariance matrix
w_mvdr=Ry\A(:,1)/(A(:,1)'*(Ry\A(:,1))); % beamformer
pattern=w_mvdr'*V;                      % array factor

%% ----------------------- polar plot
figure(1)
polarplot(theta, abs(pattern),'Color',color1,'LineWidth', 1.5);
hold on
polarplot([DoA; DoA],[0 0 0 0 0;1 1 1 1 1]*max(abs(pattern)),...
    'Color',color2,'LineStyle','--','LineWidth', 1)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';
ax.ThetaLim = [-90 90];
title(['MVDR beamforming with $N=\:$',num2str(N),', $DoA\:\theta_1=\:$', num2str(theta1*r2d),...
    '$^o$',', closest interferer = ',num2str(DoA(1)*r2d),'$^o$'], 'interpreter','latex','FontSize',14);
legend({'Array Factor','Interferers DoAs'},'Location','northeast','interpreter','latex','FontSize',12)
legend('boxoff')

%% ----------------------- 31 interferers
M=31;
DoA=linspace(-pi/2,pi/2,M);         % Interferers DoA
theta1=d2r*0;                       % UE 
%-----------------------
A=zeros(N,M);                       % matrix of interf steering vectors
A(:,1)=exp(1j*pi*sin(theta1)*(0:(N(1)-1))');
for i=1:(M-1)
    A(:,i+1)=exp(1j*pi*sin(DoA(i))*(0:(N(1)-1))');
end
%----------------------- patterns
Ry=A*A'+sigman2*eye(N);
w_mvdr=(Ry\A(:,1))/(A(:,1)'*(Ry\A(:,1)));
pattern2=w_mvdr'*V;                 % Capon BF
w=exp(1j*pi*sin(theta1)*(0:(N-1))')/sqrt(N);
pattern3=w'*V;                      % Conventional BF

%% ----------------------- polar plot
% location of nulls
n=[(-4:-1) (1:4)];
theta_null=asin(sin(theta1)+(lambda/d)*(n/N));

figure(2)
polarplot(theta, abs(sqrt(N)*pattern2),'Color',color2,'LineWidth', 1.5); hold on
polarplot(theta, abs(pattern3),'Color',color1,'LineStyle','--','LineWidth', 1.5);
polarplot([theta_null; theta_null],[zeros(1,length(n));ones(1,length(n))]*max(abs(pattern3)),...
    'Color',color1,'LineWidth', 0.5)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';
ax.ThetaLim = [-90 90];
legend({'Capon BF','Conventional BF','$\theta^{NULL}$'},'Location','northeast','interpreter','latex','FontSize',12)
legend('boxoff')
title(['Beamforming comparison with $N=\:$',num2str(N),', $DoA\:\theta_1=\:$', num2str(theta1*r2d),...
    '$^o$'], 'interpreter','latex','FontSize',14);




