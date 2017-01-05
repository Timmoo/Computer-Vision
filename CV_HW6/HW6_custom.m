close all; clear all; clc;

% source = imread('IMG_1377.JPG');
% destination = imread('IMG_1378.JPG');
source = imread('Photo1.jpg');
destination = imread('Photo2.jpg');

S = 2;  % sigma = 1-3
N = 7;  % size of local NxN neighborhood
D = 200;  % radius of neighboor
Ms = 400;    % number of corners we want to detect in source
Md = 450;    % number of corners we want to detect in destination
L = 11;  % size of patche = 2L + 1

% Results of Harris Corners Detector
[Corners_s Rs] = detectHarrisCorners(source, S, N, D, Ms);
[Corners_d Rd] = detectHarrisCorners(destination, S, N, D, Md);

% turn rbg image into gray image
source_gray = double(rgb2gray(source));
destination_gray = double(rgb2gray(destination));

% Visualize
% figure, imagesc(source), axis image, colormap(gray), hold on
% plot(Corners_s(:,1), Corners_s(:,2), 'ys'), title('Harris Corners of source');
% figure, imagesc(destination), axis image, colormap(gray), hold on
% plot(Corners_d(:,1), Corners_d(:,2), 'ys'), title('Harris Corners of destination');

% get the patches from both images
Patches_s = GetPatches(source_gray, Corners_s, L);
Patches_d = GetPatches(destination_gray, Corners_d, L);

C = zeros(Ms, Md);   % define a matrix to store the NCC
for i = 1:Ms
    for j = 1:Md
        C(i, j) = NCC(Patches_s{i}, Patches_d{j});
    end
end

[Match num] = CornersMatch(C);    % find the match patches
Pairs = PairsOfCorners(Match, num, Corners_s, Corners_d, C);  % Match the Corners and Get the Pairs

% Visualize
% figure, imagesc(source), axis image, colormap(gray), hold on
% plot(Pairs(:,2), Pairs(:,1), 'ys'), title('Corners of source');
% figure, imagesc(destination), axis image, colormap(gray), hold on
% plot(Pairs(:,4), Pairs(:,3), 'ys'), title('Corners of destination');
[row col] = size(source_gray);
figure; imshow([source destination]); hold on;
for i = 1:num
    plot([Pairs(i, 2) (Pairs(i, 4) + col)], [Pairs(i, 1) (Pairs(i, 3))], 'ys-');
end
title('Pairs of Corners without RANSAC');


% Use RANSAC algorithm to find the inlier set of correspondence points by matching patches. Use the inlier set of correspondence point s to compute the Homography matrix. 
s = 4;  % the smallest number of points required
N = 3000;    % the number of iterations required
d = 1;  % the threshold used to identify a point that fits well
T = 10;  % the number of nearby points required to assert a model fits well
Inlier = RANSAC(Pairs, s, N, d, T);

% Visualize
figure; imshow([source destination]); hold on;
for i = 1:size(Inlier, 1)
    plot([Inlier(i, 2) (Inlier(i, 4) + col)], [Inlier(i, 1) (Inlier(i, 3))], 'ys-');
end
title('Pairs of Corners with RANSAC');

H = GetHomography(Inlier(:,2), Inlier(:,1), Inlier(:,4), Inlier(:,3), size(Inlier, 1));

% Visualize
% source_bw = BackwardWarping2(source, destination, H);
% figure; imshow(source_bw); title('backward warping of source image');

% Based on the homography matrix and your warping method, create a mosaic image to combine two images.
[n_row n_col p_row p_col] = Resize(H, row, col);
warpedSrc = zeros(abs(n_row) + 1 + p_row, abs(n_col) + 1 + p_col, 3);

for y = n_row:p_row
    for x = n_col:p_col
        if y > 0 & x > 0 & y <= row & x <= col
            warpedSrc(y + abs(n_row) + 1, x + abs(n_col) + 1, 1) = destination(y, x, 1);
            warpedSrc(y + abs(n_row) + 1, x + abs(n_col) + 1, 2) = destination(y, x, 2);
            warpedSrc(y + abs(n_row) + 1, x + abs(n_col) + 1, 3) = destination(y, x, 3);
        else
            p = [x; y; 1];
            pprime = inv(H) * (p);
            % bilinear
            xprime = pprime(1) / pprime(3);
            yprime = pprime(2) / pprime(3);
            xf = floor(xprime);
            yf = floor(yprime);
            if xf < 1 | (xf + 1) > col | yf < 1 | (yf + 1) > row
                continue;
            end
            a = xprime - xf;
            b = yprime - yf;
            warpedSrc(y + abs(n_row) + 1, x + abs(n_col) + 1, 1) = (1 - a) * (1 - b) * source(yf, xf, 1) + a * (1 - b) * source(yf, xf + 1, 1) + (1 - a) * b * source(yf + 1, xf, 1) + a * b * source(yf + 1, xf + 1, 1);
            warpedSrc(y + abs(n_row) + 1, x + abs(n_col) + 1, 2) = (1 - a) * (1 - b) * source(yf, xf, 2) + a * (1 - b) * source(yf, xf + 1, 2) + (1 - a) * b * source(yf + 1, xf, 2) + a * b * source(yf + 1, xf + 1, 2);
            warpedSrc(y + abs(n_row) + 1, x + abs(n_col) + 1, 3) = (1 - a) * (1 - b) * source(yf, xf, 3) + a * (1 - b) * source(yf, xf + 1, 3) + (1 - a) * b * source(yf + 1, xf, 3) + a * b * source(yf + 1, xf + 1, 3);
        end
    end
end

warpedSrc = uint8(warpedSrc);
figure; imshow(warpedSrc); title('final result');