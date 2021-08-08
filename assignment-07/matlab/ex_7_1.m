% Assignment 1 - Conventional Beamforming 

close all
clear -variables
clc
%%
r2d=180/pi;                 % rad to deg conversion coefficent 
d2r=pi/180;                 % deg to rad conversion coefficent

color1=[47 79 79]/255;
color2=[32 178 170]/255;
%-----------------------
N=[8 randi([2,50],1,4)];            % number of antennas ULA
fc=900e6;                           % carrier frequnecy Hz
c=3e8;                              % speed of light m/s
lambda=c/fc;                        % wavelength m
d=lambda/2;                         % distance between antennas - sampling theorem
theta1=d2r*0;                       % direction of arrival deg
%-----------------------
S=3601;
theta=linspace(-pi/2,pi/2,S);  
V=zeros(N(1),S);                    % array space
for i=1:S 
    V(:,i)=exp(1j*pi*sin(theta(i))*(0:(N(1)-1))');
end

%----------------------- Beamformer 
w=exp(1j*pi*sin(theta1)*(0:(N(1)-1))')/sqrt(N(1)); 
psi=2*pi*d/lambda*(sin(theta)-sin(theta1));
pattern=w'*V;                       % array factor

%----------------------- Plots
% cartesian plots
figure(1)
plot(theta*r2d,abs(pattern),'Color',color1,'LineWidth', 1.5); 
grid on; hold on 
plot(theta*r2d,abs(diric(psi,N(1))*sqrt(N(1))),'Color',color2,'LineStyle','--','LineWidth', 1.5);
axis([-90 90 0 inf])
title(['Conventional beamforming with $N=\:$',num2str(N(1)),', $DoA\:\theta_1 =\:$', num2str(theta1), '$^o$'],...
    'interpreter','latex','FontSize',14);
xlabel('$\theta/deg$','interpreter','latex','FontSize',12);
ylabel('directivity','interpreter','latex','FontSize',12);
legend({'$w^HV$','diric'},'Location','northeast','interpreter','latex','FontSize',12)
legend('boxoff')

% polar plot
figure(2)
polarplot(theta, abs(pattern),'Color',color1,'LineWidth', 1.5);
hold on
polarplot(theta, abs(diric(psi,N(1))*sqrt(N(1))),'Color',color2,'LineStyle','--','LineWidth', 1.5);
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';
ax.ThetaLim = [-90 90];
title(['Conventional beamforming with $N=\:$',num2str(N(1)),', $DoA\:\theta_1=\:$', num2str(theta1), '$^o$'],...
    'interpreter','latex','FontSize',14);
legend({'$w^HV$','diric'},'Location','northeast','interpreter','latex','FontSize',12)
legend('boxoff')

%% ----------------------- different N
figure(3)
maxAF=zeros(1,4);
for i=1:4
    subplot(2,2,i); 
    pattern=diric(psi,N(i+1))*sqrt(N(i+1));
    maxAF(i)=max(abs(pattern));
    plot(theta*r2d,abs(pattern),'Color',color1,'LineWidth', 1.5); 
    grid on; axis([-90 90 0 inf])
    title(['$N=\:$',num2str(N(i+1)),', $DoA\:\theta_1 =\:$', num2str(theta1), '$^o$'],...
    'interpreter','latex','FontSize',14);
    xlabel('$\theta/deg$','interpreter','latex','FontSize',12);
    ylabel('directivity','interpreter','latex','FontSize',12);
end
if isequal(maxAF,sqrt(N(2:end)))
    disp('The maximum of each Array Factor is sqrt(N)');
end
sgtitle('Conventional beamforming','interpreter','latex','FontSize',14);

%% ----------------------- different d/lambda
k=d/lambda*([0.5 1 2 4]');
psi=2*pi*k*(sin(theta)-sin(theta1));
figure(4)
for i=1:4
    subplot(2,2,i); 
    plot(theta*r2d,abs(diric(psi(i,:),N(1))*sqrt(N(1))),'Color',color1,'LineWidth', 1.5); grid on
    axis([-90 90 0 inf])
    title(['$N=\:$',num2str(N(1)),', $DoA\:\theta_1 =\:$', num2str(theta1), '$^o$',', $d/\lambda\:=\:$', num2str(k(i))],...
    'interpreter','latex','FontSize',14);
    xlabel('$\theta/deg$','interpreter','latex','FontSize',12);
    ylabel('directivity','interpreter','latex','FontSize',12);
end
sgtitle('Conventional beamforming','interpreter','latex','FontSize',14);

%% ----------------------- maximum directivity
figure(5)
psi=2*pi*(7/8)*(sin(theta)-sin(theta1));
polarplot(theta, abs(diric(psi,N(1))*sqrt(N(1))),'Color',color1,'LineWidth', 1.5);
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';
ax.ThetaLim = [-90 90];
axis([-90 90 0 inf])
title(['Maximum directivity CB with $N=\:$',num2str(N(1)),', $DoA\:\theta_1 =\:$', num2str(theta1), '$^o$',', $d/\lambda\:=\:$', num2str(7/8)],...
    'interpreter','latex','FontSize',14);

%% ----------------------- FNBW
theta1=30*d2r;
FNBW=(asin(sin(theta1)+(lambda/d)/N(1))-asin(sin(theta1)-(lambda/d)/N(1)))*r2d;
theta1=60*d2r;
Nmin=ceil(lambda/(d*(1-sin(theta1))));      % to set the first null < 90 deg
theta1_null=asin(sin(theta1)+(lambda/d)/Nmin)*r2d;
psi=2*pi*d/lambda*(sin(theta)-sin(theta1));

figure(6)
plot(theta*r2d,abs(diric(psi,Nmin)*sqrt(Nmin)),'Color',color1,'LineWidth', 1.5); 
grid on; 
title(['Conventional beamforming with $N=\:$',num2str(Nmin),', $DoA\:\theta_1 =\:$', num2str(r2d*theta1), '$^o$'],...
    'interpreter','latex','FontSize',14);
xlabel('$\theta/deg$','interpreter','latex','FontSize',12);
ylabel('directivity','interpreter','latex','FontSize',12);

