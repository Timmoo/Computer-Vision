close all; clear all; clc;

load('point.mat', 'point1', 'point2');
experiment = 7; % number of experiment from 1~7;
if experiment == 1  % if N < 4 points -> N = 3;
    N = 3;
    x1 = point1(1, 1: 3)';
    y1 = point1(2, 1: 3)';
    x2 = point1(3, 1: 3)';
    y2 = point1(4, 1: 3)';
elseif experiment == 2  % if N == 4 points -> N = 4;
    N = 4;
    x1 = point1(1, 1: 4)';
    y1 = point1(2, 1: 4)';
    x2 = point1(3, 1: 4)';
    y2 = point1(4, 1: 4)';
elseif experiment == 3  % if N ~= 4 points -> N = 5;
    N = 5;
    x1 = point1(1, 1: 5)';
    y1 = point1(2, 1: 5)';
    x2 = point1(3, 1: 5)';
    y2 = point1(4, 1: 5)';
elseif experiment == 4  % if N >> 4 points -> N = 10;
    N = 10;
    x1 = point1(1,:)';
    y1 = point1(2,:)';
    x2 = point1(3,:)';
    y2 = point1(4,:)';
elseif experiment == 5  % if N >= 4 along a line -> N = 5;
    N = 5;
    x1 = point2(1, 1: 5)';
    y1 = point2(2, 1: 5)';
    x2 = point2(3, 1: 5)';
    y2 = point2(4, 1: 5)';
elseif experiment == 6  % if N >= 4 concentrate within a small region -> N = 5;
    N = 5;
    x1 = point2(1, 6: 10)';
    y1 = point2(2, 6: 10)';
    x2 = point2(3, 6: 10)';
    y2 = point2(4, 6: 10)';
elseif experiment == 7  % if N >= 4 spread over a wide region -> N = 5;
    N = 5;
    x1 = point2(1, 11: 15)';
    y1 = point2(2, 11: 15)';
    x2 = point2(3, 11: 15)';
    y2 = point2(4, 11: 15)';
else
    N = 15;
    x1 = point2(1,:)';
    y1 = point2(2,:)';
    x2 = point2(3,:)';
    y2 = point2(4,:)';
end

% (0) Two images are provided for this homework
img1 = imread('Img1.jpg');
img2 = imread('Img2.jpg');

% (1) Use Matlab function ginput() to select N points in image 1 and their corresponding points in image 2;
figure(1); imshow(img1, 'InitialMagnification', 150); title('img1 point2');
% [x1, y1] = ginput(N); 
hold on;
% plot(x1, y1, 'ys');
for i = 1:N
    text(x1(i), y1(i), int2str(i), 'Color', 'y');
end

figure(2); imshow(img2, 'InitialMagnification', 150); title('img2 point2');
% [x2, y2] = ginput(N); 
hold on;
% plot(x2, y2, 'ys');
for i = 1:N
    text(x2(i), y2(i), int2str(i), 'Color', 'y');
end


% (2) Assume h33=1, use the Pseudo inverse method in Lecture 12 to estimate the homography matrix;
A1 = zeros(2 * N, 8);
b = zeros(2 * N, 1);
for i = 1:N
    A1(2 * i - 1,:) = [x1(i) y1(i) 1 0 0 0 (-x1(i) * x2(i)) (-y1(i) * x2(i))];
    A1(2 * i,:) = [0 0 0 x1(i) y1(i) 1 (-x1(i) * y2(i)) (-y1(i) * y2(i))];
    b(2 * i - 1) = x2(i);
    b(2 * i) = y2(i);
end
h1 = A1 \ b;
h1 = [h1(1) h1(2) h1(3); h1(4) h1(5) h1(6); h1(7) h1(8) 1];


% (3) Assume ||h||=1, use the eigen-decomposition and singular value decomposition (details in Lecture 12) to estimate the homography matrix. Compare the results with (2).
A2 = zeros(2 * N, 9);
for i = 1:N
    A2(2 * i - 1,:) = [x1(i) y1(i) 1 0 0 0 (-x1(i) * x2(i)) (-y1(i) * x2(i)) (-x2(i))];
    A2(2 * i,:) = [0 0 0 x1(i) y1(i) 1 (-x1(i) * y2(i)) (-y1(i) * y2(i)) (-y2(i))];
end
[V, D] = eig(A2' * A2);
h2 = V(:,1);
h2 = [h2(1) h2(2) h2(3); h2(4) h2(5) h2(6); h2(7) h2(8) h2(9)];


% prove
prove1 = zeros(N, 2);   % [x2 y2]
for i = 1:N
%     prove1(i,:) = [round((h1(1, 1) * x1(i) + h1(1, 2) * y1(i) + h1(1, 3)) / (h1(3, 1) * x1(i) + h1(3, 2) * y1(i) + 1)), round((h1(2, 1) * x1(i) + h1(2, 2) * y1(i) + h1(2, 3)) / (h1(3, 1) * x1(i) + h1(3, 2) * y1(i) + 1))];
    prove1(i,:) = [(h1(1, 1) * x1(i) + h1(1, 2) * y1(i) + h1(1, 3)) / (h1(3, 1) * x1(i) + h1(3, 2) * y1(i) + h1(3, 3)), (h1(2, 1) * x1(i) + h1(2, 2) * y1(i) + h1(2, 3)) / (h1(3, 1) * x1(i) + h1(3, 2) * y1(i) + h1(3, 3))];
end

prove2 = zeros(N, 2);   % [x2 y2]
for i = 1:N
%     prove2(i,:) = [round((h2(1, 1) * x1(i) + h2(1, 2) * y1(i) + h2(1, 3)) / (h2(3, 1) * x1(i) + h2(3, 2) * y1(i) + h2(3, 3))), round((h2(2, 1) * x1(i) + h2(2, 2) * y1(i) + h2(2, 3)) / (h2(3, 1) * x1(i) + h2(3, 2) * y1(i) + h2(3, 3)))];
    prove2(i,:) = [(h2(1, 1) * x1(i) + h2(1, 2) * y1(i) + h2(1, 3)) / (h2(3, 1) * x1(i) + h2(3, 2) * y1(i) + h2(3, 3)), (h2(2, 1) * x1(i) + h2(2, 2) * y1(i) + h2(2, 3)) / (h2(3, 1) * x1(i) + h2(3, 2) * y1(i) + h2(3, 3))];
end

% Difference
tmp = ([x2 y2] - prove1) .^ 2;
average_difference_prove1 = mean(sqrt(tmp(:,1) + tmp(:,1)));
std_difference_prove1 = std(sqrt(tmp(:,1) + tmp(:,1)));

tmp = ([x2 y2] - prove2) .^ 2;
average_difference_prove2 = mean(sqrt(tmp(:,1) + tmp(:,1)));
std_difference_prove2 = std(sqrt(tmp(:,1) + tmp(:,1)));