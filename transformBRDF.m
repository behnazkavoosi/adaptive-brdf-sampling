%% paper03 : create transformed data from binary (for training)
function [numBrdfs, brdf_transformed, brdf_mean] = transformBRDF(path, savePath, weight, nan, train_names_cell, mode)

epsilon = single(0.001);
weight_matrix = weight.weight_matrix;
numBrdfs = size(train_names_cell, 1);
wm = single(reshape2vec(weight_matrix, 90*90*180));

if mode == 1  % clustering (MERL)- log-relative

    brdf_mat = zeros(90*90*180, numBrdfs);

    for i = 1:numBrdfs

        filename = sprintf('%s%s.binary', path,  char(train_names_cell(i)));

        [r, g, b] = readmerlbrdf(filename, 1);

        r(nan.gnmap3d) = 0.0;
        g(nan.gnmap3d) = 0.0;
        b(nan.gnmap3d) = 0.0;

        r = reshape2vec(r, 90*90*180);
        g = reshape2vec(g, 90*90*180);
        b = reshape2vec(b, 90*90*180);

        brdf_mat(:, i) = 0.2989 * r + 0.5870 * g + 0.1140 * b;
        i

    end

    brdf_ref = median(brdf_mat.*wm, 2);
    save(strcat(savePath, 'BRDF_ref.mat'), 'brdf_ref', 'epsilon');

    brdf_transformed = log( (brdf_mat.*wm + epsilon)./ (brdf_ref + epsilon) );
    save(strcat(savePath, 'BRDF_pca_data.mat'), 'brdf_transformed', 'epsilon', '-v7.3');

    brdf_mean = mean(brdf_transformed, 2);
    save(strcat(savePath, 'BRDF_mean.mat'), 'brdf_mean');

elseif mode == 2  % sampling (MERL)- log-relative

    brdf_mat = zeros(90*90*180, numBrdfs * 3);

    for i = 1:numBrdfs

        filename = sprintf('%s%s.binary', path,  char(train_names_cell(i)));

        [r, g, b] = readmerlbrdf(filename, 1);

        r(nan.gnmap3d) = 0.0;
        g(nan.gnmap3d) = 0.0;
        b(nan.gnmap3d) = 0.0;

        r = reshape2vec(r, 90*90*180);
        g = reshape2vec(g, 90*90*180);
        b = reshape2vec(b, 90*90*180);

        ind = (i - 1) * 3;

        brdf_mat(:, ind + 1) = r;
        brdf_mat(:, ind + 2) = g;
        brdf_mat(:, ind + 3) = b;
        i
    end

    brdf_ref = median(brdf_mat.*wm, 2);
    save(strcat(savePath, 'BRDF_ref.mat'), 'brdf_ref', 'epsilon');

    brdf_transformed = log( (brdf_mat.*wm + epsilon) ./ (brdf_ref + epsilon) );
    save(strcat(savePath, 'BRDF_pca_data.mat'), 'brdf_transformed', 'epsilon', '-v7.3');

    brdf_mean = mean(brdf_transformed, 2);
    save(strcat(savePath, 'BRDF_mean.mat'), 'brdf_mean');

end
