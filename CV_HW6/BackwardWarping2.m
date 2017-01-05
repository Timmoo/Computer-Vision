 function warpedSrc = BackwardWarping2(imSrc, imDest, H)

% detect the size of image
[srcnrows, srcncols, ~] = size(imSrc);
[destnrows, destncols, ~] = size(imDest);
warpedSrc = zeros(destnrows, destncols, 3);

for x = 1:destncols
    for y = 1:destnrows
        p = [x; y; 1];
        pprime = inv(H) * (p);
        
        % bilinear
        xprime = pprime(1) / pprime(3);
        yprime = pprime(2) / pprime(3);
        xf = floor(xprime);
        yf = floor(yprime);
        if xf < 1 | (xf + 1) > srcncols | yf < 1 | (yf + 1) > srcnrows
            continue;
        end
        a = xprime - xf;
        b = yprime - yf;
        warpedSrc(y, x, 1) = (1 - a) * (1 - b) * imSrc(yf, xf, 1) + a * (1 - b) * imSrc(yf, xf + 1, 1) + (1 - a) * b * imSrc(yf + 1, xf, 1) + a * b * imSrc(yf + 1, xf + 1, 1);
        warpedSrc(y, x, 2) = (1 - a) * (1 - b) * imSrc(yf, xf, 2) + a * (1 - b) * imSrc(yf, xf + 1, 2) + (1 - a) * b * imSrc(yf + 1, xf, 2) + a * b * imSrc(yf + 1, xf + 1, 2);
        warpedSrc(y, x, 3) = (1 - a) * (1 - b) * imSrc(yf, xf, 3) + a * (1 - b) * imSrc(yf, xf + 1, 3) + (1 - a) * b * imSrc(yf + 1, xf, 3) + a * b * imSrc(yf + 1, xf + 1, 3);
%         warpedSrc(y, x, 1) = (1 - a) * (1 - b) * imSrc(yf, xf, 1) + a * (1 - b) * imSrc(yf + 1, xf, 1) + (1 - a) * b * imSrc(yf, xf + 1, 1) + a * b * imSrc(yf + 1, xf + 1, 1);
%         warpedSrc(y, x, 2) = (1 - a) * (1 - b) * imSrc(yf, xf, 2) + a * (1 - b) * imSrc(yf + 1, xf, 2) + (1 - a) * b * imSrc(yf, xf + 1, 2) + a * b * imSrc(yf + 1, xf + 1, 2);
%         warpedSrc(y, x, 3) = (1 - a) * (1 - b) * imSrc(yf, xf, 3) + a * (1 - b) * imSrc(yf + 1, xf, 3) + (1 - a) * b * imSrc(yf, xf + 1, 3) + a * b * imSrc(yf + 1, xf + 1, 3);
    end
end

warpedSrc = uint8(warpedSrc);

end