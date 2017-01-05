function [n_row n_col p_row p_col] = Resize(H, row, col)

n_row = 0;
n_col = 0;
p_row = row;
p_col = col;

p_o = [1; 1; 1];
p_lup = [1; row; 1];
p_rdown = [col; 1; 1];
p_rup = [col; row; 1];

p_o_prime = H * p_o;
p_lup_prime = H * p_lup;
p_rdown_prime = H * p_rdown;
p_rup_prime = H * p_rup;

x_o_prime = p_o_prime(1) / p_o_prime(3);
y_o_prime = p_o_prime(2) / p_o_prime(3);
x_lup_prime = p_lup_prime(1) / p_lup_prime(3);
y_lup_prime = p_lup_prime(2) / p_lup_prime(3);
x_rdown_prime = p_rdown_prime(1) / p_rdown_prime(3);
y_rdown_prime = p_rdown_prime(2) / p_rdown_prime(3);
x_rup_prime = p_rup_prime(1) / p_rup_prime(3);
y_rup_prime = p_rup_prime(2) / p_rup_prime(3);

x = [x_o_prime; x_lup_prime; x_rdown_prime; x_rup_prime];
y = [y_o_prime; y_lup_prime; y_rdown_prime; y_rup_prime];
min_x = min(x);
max_x = max(x);
min_y = min(y);
max_y = min(y);

if min_x < 0
    n_col = floor(min_x);
end

if max_x > p_col
    p_col = ceil(max_x);
end

if min_y < 0
    n_row = floor(min_y);
end

if max_y > p_row
    p_row = ceil(max_y);
end

end