function warpedSrc = ForwardWarping(imSrc, imDest, H)

% detect the size of image
[srcnrows, srcncols, ~] = size(imSrc);
[destnrows, destncols, ~] = size(imDest);
warpedSrc = zeros(destnrows, destncols, 3);

for x = 1:srcncols
    for y = 1:srcnrows
        p = [x; y; 1];
        pprime = H * p;
        xprime = round(pprime(1) / pprime(3));
        yprime = round(pprime(2) / pprime(3));
        if xprime < 1 | xprime > destncols | yprime < 1 | yprime > destnrows
            continue;
        end
        warpedSrc(yprime, xprime, 1) = imSrc(y, x, 1);
        warpedSrc(yprime, xprime, 2) = imSrc(y, x, 2);
        warpedSrc(yprime, xprime, 3) = imSrc(y, x, 3);
    end
end

warpedSrc = uint8(warpedSrc);

end