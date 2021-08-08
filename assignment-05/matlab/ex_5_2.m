% Assignment 2 - Image processing on OCT

clear all
close all
clc

addpath ./data

%---------------------------Data aquisition

filename='tomogram.tif';            
OCT=imread(filename);
imshow(OCT);
title('Corneal OCT image','interpreter','latex','FontSize',16);
impixelinfo;

pix=4.13e-6;                    % pixel dimension m

%---------------------------Corneal axis
%[y,x]
[N,M]=size(OCT);

I=find(OCT'==255);              % first full white pxl
x0=rem(I(1),M);                 
y1=ceil(I(1)/M);

for i=x0:M
    if OCT(y1,i)~=255 
        x2=i-1;                  % last white pxl in the row
        x1=ceil((x2+x0)/2);      % center of the white row
       break                
    end
end
    
%---------------------------Cornea radius

xA=ceil(x1/2);
for i=y1:N
    if OCT(i,xA)==255
        yA=i;
        break
    end
end

c1=(x1-xA);
c2=(yA-y1);
R=ceil(((c1^2+c2^2)/(2*c2)));   % estimated radius
r=pix*R;

xc=x1; yc=y1+R-1;               % center coordinates

%---------------------------Mean intensity

lag=25;

OCT2=zeros(1,N);
for i=1:N
    OCT2(i)=sum(OCT(i,(x1-lag):(x1+lag)))/(2*lag);
end

figure
subplot(1,2,2); plot(OCT2,[0:(N-1)])
axis([0 255 0 640]); set(gca, 'YDir','reverse'); 
xlabel('gray scale value','interpreter','latex')
ylabel('pixel y position','interpreter','latex');
title('Mean intensity values','interpreter','latex');
subplot(1,2,1); imshow(OCT(:,(x1-lag):(x1+lag)));
title('Central region','interpreter','latex');

%---------------------------Reagions boundaries


y5=0;                   
for i=(yA):N
    if(OCT(i,x1)==255)
        y5=i;                   % end of Epithelium
        break
    end
end

TF=islocalmin(OCT2(y1:y5),'MaxNumExtrema',3);

y=[y1 0 0 0 y5];                % regions indexes vector
k=2;
for i=1:length(TF)
    if TF(i)==1
        y(k)=i+(y1-1);
        k=k+1;
    end
end
        
    
figure
plot(OCT2,1:N); hold on
plot(OCT2(y1),y1,'o');
plot(OCT2(y(2)),y(2),'o');
plot(OCT2(y(3)),y(3),'o');
plot(OCT2(y(4)),y(4),'o');
plot(OCT2(y5),y5,'o');
axis([0 270 150 300]); set(gca, 'YDir','reverse'); 
title('Mean intensity values','interpreter','latex');
legend('mean',['$y_1=$' num2str(y(1))],...
    ['$y_2=$' num2str(y(2))],...
    ['$y_3=$' num2str(y(3))],...
    ['$y_4=$' num2str(y(4))],...
    ['$y_5=$' num2str(y(5))],...
    'Location','east','interpreter','latex');
    
    

figure
imshow(OCT);
title(['Corneal OCT image - Radius=' num2str(R) '$p$'],'interpreter','latex');
line([x1 x1],[y(1) y(2)],'LineWidth',3,'Color',[64 224 208]/255);
line([x1 x1],[y(2) y(3)],'LineWidth',3,'Color',[221 160 221]/255);
line([x1 x1],[y(3) y(4)],'LineWidth',3,'Color',[173 255 47]/255);
line([x1 x1],[y(4) y(5)],'LineWidth',3,'Color',[255 127 80]/255);
legend(['Epithelium ' num2str(y(2)-y(1)) 'p'],...
    ['Bowman ' num2str(y(3)-y(2)) 'p'],...
    ['Stroma ' num2str(y(4)-y(3)) 'p'],...
    ['Endothelium ' num2str(y(5)-y(4)) 'p'],...
    'interpreter','latex')
impixelinfo;



figure
cs=[325 140 340 200];           % crop window dimentions
OCT2 = imcrop(OCT,cs);
imshow(OCT2);
cs=cs-1;  
title(['Corneal OCT image - Radius=' num2str(round((r*1e6),2)) '$\mu m$'],'interpreter','latex');
line([x1-cs(1) x1-cs(1)],[y(1)-cs(2) y(2)-cs(2)],'LineWidth',3,'Color',[64 224 208]/255);
line([x1-cs(1) x1-cs(1)],[y(2)-cs(2) y(3)-cs(2)],'LineWidth',3,'Color',[221 160 221]/255);
line([x1-cs(1) x1-cs(1)],[y(3)-cs(2) y(4)-cs(2)],'LineWidth',3,'Color',[173 255 47]/255);
line([x1-cs(1) x1-cs(1)],[y(4)-cs(2) y(5)-cs(2)],'LineWidth',3,'Color',[255 127 80]/255);
legend(['Epithelium ' num2str(round(((y(2)-y(1))*pix*1e6),2)) '$\mu m$'],...
    ['Bowman ' num2str(round(((y(3)-y(2))*pix*1e6),2)) '$\mu m$'],...
    ['Stroma ' num2str(round(((y(4)-y(3))*pix*1e6),2)) '$\mu m$'],...
    ['Endothelium ' num2str(round(((y(5)-y(4))*pix*1e6),2)) '$\mu m$'],...
    'interpreter','latex')
impixelinfo;









    
