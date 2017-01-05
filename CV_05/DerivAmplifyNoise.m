clc

x = randn(10000,1); 
randn('state',sum(100*clock));
y = randn(10000,1);

fprintf('mean(x) = %f\n', mean(x));
fprintf('var(x) = %f\n', var(x));

fprintf('\nmean(y) = %f\n', mean(y));
fprintf('var(y) = %f\n', var(y));

fprintf('\nmean(x-y) = %f\n', mean(x-y));
fprintf('var(x-y) = %f\n', var(x-y));

figure; subplot(1,3,1); hist(x,100); axis([-7 7 0 400]); title('x');
subplot(1,3,2); hist(y,100); axis([-7 7 0 400]); title('y');
subplot(1,3,3); hist(x-y,100); axis([-7 7 0 400]); title('x-y');
