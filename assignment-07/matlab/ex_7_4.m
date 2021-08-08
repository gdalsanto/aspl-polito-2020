clc; clear; close all;
%% Parameters with spacing d=lambda\2
Nz = 16;            % number of sensors along z
Ny = 16;            % number of sensors along y
N_tot = Nz*Ny;
n_intf = 5;         % number of interferers
sigman2 = 1e-5;     % noise variance
%-----------------------
theta_1deg = 90;  
theta_1 = deg2rad(theta_1deg);   
phi_1deg = 0;  
phi_1 = deg2rad(phi_1deg);
%-----------------------
theta_intfdeg = [86 85 80 100 105]; % el. angles of interferers
theta_intf =  deg2rad(theta_intfdeg); 
phi_intfdeg = [4 20 5 -15 15];      % az. of interferers
phi_intf =  deg2rad(phi_intfdeg); % 
directive = 1;
%ARRAY LIES IN THE Z-Y PLANE
Tz=2*[-Nz/2+1:Nz/2]-1;
Ty=2*[-Ny/2+1:Ny/2]-1;
T = Tz'*ones(1,Ny)./Nz+1i*ones(Nz,1)*Ty/Ny;
T = T(:)./sqrt(Nz*Ny);
%% Antenna element directivity function 
if(directive==1)
    dir = @(x,y) 0.25*(1-cos(2*x)).*(1+cos(y));
end
%% Compute the beamforming filter
DoA_theta=[theta_1 theta_intf];
DoA_phi=[phi_1 phi_intf];
N_DoA=length(DoA_theta);
csi_z=2*pi*0.5*cos(DoA_theta);
csi_y=2*pi*0.5*sin(DoA_theta).*sin(DoA_phi);
a_z=exp(1j*(0:(Nz-1))'*csi_z);
a_y=exp(1j*(0:(Ny-1))'*csi_y);
a=zeros(N_tot,N_DoA);
for ii = 1:N_DoA
    a(:,ii)=kron(a_z(:,ii),a_y(:,ii));
    if directive==1
        a(:,ii)=dir(DoA_theta(ii),DoA_phi(ii)).*a(:,ii);
    end
end
Ry=zeros(N_tot,N_tot);
for ii = 1:N_DoA
    Ry=Ry+a(:,ii)*a(:,ii)';
end
Ry=Ry+sigman2*eye(N_tot,N_tot);
w_mvdr=(Ry\a(:,1))/(a(:,1)'*(Ry\a(:,1)));       % beamformer
%% Compute ULA pattern
angles_1 = 361;
theta = linspace(0,pi,angles_1);
angles_2 = 721;
phi = linspace(-pi, pi, angles_2);
[grid_phi,grid_theta]=meshgrid(phi,theta);
csi_z=2*pi*0.5*cos(grid_theta);
csi_y=2*pi*0.5*sin(grid_theta).*sin(grid_phi);
a_z=zeros(Nz,angles_1,angles_2);
a_y=zeros(Ny,angles_1,angles_2);
for ii=0:Nz-1
    a_z(ii+1,:,:)=exp(1j*csi_z.*ii);
end
for ii=0:Ny-1
    a_y(ii+1,:,:)=exp(1j*csi_y.*ii);
end

dirmat=zeros(1, angles_1, angles_2);
if directive==1
    dirmat(1,:,:) = 0.25.*(1-cos(2.*grid_theta)).*(1+cos(grid_phi));
else
    dirmat = 1;
end

A=zeros(Nz*Ny,angles_1,angles_2);
for ii=1:angles_1
    for jj=1:angles_2
        A(:,ii,jj)=kron(a_z(:,ii,jj),a_y(:,ii,jj));
    end
end
A = A.*repmat(dirmat(1,:,:),Nz*Ny,1,1);
pattern=zeros(angles_1,angles_2);
for ii=1:angles_1
    pattern(ii,:)=w_mvdr'*squeeze(A(:,ii,:));
end
%% Plot the pattern
[PHI, THETA] = meshgrid(phi, theta');
Z = abs(pattern).*cos(THETA);
Y = abs(pattern).*sin(THETA).*sin(PHI);
X = abs(pattern).*sin(THETA).*cos(PHI);
r = abs(w_mvdr'*a);
r_col = sqrt(X.^2+Y.^2+Z.^2);
x_1 = r*sin(theta_1)*cos(phi_1);
y_1 = r*sin(theta_1)*sin(phi_1);
z_1 = r*cos(theta_1);
figure(1)
mesh(X,Y,Z, r_col, 'FaceAlpha', 0.5, 'EdgeAlpha', 0.5);
view([-7+90, 20]);
hold on;
hidden on;
plot3(zeros(N_tot,1), imag(T), real(T), 'ks', 'MarkerFaceColor', [0.75 0.75 0.75]);
plot3([0 x_1], [0 y_1], [0 z_1], '--r', 'LineWidth', 3);
plot3(x_1(1), y_1(1), z_1(1), 'ro','MarkerFaceColor', 'r', 'MarkerSize', 8);
txt1 = 'User';
text(x_1(1),y_1(1),z_1(1),txt1);
for ii = 1:n_intf
    x_i = r*sin(theta_intf(ii)).*cos(phi_intf(ii));
    y_i = r*sin(theta_intf(ii)).*sin(phi_intf(ii));
    z_i = r*cos(theta_intf(ii));
    plot3([0 x_i], [0 y_i], [0 z_i], '--k', 'LineWidth', 2);
    txt2 = ['\theta: ' num2str(theta_intfdeg(ii)), char(176), ', \phi: ', num2str(phi_intfdeg(ii)), char(176)];
    text(x_i(1), y_i(1), z_i(1) ,txt2);
    hold on;
end
xlabel('x'); ylabel('y'); zlabel('z');
title({['MVDR with planar array ',num2str(Nz), 'x',num2str(Ny)]...
    ['user elevation angle \theta = ', num2str(theta_1deg), char(176),  ' user azimuth \phi = ', num2str(phi_1deg), char(176)]}, 'FontSize',12);