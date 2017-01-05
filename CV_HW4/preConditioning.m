function [x y T S] = preConditioning(x, y, rows, cols, N)

% Get the central point
centx = mean(x);
centy = mean(y);

% Translation
tx = (cols / 2) - centx;
ty = (rows / 2) - centy;
T = [1 0 tx; 0 1 ty; 0 0 1];
for i = 1:N
    tmp = T * [x(i); y(i); 1];
    x(i) = tmp(1);
    y(i) = tmp(2);
end

% Get average points distance
sum_dist = 0;
num_edges = 0;
for i = 1:N
    for j = (i + 1):N
        num_edges = num_edges + 1;
        edge = sqrt((x(i) - x(j)) ^ 2 + (y(i) - y(j)) ^ 2); % distance between (x(i), y(i)) and (x(j), y(j))
        sum_dist = sum_dist + edge;
    end
end
aver_dist = sum_dist / num_edges;

% Scale
s = sqrt(2) / aver_dist;
S = [s 0 0; 0 s 0; 0 0 1];
for i = 1:N
    tmp = S * [x(i); y(i); 1];
    x(i) = tmp(1);
    y(i) = tmp(2);
end

end