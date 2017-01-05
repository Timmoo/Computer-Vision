clc; close all; clear all;

im = imread('cameraman.tif');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%get a small patch. compare the surface before/after smoothing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure; imshow(im);
[cx,cy] = ginput(1);
cx = round(cx); cy = round(cy);
halfwid = 8;
hold on; plot(cx,cy,'r*'); 
plot([cx-halfwid cx-halfwid cx+halfwid cx+halfwid cx-halfwid],...
     [cy-halfwid cy+halfwid cy+halfwid cy-halfwid cy-halfwid],'r');
hold off;
smallpatch = double(im(cx+(-halfwid:halfwid),cy+(-halfwid:halfwid)));

figure; surf(smallpatch); colormap(gray); title('patch surface before smoothing');

figure; hist(smallpatch(:)); title('intensity distribution of a small patch');

smoothedpatch = imfilter(smallpatch,ones(3,3)/9,'same','symmetric');
figure; surf(smoothedpatch); colormap(gray); title('smoothed patch');


pause; close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compare the smoothing results by box filter and Gaussian filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smoothedByBox11 = imfilter(im,ones(11,11)/121,'same',0);
figure; subplot(2,2,1); imshow(smoothedByBox11,[]); title('Box filtering with halfwid = 11');

sigma = 1; halfwid = 3*sigma;
[xx,yy] = meshgrid(-halfwid:halfwid,-halfwid:halfwid);
gau = exp(-(xx.^2+yy.^2)/(2*sigma^2));
smoothedByGau1 = imfilter(im,gau/sum(gau(:)),'same',0);
subplot(2,2,2); imshow(smoothedByGau1,[]); title('Gaussian smoothing with sigma = 1');

sigma = 3; halfwid = 3*sigma;
[xx,yy] = meshgrid(-halfwid:halfwid,-halfwid:halfwid);
gau = exp(-(xx.^2+yy.^2)/(2*sigma^2));
smoothedByGau3 = imfilter(im,gau/sum(gau(:)),'same',0);
subplot(2,2,3); imshow(smoothedByGau3,[]); title('Gaussian smoothing with sigma = 3');

sigma = 10; halfwid = 3*sigma;
[xx,yy] = meshgrid(-halfwid:halfwid,-halfwid:halfwid);
gau = exp(-(xx.^2+yy.^2)/(2*sigma^2));
smoothedByGau10 = imfilter(im,gau/sum(gau(:)),'same',0);
subplot(2,2,4); imshow(smoothedByGau10,[]); title('Gaussian smoothing with sigma = 10');

sigmax = 3; sigmay = 6;
halfwid = 3*sigmax;
[xx, yy] = meshgrid(-halfwid:halfwid,-halfwid:halfwid);
asymGau = exp(-xx.^2/(2*sigmax^2) - yy.^2/(2*sigmay^2));
smoothedByAsymGau3 = imfilter(im,asymGau/sum(asymGau(:)),'same',0);

figure; surf(gau); title('Symmetric Gaussian kernel');
figure; surf(asymGau); title('Asymmetric Gaussian kernel');
figure; imshow(smoothedByAsymGau3,[]);

pause; close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compare different padding options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
smoothedByGau10 = imfilter(im,gau/sum(gau(:)),'same',0);
figure; subplot(2,2,1); imshow(smoothedByGau10,[]); title('zero padding');

smoothedByGau10 = imfilter(im,gau/sum(gau(:)),'same','symmetric');
subplot(2,2,2); imshow(smoothedByGau10,[]); title('symmetric padding');

smoothedByGau10 = imfilter(im,gau/sum(gau(:)),'same','replicate');
subplot(2,2,3); imshow(smoothedByGau10,[]); title('replicate padding');

smoothedByGau10 = imfilter(im,gau/sum(gau(:)),'same','circular');
subplot(2,2,4); imshow(smoothedByGau10,[]); title('circular padding');


pause; close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sobel and prewitt edge detection -- smoothed derivative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imfilter([-1 0 1],[1 1 1]','conv', 'full')
imfilter([-1 0 1],[1 2 1]','conv', 'full')


pause; close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%G_\sigma^x = g_\sigma^x*g_\sigma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x, y] = meshgrid(-5:1:5);
sigma2 = 4;
Gsigmax = -x.*exp(-(x.^2+y.^2)/sigma2);
figure; subplot(2,2,1); surf(Gsigmax); title('G_\sigma^x');

x = -5:1:5;
gsigmax = -x.*exp(-x.^2/sigma2);
subplot(2,2,2); plot(gsigmax); title('g_\sigma^x');

y = -5:1:5;
gsigma = exp(-y.^2/sigma2);
subplot(2,2,3); plot(gsigma); title('g_\sigma');

sepGsigmax = imfilter(gsigmax,gsigma','full');
subplot(2,2,4); surf(sepGsigmax); title('g_\sigma^x*g_\sigma');


pause; close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compare the gradient without/with smoothing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[dx, dy] = gradient(double(im));
figure; subplot(1,2,1); imshow(dx,[]); title('dx');

smoothedder = imfilter(double(im),Gsigmax/sum(Gsigmax(:)),'same','conv');
subplot(1,2,2); imshow(smoothedder,[]); title('smoothed derivative');





