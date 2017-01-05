function foo = BackwardWarping_Interp2(imSrc, H)

% detect the size of image
imSrc_r = double(imSrc(:,:,1));
imSrc_g = double(imSrc(:,:,2));
imSrc_b = double(imSrc(:,:,3));

[destnrows, destncols, ~] = size(imSrc);
foo = zeros(destnrows, destncols, 3);

[xi yi] = meshgrid(1:destncols, 1:destnrows);
H = inv(H);
xx = (H(1, 1) * xi + H(1, 2) * yi + H(1, 3)) ./ (H(3, 1) * xi + H(3, 2) * yi + H(3, 3));
yy = (H(2, 1) * xi + H(2, 2) * yi + H(2, 3)) ./ (H(3, 1) * xi + H(3, 2) * yi + H(3, 3));
foo(:,:,1) = uint8(interp2(imSrc_r, xx, yy));
foo(:,:,2) = uint8(interp2(imSrc_g, xx, yy));
foo(:,:,3) = uint8(interp2(imSrc_b, xx, yy));

foo = uint8(foo);

end