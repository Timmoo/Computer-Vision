
%function
[x, y] = meshgrid(-4:.5:4);
f = 100-0.5*x.^2-0.5*y.^2;
figure(1); surf(f);
%figure(1); surf(x,y,f);

%gradient
[dx, dy] = gradient(f);
figure(2);
contour(x,y,f); hold on;
quiver(x,y,dx,dy); hold off;

%figure(3); imshow(f,[]);
figure(3); imagesc(f); colormap(gray); hold on;
[tmpx, tmpy] = meshgrid(1:size(f,1));
contour(f,'LineWidth',2,'Color','b');
quiver(tmpx,tmpy,dx,dy,'Color','r');
hold off;

% Image and its gradient
im = imread('cameraman.tif');
figure(4); imshow(im);
im = imcrop;
%[im,rect] = imcrop;
im = double(im)/255;
[dx, dy] = gradient(im);
[tmpx, tmpy] = meshgrid(1:size(im,2),1:size(im,1));
figure(4); imagesc(im); colormap(gray); hold on;
contour(im,'LineWidth',2,'Color','b');
quiver(tmpx,tmpy,dx,dy,'Color','r');
hold off;