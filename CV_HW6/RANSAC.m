function Best_Fit = RANSAC(Pairs, s, N, d, T)

num = size(Pairs, 1);
Best_Fit = [];
Best_t = 0;

for i = 1:N
    r = randperm(num, s);   % draw a sample of s points from the data uniformly and at random
    h = GetHomography(Pairs(r, 2), Pairs(r, 1), Pairs(r, 4), Pairs(r, 3), s);   % fit to that set of s points
    
    Fit = [];
    t = 0;
    
    for j = 1:num
        if ~ismember(j, r)
            p = [Pairs(j, 2); Pairs(j, 1); 1];
            pprime = h * p; % forward warping
            xprime = pprime(1) / pprime(3);
            yprime = pprime(2) / pprime(3);
            dist = sqrt(((xprime - Pairs(j, 4)) ^ 2) + ((yprime - Pairs(j, 3)) ^ 2));   % distance between the predict point to the real point
            % test the distance from the point to the line against d if the
            % distance from the point to the line is less than d the point
            % is close
            if dist <= d
                t = t + 1;
                Fit = [Fit; Pairs(j,:)];
            end
        end
    end
    
    % if there are T or more points close to the line then there is a good
    % fit. use the best fit from this collection.
    if t >= T & t > Best_t
        Best_t = t;
        Best_Fit = [Fit; Pairs(r,:)];
    end
    
end

end