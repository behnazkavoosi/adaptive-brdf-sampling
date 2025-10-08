clear
clc

binPath = 'D:/Datasets/BRDF/EX_MERL_BINARY_Files/';

weight = load('./data/MERL_log-cos_weight.mat');
nan = load('./data/maskmap-grazing-nan-EPFL-DTUordering.mat');
load('./data/train_test_list-5set.mat');

num_trials = 5;
numBRDFs = 400;
num_clusters = [6, 7]; %[4, 5, 6];

th = 3;
rt = 4;

nlocation = 400;

for t = 1

    savePath = './sampling_res/';
    clPath = './clustering_res/';
    trPath = sprintf('%str_%i/', savePath, t);

    if exist(trPath, 'dir') == 0
        mkdir(trPath);
    end

    [numBRDFs, brdf_transformed, brdf_mean] = transformBRDF(binPath, trPath, weight, nan, train_names_cell(:, t), 2);

    nlocation = numBRDFs * 3;
    [U, S, V] = train(trPath, brdf_transformed, brdf_mean, nlocation, nan);

    for nc = num_clusters

        load(sprintf('%str_%d/HAClustering_%d.mat', clPath, t, nc));

        s = max_values_H;

        f_sp = 0;
        clear sp

        for i = 1:size(cluster_names_cell, 2)
            f_sp = f_sp + size(cluster_names_cell{1, i}, 1) * s(i);
        end

        f_sp = round(f_sp ./ numBRDFs); % weighted average for vanilla FROST

        rootDir = sprintf('%snzl', trPath);

        if exist(rootDir, 'dir') == 0
            mkdir(rootDir);
        end

        for i = 1:size(cluster_names_cell, 2)

            path = sprintf('%s/', rootDir);
            sp = s(i);

            samplingFile = sprintf('%snpca_%d.mat', path, sp);
            optimTime = mainOptimization(U, S, V, sp, sp, samplingFile);

        end


    end

end


