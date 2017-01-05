% im = double(imread('cameraman.tif'));
im = double(imread('lena.tif'));
[dx, dy] = gradient(im);
figure; imshow(dx,[]); title('dx');
% figure; imshow(dx); title('dx');
figure; imshow(dy,[]); title('dy');
figure; imshow(sqrt(dx.^2+dy.^2),[]); title('Magnitude of gradient');
figure; imshow(atan2(dy,dx),[]); title('Angle of gradient'); colormap(jet);

