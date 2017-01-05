function h2 = GetHomography(x1, y1, x2, y2, N)

% assume ||h|| = 1, use the eigen-decomposition and singular value decomposition
A2 = zeros(2 * N, 9);
for i = 1:N
    A2(2 * i - 1,:) = [x1(i) y1(i) 1 0 0 0 (-x1(i) * x2(i)) (-y1(i) * x2(i)) (-x2(i))];
    A2(2 * i,:) = [0 0 0 x1(i) y1(i) 1 (-x1(i) * y2(i)) (-y1(i) * y2(i)) (-y2(i))];
end
[V, D] = eig(A2' * A2);
h2 = V(:,1);
h2 = [h2(1) h2(2) h2(3); h2(4) h2(5) h2(6); h2(7) h2(8) h2(9)];

end