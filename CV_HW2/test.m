clear all; close all; clc;

img1 = imread('checkboard.jpg');
img2 = imread('brickwall.jpg');
img3 = imread('rolla.jpg');

S = 1;  % sigma = 1-3
N = 5;  % size of local NxN neighborhood
D = 100;  % radius of neighboor
M = 120;

% Results of Harris Corners Detector
[Corners1 R1] = detectHarrisCorners(img1, S, N, D, M);
[Corners2 R2] = detectHarrisCorners(img2, S, N, D, M);
[Corners3 R3] = detectHarrisCorners(img3, S, N, D, M);

% Results of Eigen Decomposition Detector
% [corners1 r1] = eigendecomposition(img1, S, N, D, M);
% [corners2 r2] = eigendecomposition(img2, S, N, D, M);
% [corners3 r3] = eigendecomposition(img3, S, N, D, M);

figure, imagesc(img1), axis image, colormap(gray), hold on
plot(Corners1(:,1), Corners1(:,2), 'ys'), title('Harris Corners of checkboard.jpg');

figure, imagesc(img2), axis image, colormap(gray), hold on
plot(Corners2(:,1), Corners2(:,2), 'ys'), title('Harris Corners of brickwall.jpg');

figure, imagesc(img3), axis image, colormap(gray), hold on
plot(Corners3(:,1), Corners3(:,2), 'ys'), title('Harris Corners of rolla.jpg');

% figure, imagesc(img1), axis image, colormap(gray), hold on
% plot(corners1(:,1), corners1(:,2), 'ys'), title('Eigen Decomposition of checkboard.jpg');
% 
% figure, imagesc(img2), axis image, colormap(gray), hold on
% plot(corners2(:,1), corners2(:,2), 'ys'), title('Eigen Decomposition of brickwall.jpg');
% 
% figure, imagesc(img3), axis image, colormap(gray), hold on
% plot(corners3(:,1), corners3(:,2), 'ys'), title('Eigen Decomposition of rolla.jpg');