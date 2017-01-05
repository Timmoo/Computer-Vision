function C = NCC(Patche1, Patche2)

F1 = IntensityNormalization(Patche1);
F2 = IntensityNormalization(Patche2);
[x y] = size(Patche1);
N = x * y;
C = sum(sum(F1 .* F2)) / N;

end