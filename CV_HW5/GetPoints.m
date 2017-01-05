close all; clear all; clc;

% (0) Two images are provided for this homework
img1 = imread('Img1.jpg');
img2 = imread('Img2.jpg');

% (1) Use Matlab function ginput() to select N points in image 1 and their corresponding points in image 2;
N = 10;
figure(1); imshow(img1, 'InitialMagnification', 200); title('img1');
[x1, y1] = ginput(N); 
hold on;
% plot(x1, y1, 'ys');
for i = 1:N
    text(x1(i), y1(i), int2str(i), 'Color', 'y');
end

figure(2); imshow(img2, 'InitialMagnification', 200); title('img2');
[x2, y2] = ginput(N); 
hold on;
% plot(x2, y2, 'ys');
for i = 1:N
    text(x2(i), y2(i), int2str(i), 'Color', 'y');
end
point1 = [x1'; y1'; x2'; y2'];  % record the 10 points for test a, [x1; y1; x2; y2]

M = 15; % first 5 points along a line, then the median 5 points concentrating within a small resion, the last 5 points spread over a wide region.
figure(3); imshow(img1, 'InitialMagnification', 200); title('img1');
[x3, y3] = ginput(M); 
hold on;
% plot(x3, y3, 'ys');
for i = 1:M
    text(x3(i), y3(i), int2str(i), 'Color', 'y');
end

figure(4); imshow(img2, 'InitialMagnification', 200); title('img2');
[x4, y4] = ginput(M); 
hold on;
% plot(x4, y4, 'ys');
for i = 1:M
    text(x4(i), y4(i), int2str(i), 'Color', 'y');
end
point2 = [x3'; y3'; x4'; y4'];  % record the 10 points for test a, [x3; y3; x4; y4]
save('point.mat', 'point1', 'point2');