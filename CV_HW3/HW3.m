close all; clear all; clc;

img1 = imread('IMG_1377.JPG');
img2 = imread('IMG_1378.JPG');
% img1 = imread('1.jpg');
% img2 = imread('2.jpg');

S = 2;  % sigma = 1-3
N = 7;  % size of local NxN neighborhood
D = 200;  % radius of neighboor
M = 400;    % number of corners we want to detect in both images
L = 11;  % size of patche = 2L + 1

% Results of Harris Corners Detector
[Corners1 R1] = detectHarrisCorners(img1, S, N, D, M);
[Corners2 R2] = detectHarrisCorners(img2, S, N, D, M);

% turn rbg image into gray image
img1_gray = double(rgb2gray(img1));
img2_gray = double(rgb2gray(img2));

figure, imagesc(img1), axis image, colormap(gray), hold on
plot(Corners1(:,1), Corners1(:,2), 'ys'), title('Harris Corners of img1.jpg');

figure, imagesc(img2), axis image, colormap(gray), hold on
plot(Corners2(:,1), Corners2(:,2), 'ys'), title('Harris Corners of img2.jpg');

% get the patches from both images
Patches1 = GetPatches(img1_gray, Corners1, L);
Patches2 = GetPatches(img2_gray, Corners2, L);

C = zeros(M);   % define a matrix to store the NCC
for i = 1:M
    for j = 1:M
        C(i, j) = NCC(Patches1{i}, Patches2{j});
    end
end

[Match num] = CornersMatch(C);    % find the match patches
Pairs = PairsOfCorners(Match, num, Corners1, Corners2, C);  % Match the Corners and Get the Pairs

figure, imagesc(img1), axis image, colormap(gray), hold on
plot(Pairs(:,2), Pairs(:,1), 'ys'), title('Corners of img1.jpg');

figure, imagesc(img2), axis image, colormap(gray), hold on
plot(Pairs(:,4), Pairs(:,3), 'ys'), title('Corners of img2.jpg');

[row col] = size(img1_gray);
figure; imshow([img1 img2]); hold on;
for i = 1:num
    plot([Pairs(i, 2) (Pairs(i, 4) + col)], [Pairs(i, 1) (Pairs(i, 3))], 'ys-');
end
title('Pairs of Corners');
