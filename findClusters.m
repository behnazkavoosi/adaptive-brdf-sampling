close all
clear
clc

addpath('./clustering');
addpath('./clustering/lib');
addpath('./clustering/tool');
addpath('./clustering/SSC_ADMM_v1.1');

savePath = './clustering_res/';
path = 'D:/Datasets/BRDF/EX_MERL_BINARY_Files/';

load('./data/train_test_list-5set.mat');

num_clusters = 4; %2:1:7;

num_trials = 5;
th = 3;
rt = 4;

for t = 1

    for nc = num_clusters

        allClustersInfo(nc) = struct('indices', [], 'clusters', [], 'cluster_errors', [], 'cluster_pca', [], 'max_values_H', []);

        clear cluster_names_cell

        trPath = sprintf('%str_%d', savePath, t);

        load(sprintf('%s/err_mat.mat', trPath));

        dX = diff(err, 1, 1); % diff on each column
        ddX = diff(err, 2, 1); % second diff on each column

        indices = [];
        ert = 10.^(-rt);
        eth = 10.^(-th);

        for i = 1:size(err, 2)

            data = err( :,i);
            below_threshold_indices = find(data < eth);
            index = -1;

            % Check for the decreasing condition from each candidate index
            for k = 1:length(below_threshold_indices)

                candidate_index = below_threshold_indices(k);

                if all(abs(diff(data(candidate_index:end))) <= ert)

                    index = candidate_index;

                    break;
                end
            end

            indices = [indices; index];
        end

        % Hierarchical clustering
        culstering_folder = sprintf('HC_%d', nc);
        if isfolder(fullfile(trPath, culstering_folder))
            rmdir(fullfile(trPath, culstering_folder), 's')
        end
        mkdir(fullfile(trPath, culstering_folder))

        p = [indices, err'];


        standardizedData = zscore(p);

        for r = 10

            seedValue = 42;
            rng(seedValue);
            
            reducedData = tsne(standardizedData, 'NumDimensions', r);%10
            reducedData_2 = tsne(standardizedData, 'NumDimensions', 2);

            D = pdist(reducedData);
            Z = linkage(D, 'average');
            idx = cluster(Z, 'maxclust', nc);

            figure;
            hold on;
            colors = lines(nc); % Generates distinct colors for each cluster
            for i = 1:nc
                scatter(reducedData_2(idx == i, 1), reducedData_2(idx == i, 2), 10, colors(i, :), 'filled', 'DisplayName', ['Cluster ' num2str(i)]);
            end
            hold off;
            title(sprintf('Hierarchical Clustering Result (#components = %d)', size(reducedData, 2)));
            xlabel('Principal Component 1');
            ylabel('Principal Component 2');
            legend('show');

            filename = sprintf('%s/scatter_plot_%d.png', trPath, nc);
            saveas(gcf, filename);
        end

        clusters = cell(nc, 1);
        cluster_errors = cell(nc, 1);
        cluster_pca = cell(nc, 1);
        max_values_H = zeros(nc, 1);

        for k = 1:nc

            clusters{k} = find(idx == k);
            cluster_pca{k} = indices(clusters{k});
            max_values_H(k) = max(cluster_pca{k});

            cluster_errors{k} = err(:, clusters{k});

            clusterFoldername = sprintf('Hierarchical_cluster_%d', k);

            if isfolder(fullfile(trPath, culstering_folder, clusterFoldername) )
                rmdir(fullfile(trPath, culstering_folder, clusterFoldername), 's')
            end

            mkdir(fullfile(trPath, culstering_folder, clusterFoldername))

            for n=1:length(clusters{k})

                idxlist = clusters{k};

                cluster_names_cell{1, k}{n, 1} = train_names_cell{idxlist(n), t};
            end
        end
        %
        allClustersInfo(t).max_values_H = max_values_H;
        allClustersInfo(t).clusters = clusters;
        allClustersInfo(t).cluster_errors = cluster_errors;
        allClustersInfo(t).cluster_pca = cluster_pca;
        allClustersInfo(t).indices = indices;

        save(sprintf('%s/HAClustering_%d.mat', trPath, nc), 'cluster_names_cell', 'max_values_H', 'allClustersInfo');

    end
end


