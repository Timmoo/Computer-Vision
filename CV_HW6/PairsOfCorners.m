function Pairs = PairsOfCorners(Match, num, Corners1, Corners2, C)

Pairs = zeros(num, 5);  % x_Image1 y_Image1 x_Image2 y_Image2 c
for i = 1:num
    
    PP = Match{i};  % i-th Match Patches
    p1 = PP(1); % Patche of Image1
    p2 = PP(2); % Patche of Image1
    Pairs(i,:) = [Corners1(p1, 2) Corners1(p1, 1) Corners2(p2, 2) Corners2(p2, 1) C(p1, p2)];
    
end

end