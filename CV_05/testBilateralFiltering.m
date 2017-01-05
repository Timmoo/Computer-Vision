clc; close all;

im = double(imread('sarah.jpg'));
[nrows, ncols, np] = size(im);
figure; imshow(uint8(im)); title('input image');

figure; imshow(uint8(imfilter(im,fspecial('gaussian',[7 7], 2))));
title('Gaussian smoothing');

output = zeros(nrows,ncols,np);
for ip = 1:np
    output(:,:,ip) = bilateralFilter(im(:,:,ip));    
end
figure; imshow(uint8(output)); title('Bilatering filtering');



