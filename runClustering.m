clear all
clc

addpath('./clustering');
addpath('./clustering/lib');
addpath('./clustering/tool');
addpath('./clustering/SSC_ADMM_v1.1');

path = 'D:/Datasets/BRDF/EX_MERL_BINARY_Files/';

weight = load('./data/MERL_log-cos_weight.mat');
nan = load('./data/maskmap-grazing-nan-EPFL-DTUordering.mat');
load('./data/train_test_list-5set.mat');

num_trials = 5;

for t = 1:num_trials

    savePath = './clustering_res/';

    trPath = sprintf('%str_%i/', savePath, t);

    if exist(trPath, 'dir') == 0
        mkdir(trPath);
    end

    [nlocation, brdf_transformed, brdf_mean] = transformBRDF(path, trPath, weight, nan, train_names_cell(:, t), 1);

    train(trPath, brdf_transformed, brdf_mean, nlocation, nan);

    pc = recon_cluster(path, trPath, weight, nan, train_names_cell(:, t));

end
