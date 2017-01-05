function h1 = GetHomography1(x1, y1, x2, y2, N)

% assume h33 = 1, h = A \ b
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

end