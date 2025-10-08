clear all

dataMat = '../../data/clustering/merl-log_cos_plus/wo-ga/exp_7/tr_1/BRDF_pca_data.mat';

%%
load(dataMat);
X = brdf_transformed;
% clear brdf_mean epsilon

%normalize data
X = (X - min(X,[],1)) ./ (max(X,[],1) - min(X,[],1));

%% find subspaces
n = 8;
%SSC(X,n,r,affine,alpha,outlier,rho);
[grps, CMat] = SSC(X,n,0,0,800.0,0,1.0);
tmp = 0;

%% subspace dims
c = cell(n,1); 
s = cell(n,1); %subspace dims
for i = 1:max(grps)
    c{i} = CMat(:,grps==i);
    tmp = c{i};
    tmp(abs(tmp) > 0) = 1;
    s{i} = sum(tmp);
end