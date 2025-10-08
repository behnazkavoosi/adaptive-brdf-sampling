function [estimatedSupp] = SOMPNS(Phi, Y, s, S)

[~, n] = size(Phi);
K = size(Y, 2);
% x = zeros(n, K);   
% x_ls = zeros(s, K); 
R = Y;
estimatedSupp = zeros([1 s]); 

for z=1:s
    correlationsMatrix = R.'*Phi;

    if (K ~= 1)
        correlationsVector = sum(abs(correlationsMatrix));
    else % If K=1
        correlationsVector = abs(correlationsMatrix);
    end

    [~, kt] = max(abs(correlationsVector));

    estimatedSupp(z) = kt;
    estimatedSupp(1:z) = sort(estimatedSupp(1:z));

%     buf = Phi(:, estimatedSupp(1:z));
%     x_ls = (buf\Y);
%     x(estimatedSupp(1:z),:) = x_ls(1:z,:);
%     R = Y - buf*x_ls;
    R = Y - Phi(:, estimatedSupp(1:z)) * pinv(Phi(:, estimatedSupp(1:z))) * Y;
end

end
