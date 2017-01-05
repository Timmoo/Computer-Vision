function [corners, r] = eigendecomposition(Image, S, N, D, M)
% Image = a grayscale image
% S = Gaussian smoothing kernel sigma,
% N = size of the local NxN neighborhood for accumulating sums for Harris corner detection,
% D = radius of neighborhood for suppression multiple corner responses,
% M = number of corners we want to detect. and output parameters
% Corners = M*3 matrix where each row consists of [x, y, Rscore] for each corner point,
% R = R scores for all the pixels

% Image = imread('checkboard.jpg');
Image = double(rgb2gray(Image));
Threshold = 500;
% 1) Smooth the image using a Gaussian kernel with a given sigma S. S is given as an input parameter, so based on its value you must decide on the size of your smoothing kernel and fill in its values according to the Gaussian function. You will convolve the image with the smoothing kernel to produce a smoothed image. Note... you may wish to use the property of separability to replace convolution via a 2D Gaussian by a more efficient pair of convolutions using two 1D Gaussians.
% S = 1;
FilterSize = [max(1, fix(6 * S)) max(1, fix(6 * S))];  %6 times sigma rows, 6 times sigma columns, set by me.

%two 1D Gaussians
g_x = fspecial('gaussian', [1 FilterSize(2)], S);
g_y = fspecial('gaussian', [FilterSize(1) 1], S);

%applying 1D gaussian in Y-direction to the Image
Image_Y = imfilter(Image, g_y);

%applying 1D gaussian in X-direction to the Image_Y
Image_XY = imfilter(Image_Y, g_x);

%verifying
% g_xy = fspecial('gaussian', FilterSize, S);
% Image_XY2D = imfilter(Image, g_xy);
% max(max(abs(Image_XY - Image_XY2D)))


% 2) Compute gradient images Gx and Gy from the smoothed image from step 1 by convolving with row and column finite difference kernel operators for computing partial derivatives in x and y. We have discussed this in class lectures.
%derivative masks
dx = [1 0 -1; 1 0 -1; 1 0 -1];
dy = dx';

%Image derivatives
Gx = imfilter(Image_XY, dx, 'conv', 'same');
Gy = imfilter(Image_XY, dy, 'conv', 'same');


% 3) Compute Harris corner ?R? values over local neighborhoods of each pixel, using the gradient images Gx and Gy from step 2.
% a) compute the products of derivatives Gx^2, Gx Gy, and Gy^2 at every pixel.
Gx2 = Gx .^ 2;
Gy2 = Gy .^ 2;
GxGy = Gx .* Gy;

% b) compute sums of these products over the local NxN neighborhood at each pixel
% N = 3;
box = ones(N, N);
Sx2 = imfilter(Gx2, box);
Sy2 = imfilter(Gy2, box);
SxSy = imfilter(GxGy, box);

% E = [];
r = [];
for x = 1:size(Image, 1)
    for y = 1:size(Image, 2)
        % c) define at each pixel (x,y) the matrix
        H = [Sx2(x, y) SxSy(x, y); SxSy(x, y) Sy2(x, y)];
        
        r_ = 0.5 * (Sx2(x, y) + Sy2(x, y) - sqrt(4 * (SxSy(x, y) .^ 2) + (Sx2(x, y) - Sy2(x, y)) .^ 2));
        % E(x, y) = [x y] * [(Sx2(x, y) - r_) SxSy(x, y); SxSy(x, y) (Sy2(x, y) - r_)] * [x; y]; 
        r(x, y) = r_;   % amount of increase in direction x_
    end
end


% 4) Extract a sparse set of the M ?best? corner features.
% M = 100;
% D = 7;

corners = zeros(M, 3);
tmp = r;
for i = 1:M
    [x_max y_max] = find(tmp == max(max(tmp)));
    R_max = tmp(x_max, y_max);
    corners(i,:) = [y_max x_max R_max];
    for x = (x_max - D):(x_max + D)
        for y = (y_max - D):(y_max + D)
            if x > 0 & y > 0 & (((x - x_max)^2) + ((y - y_max)^2)) <= D
                tmp(x, y) = 0;
            end
        end
    end
end

% if D > 2
%     sze = 2 * D + 1;    % size of mask
%     mx = ordfilt2(r, sze ^ 2, ones(sze));   % Gray-scale dilate
%     Mbest = (r == mx) & (r > Threshold); % find the maxima
%     [Mbest_x Mbest_y] = find(Mbest);    % find the row, col coords
%     Mbest_size = length(Mbest_y);
%     Mbest_r = zeros(1, Mbest_size); % find the R value
%     for i = 1:Mbest_size
%         Mbest_r(i) = r(Mbest_x(i), Mbest_y(i));
%     end
%     Mbest = [Mbest_x, Mbest_y, Mbest_r'];
%     Mbest_r = sort(Mbest_r, 'descend');
%     if M > Mbest_size
%         M = Mbest_size;
%     end
%     Corners = zeros(M, 3);
%     for i = 1:M
%         [j tmp] = find(Mbest_r(i) == Mbest(:,3));
%         Corners(i,:) = Mbest(j,:);
%     end 
% end

% figure, imagesc(Image), axis image, colormap(gray), hold on
% plot(Corners(:,2), Corners(:,1), 'ys')

end