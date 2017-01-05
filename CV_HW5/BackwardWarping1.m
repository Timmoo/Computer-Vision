 function warpedSrc = BackwardWarping1(imSrc, imDest, H)

% detect the size of image
[srcnrows, srcncols, ~] = size(imSrc);
[destnrows, destncols, ~] = size(imDest);
warpedSrc = zeros(destnrows, destncols, 3);

for x = 1:destncols
    for y = 1:destnrows
        p = [x; y; 1];
        pprime = inv(H) * (p);
        
        % nearest neighbor
        xprime = round(pprime(1) / pprime(3));
        yprime = round(pprime(2) / pprime(3));
        if xprime < 1 | xprime > srcncols | yprime < 1 | yprime > srcnrows
            continue;
        end
        warpedSrc(y, x, 1) = imSrc(yprime, xprime, 1);
        warpedSrc(y, x, 2) = imSrc(yprime, xprime, 2);
        warpedSrc(y, x, 3) = imSrc(yprime, xprime, 3);
              
    end
end

warpedSrc = uint8(warpedSrc);

end