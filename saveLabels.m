clear
clc

clPath = './clustering_res/';
num_trials = 1;
nc = 2;

for t = 1:num_trials

    trPath = sprintf('%str_%i/', clPath, t);

    %     load(sprintf('%sclusters_thr_%.6f_rate_%.6f_nc_%i.mat', trPath, thr, rate, nc));
    load(sprintf('%sHAClustering_%d.mat', trPath, nc));

    csv_file = sprintf('%slabels_HA_nc_%i.csv', trPath, nc);
    fid = fopen(csv_file, 'w');

    for i = 1:nc

        for j = 1:size(cluster_names_cell{1, i}, 1)

            fprintf(fid, '%s,%s\n', cluster_names_cell{1, i}{j, 1}, num2str(i));

        end

    end

    fclose(fid);
end