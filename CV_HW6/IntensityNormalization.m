function F = IntensityNormalization(patche)

mean_f = mean(patche(:));
std_f = std2(patche);
F = (patche - mean_f) / std_f;

end