%% reconstruction for clustering: it reconstructs each BRDF with the number of prinicipal
% components ranging from 1 to maximum value and computes the reconstruction error.

% reconstruction : Q = US
function pc = recon_cluster(path, savePath, weight, nan, train_names_cell)

weight_matrix = weight.weight_matrix;
wm = reshape2vec(weight_matrix, 90*90*180);
epsilon = 0.001;
numTrainingBrdfs = size(train_names_cell, 1);

load(sprintf('%sUSV_n%d.mat', savePath, numTrainingBrdfs));

% principal components : Q = U*S
Q = U * S;
Vt = V.';


data_ref = load(sprintf('%sBRDF_ref.mat', savePath));
data_mean = load(sprintf('%sBRDF_mean.mat', savePath));
err = zeros(numTrainingBrdfs, numTrainingBrdfs);

for i = 1:numTrainingBrdfs

    k = 1;
    st1 = 10;
    st2 = 10;

    filename = sprintf('%s%s.binary', path,  char(train_names_cell(i)));

    [ro, go, bo] = readmerlbrdf(filename, 1);

    r = 0.2989 * ro + 0.5870 * go + 0.1140 * bo;

    r(nan.gnmap3d) = 0.0;

    r = reshape2vec(r, 90*90*180);

    % mapping data to log-relative
    rx = log( (r.*wm + data_ref.epsilon) ./ (data_ref.brdf_ref + data_ref.epsilon) );

    rx(nan.gnmapIds) = [];

    u = data_mean.brdf_mean;
    u(nan.gnmapIds) = [];

    % x - u
    r_x_u = rx - u;

    % solving c : ver1
    eta = 40;
    Qhat = Q;
    mse_s = 10;
    while (k <= numTrainingBrdfs && mse_s >= 1e-5)

        kcoef = k;
        recon_r = Q(:, 1:kcoef) * Vt(1:kcoef, :) + u;

        recon_brdf = ones(90*90*180, 1) * -1;

        recon_brdf(nan.gnmapnotIds) = recon_r(:, i);

        % inverse mapping of x
        recon_brdf = inverseMapping(recon_brdf, data_ref.brdf_ref, data_ref.epsilon, wm);

        recon_brdf(recon_brdf < 0) = 0.0;
        recon_brdf(nan.gnmapIds) = 0;

        refR = r;

        refR = r;
        residualR = abs(refR - recon_brdf);

        num = numel(refR);
        mse = sum(residualR(:).^2, 'omitnan') / num;
        linf = max(residualR(:)) / num;
        err(k, i) = mse;

        if k >= 20
            mse_s = mse;
        end

        k = k + 1;
    end
    pc(i, 1) = k - 1;

end

save(sprintf('%serr_mat.mat', savePath), 'pc', 'err', '-v7.3');

end





