function Patches = GetPatches(Image, Corners, L)

[row col] = size(Image);
[M m] = size(Corners);
for i = 1:M
    Corner = Corners(i,:);
    x = Corner(2);
    y = Corner(1);
    Patche = zeros(2 * L + 1);
    for j = (x - L):(x + L)
        for k = (y - L):(y + L)
            if j > 0 & k > 0 & j < row & k < col
                Patche(j - x + L + 1, k - y + L + 1) = Image(j, k);
            end
        end
    end
    % rect = [(x - L) (y - L) (2 * L) (2 * L)];
    % Patche = imcrop(Image, rect);
    Patches{i} = Patche;
end

end