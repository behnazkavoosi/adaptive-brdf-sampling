clear
clc

load('paper03_data_ex-merl-epfl_set5_400train_57test_list.mat')
clPath = './data/clustering/merl-log_relative/wo-ga/exp_1/';

for t = 1:5
    
    trPath = sprintf('%str_%i/', clPath, t);

    train_filenames = train_names_cell(:, t);
    test_filenames = test_names_cell(:, t);

    save(sprintf('%strain_names.mat', trPath), 'train_filenames');  % not v7.3
    save(sprintf('%stest_names.mat', trPath), 'test_filenames');  % not v7.3

end