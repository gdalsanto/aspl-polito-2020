    clc; clear, close all; 
%% Parameters
c = 3e8;            % speed of light
fc = 6e9;           % frequency
lambda = c/fc;      % wave length
Nz = 8;             % number of sensors along z
Ny = 8;             % number of sensors along y
d_z = lambda/2;     % sensor spacing along z [m]
d_y = lambda/2;     % sensor spacing along y [m]
theta_1deg = 100;   % UE el. angle from 0 to 180
theta_1 = deg2rad(theta_1deg); 
phi_1deg = 30;      % user az. from -90 to 90
phi_1 = deg2rad(phi_1deg);
directive = 0;
%ARRAY LIES IN THE Z-Y PLANE
Tz=(2*[-Nz/2+1:Nz/2]-1);
Ty=2*[-Ny/2+1:Ny/2]-1;
T = Tz'*ones(1,Ny)./Nz+1i*ones(Nz,1)*Ty/Ny;
T = T(:);
%% Antenna element directivity function 
if(directive==1)
    dir_mat = @(x,y) 0.25*(1-cos(2*x)).*(1+cos(y));
end
%% Compute the beamforming filter
%phase terms
csi_z=2*pi*d_z/lambda*cos(theta_1);
csi_y=2*pi*d_y/lambda*sin(theta_1)*sin(phi_1);
a_z=exp(1j*csi_z*(0:(Nz-1))');
a_y=exp(1j*csi_y*(0:(Ny-1))');
a=kron(a_z,a_y);
w=a/sqrt(Nz*Ny);
%% Compute UPA pattern
angles_1 = 361;
theta = linspace(0,pi,angles_1);
angles_2 = 721;
phi = linspace(-pi, pi, angles_2);
[grid_phi,grid_theta]=meshgrid(phi,theta);
csi_z=2*pi*d_z/lambda*cos(grid_theta);
csi_y=2*pi*d_y/lambda*sin(grid_theta).*sin(grid_phi);
a_z=zeros(Nz,angles_1,angles_2);
a_y=zeros(Ny,angles_1,angles_2);
for ii=0:Nz-1
    a_z(ii+1,:,:)=exp(1j*csi_z.*ii);
end
for ii=0:Ny-1
    a_y(ii+1,:,:)=exp(1j*csi_y.*ii);
end
A=zeros(Nz*Ny,angles_1,angles_2);
for ii=1:angles_1
    for jj=1:angles_2
        A(:,ii,jj)=kron(a_z(:,ii,jj),a_y(:,ii,jj));
    end
end
pattern=zeros(angles_1,angles_2);
for ii=1:angles_1
    pattern(ii,:)=w'*squeeze(A(:,ii,:));
end
%% Perform pattern multiplication
if(directive==1)
    pattern=dir_mat(grid_theta,grid_phi).*pattern;
end
%% Plot the pattern
[PHI, THETA] = meshgrid(phi, theta');
Z = abs(pattern).*cos(THETA);
Y = abs(pattern).*sin(THETA).*sin(PHI);
X = abs(pattern).*sin(THETA).*cos(PHI);
r = sqrt(Nz*Ny);
x_1 = r*sin(theta_1)*cos(phi_1);
y_1 = r*sin(theta_1)*sin(phi_1);
z_1 = r*cos(theta_1);
figure(2)
mesh(X,Y,Z, 'FaceAlpha', 0.5, 'EdgeAlpha', 0.5); axis equal;
view([50+90, 15]);
hold on;
hidden on;
plot3(zeros(Nz*Ny,1), imag(T), real(T), 'ks', 'MarkerFaceColor', 'r');
plot3([0 r], [0 0], [0,0], '--r');
txt1 = 'Broadside';
text(r,0,0,txt1, 'FontSize', 12);
if(theta_1deg ~= 90 || phi_1deg ~= 0)
    plot3([0 x_1], [0 y_1], [0 z_1], '--r', 'LineWidth', 2);
    txt2 = ['\theta: ' num2str(theta_1deg),char(176), ', \phi: ',num2str(phi_1deg),char(176)];
    text(x_1, y_1, z_1 ,txt2);
end
xlabel('x'); ylabel('y'); zlabel('z');
title({['Conventional BF with planar array ',num2str(Ny), 'x',num2str(Nz)]...
    ['elevation angle \theta = ', num2str(theta_1deg), char(176),  ' azimuth \phi = ',num2str(phi_1deg),char(176)]}, 'FontSize',12);
