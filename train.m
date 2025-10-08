%% Create a dictionary
function [U,S,V] = train(savePath, brdf_transformed, brdf_mean, nlocation, nan)


disp('doing pca...');
X = brdf_transformed - brdf_mean; % brdf_transformed = brdf_log_relative
X(nan.gnmapIds,:) = [];    % invalid angles
size(X)
[U,S,V] = svd(X, 'econ');

disp('done pca... saving data...');

save(sprintf('%sUSV_n%d.mat', savePath, nlocation), 'U', 'S', 'V', '-v7.3');
disp('done saving...');

end
