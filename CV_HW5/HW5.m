clear all; close all; clc;

load('point.mat', 'point1');
% When N = 3 or 4, the homography matrix would be more accuracy
% N = 3;
% x1 = point1(1, 1: 3)';
% y1 = point1(2, 1: 3)';
% x2 = point1(3, 1: 3)';
% y2 = point1(4, 1: 3)';

N = 4;
x1 = point1(1, 1: 4)';
y1 = point1(2, 1: 4)';
x2 = point1(3, 1: 4)';
y2 = point1(4, 1: 4)';

% get the homography matrix
% h = GetHomography1(x1, y1, x2, y2, N);  % assume h33 = 1
% h = GetHomography2(x1, y1, x2, y2, N);  % assume ||h|| = 1
h = [1.15446723649351 0.0469860280094242 -98.7718356195859; -0.0585850815625497 1.20850355096465 -12.7501766788246; -0.000315545737864621 0.000690655249184463 1];

% read the two image
img1 = imread('Img1.jpg');
img2 = imread('Img2.jpg');
% img1 = rgb2gray(img1);
% img2 = rgb2gray(img2);

% forward warping
fw_img = ForwardWarping(img1, img2, h);
figure; imshow(fw_img, []); title('forward warping');

% backward warping
bw_img1 = BackwardWarping1(img1, img2, h);
figure; imshow(bw_img1, []); title('backward warping - nearest neighbor');

bw_img2 = BackwardWarping2(img1, img2, h);
figure; imshow(bw_img2, []); title('backward warping - interpolation');

% backward warping with interp2()
foo = BackwardWarping_Interp2(img1, h);
figure; imshow(foo, []); title('interp2');