function [Match j] = CornersMatch(C)

threshold = 0.9;
[M N] = size(C); % M for Patches of Image1, N for Patches of Image2

M_max = zeros(1, M);    % Compute the best matches for each M
for i = 1:M
    tmp = C(i,:);
    [c y] = max(tmp);
    M_max(i) = y;
end

j = 0;
% Compute the best matches between M & N
for i = 1:N
    tmp = C(:,i);
    [c x] = max(tmp);
    if i == M_max(x) & c >= threshold
        j = j + 1;
        Match{j} = [x i];
    end
end

end