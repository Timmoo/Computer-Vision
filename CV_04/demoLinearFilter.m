clear all; close all; clc;

%define kernel f and g
[x, y] = meshgrid(-2:.1:2);
sigma2 = .05;
f = -x.*exp(-(x.^2+y.^2)/sigma2);
g = -y.*exp(-(x.^2+y.^2)/sigma2);

%get the input image h
% h = zeros(100,100);
% [tx, ty] = meshgrid(1:100);
% idx = (tx-50).^2+(ty-50).^2 < 900;
% h(idx) = 1;
h = double(imread('rolla.jpg'));
h = h(:,:,1);

%take a look
figure(1); subplot(1,3,1); imshow(f,[]); title('kernel f');
subplot(1,3,2); imshow(g,[]); title('kernel g');
subplot(1,3,3); imshow(h,[]); title('image h');

%compute the convolution 
fh = conv2(h, f, 'same');
gh = conv2(h, g, 'same');

% pause

%show (a f + b g)*h = a f*h + b g*h
for theta = 0:0.05*pi:2*pi
    
    a = cos(theta);
    b = sin(theta);
    kernel = a*f+b*g;
    
    figure(2);
    subplot(2,3,1); imshow(kernel,[]); title('kernel: a f + b g');
    subplot(2,3,2); imshow(fh,[]); title('f*h');
    subplot(2,3,3); imshow(gh,[]); title('g*h');
    subplot(2,3,4); imshow(conv2(h,kernel,'same'),[]); title('(a f + b g)*h');
    subplot(2,3,6); imshow(a*fh+b*gh,[]); title('a f*h + b g*h');
    drawnow;
%     pause(.5);
end
