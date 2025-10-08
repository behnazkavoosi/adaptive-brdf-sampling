%% Clustering and sample placement is done based on the BRDFs in the training set.
% Our classifier is then run to get cluster/sparsity predictions for BRDFs in testing
% test. This code reconstructs the BRDFs in testing set given the classifier's output.

clear
clc

binPath = 'D:/Datasets/BRDF/EX_MERL_BINARY_Files/';
weight = load('./data/MERL_log-cos_weight.mat');
nan = load('./data/maskmap-grazing-nan-EPFL-DTUordering.mat');
load('./data/train_test_list-5set.mat');
nang = load('./data/maskmap-grazing-DTUordering.mat');

num_trials = 5;
nlocation = 1200;
nc = 4; %[4, 5, 6];
mode = 2;
e = 40; 
th = 3;
rt = 4;

for t = 1:num_trials

    allMats = {};

    savePath = './recon_res/';
    clPath = './clustering_res/';
    trPath = sprintf('%str_%i/', savePath, t);

    allMats{2} = load(sprintf('%sBRDF_ref.mat', trPath));
    allMats{3} = load(sprintf('%sBRDF_mean.mat', trPath));
    allMats{4} = weight;
    allMats{5} = nan;
    load(sprintf('%sUSV_n%d.mat', trPath, nlocation));
    allMats{6} =  U * S;
    allMats{7} =  nang;

    clear U; clear S; clear V;

    path = sprintf('%snzl/', trPath);

    load(sprintf('%str_%d/predictions_nc_%d.mat', clPath, t, nc));
    load(sprintf('%str_%d/HAClustering_%d.mat', clPath, t, nc));

    s = max_values_H;

    numBrdfs = size(file_names, 2);

    dummy = file_names';

    clear log_rel; clear gamma_mse; clear lin_mse;


    for j = 1:numBrdfs

        filename = sprintf('%s%s.binary', binPath,  char(dummy(j)));

        [r, g, b] = readmerlbrdf(filename, 1);

        r = reshape2vec(r, 90*90*180);
        g = reshape2vec(g, 90*90*180);
        b = reshape2vec(b, 90*90*180);

        brdf_mat = cat(2, r, g, b);

        binDir = sprintf('%sbinary', path);

        if exist(binDir, 'dir') == 0
            mkdir(binDir);
        end

        npca = s(predictions(j));


        allMats{1} = load(sprintf('%snpca_%d.mat', path, npca));
        binFile = sprintf('%s/%s_npca_%d.binary', binDir, char(dummy(j)), npca);
        [log_rel(j, 1), gamma_mse(j, 1), lin_mse(j, 1)] = mainRecon(binFile, [], allMats, brdf_mat);


    end

    clEtDir = sprintf('%srecon_%d', trPath, nc);
    if exist(clEtDir, 'dir') == 0
        mkdir(clEtDir);
    end

    save(sprintf('%s/test_err.mat', clEtDir), 'log_rel', 'gamma_mse', 'lin_mse', '-v7.3');

end
