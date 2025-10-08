% sampledData size : [ nzl, 3 ]
function [log_rel, gamma_mse, lin_mse] = mainRecon(binFile, matFile, allMats, sampledData)


    % load up neccesary data
    sp = allMats{1};
    data_ref = allMats{2};
    data_mean = allMats{3};
    w = allMats{4};
    nanx = allMats{5};
    Q = allMats{6};
    nang = allMats{7};

    weight_matrix = w.weight_matrix;
    wm = reshape2vec(weight_matrix, 90*90*180);

    epsilon = data_ref.epsilon;

    r = sampledData(:, 1);
    g = sampledData(:, 2);
    b = sampledData(:, 3);

    rg = zeros(90*90*180, 1) ;
    gg = zeros(90*90*180, 1) ;
    bg = zeros(90*90*180, 1) ;

    rg(nang.grazingmapIds) = r(nang.grazingmapIds);
    gg(nang.grazingmapIds) = g(nang.grazingmapIds);
    bg(nang.grazingmapIds) = b(nang.grazingmapIds);

    r(nanx.gnmapIds) = 0;
    g(nanx.gnmapIds) = 0;
    b(nanx.gnmapIds) = 0;

    % log-relative mapping
    tr_r = log((r .* wm + epsilon) ./ (data_ref.brdf_ref + epsilon));
    tr_g = log((g .* wm + epsilon) ./ (data_ref.brdf_ref + epsilon));
    tr_b = log((b .* wm + epsilon) ./ (data_ref.brdf_ref + epsilon));

    tr_r(nanx.gnmapIds) = [];
    tr_g(nanx.gnmapIds) = [];
    tr_b(nanx.gnmapIds) = [];

    u = data_mean.brdf_mean;
    u(nanx.gnmapIds) = [];

    sp_r = tr_r - u;
    sp_g = tr_g - u;
    sp_b = tr_b - u;

    spr = sp_r(sp.nzl, :);
    spg = sp_g(sp.nzl, :);
    spb = sp_b(sp.nzl, :);

    %     eta = 40;
    Qhat = Q(sp.nzl, :);
    kcoef = size(spr, 1);
    [c_r, c_g, c_b] = solver_L2(Qhat, kcoef, spr, spg, spb, 40);

    % x = Q*c + mean

    recon_r = Q(:, 1:kcoef) * c_r + u;
    recon_g = Q(:, 1:kcoef) * c_g + u;
    recon_b = Q(:, 1:kcoef) * c_b + u;

    recon_rFull = recon_r;
    recon_gFull = recon_g;
    recon_bFull = recon_b;
    % assign values back to 90x90x180 resolutions.
    recon_rFull = ones(90*90*180, 1) ;
    recon_gFull = ones(90*90*180, 1) ;
    recon_bFull = ones(90*90*180, 1) ;

    recon_rFull(nanx.gnmapnotIds) = recon_r;
    recon_gFull(nanx.gnmapnotIds) = recon_g;
    recon_bFull(nanx.gnmapnotIds) = recon_b;

    refR = tr_r;
    refG = tr_g;
    refB = tr_b;
    residualR = abs(recon_r - refR);
    residualG = abs(recon_g - refG);
    residualB = abs(recon_b - refB);
    num = length(refR);

    log_rel = sum(residualR(:).^2 + residualG(:).^2 + residualB(:).^2, 'omitnan') / (3*num);

    % inverse mapping of x

    recon_rFull = inverseMapping(recon_rFull, data_ref.brdf_ref, epsilon, wm);
    recon_gFull = inverseMapping(recon_gFull, data_ref.brdf_ref, epsilon, wm);
    recon_bFull = inverseMapping(recon_bFull, data_ref.brdf_ref, epsilon, wm);

    recon_rFull(recon_rFull < 0) = 0.0;
    recon_gFull(recon_gFull < 0) = 0.0;
    recon_bFull(recon_bFull < 0) = 0.0;

    recon_rFull(nanx.gnmapIds) = 0;
    recon_gFull(nanx.gnmapIds) = 0;
    recon_bFull(nanx.gnmapIds) = 0;

    residualR = 0;
    residualG = 0;
    residualB = 0;

    refR = r;
    refG = g;
    refB = b;

    residualR = abs(recon_rFull - refR);
    residualG = abs(recon_gFull - refG);
    residualB = abs(recon_bFull - refB);
    num = numel(refR);

    lin_mse = sum(residualR(:).^2 + residualG(:).^2 + residualB(:).^2, 'omitnan') / (3*num);

    residualR_g = abs((recon_rFull).^(1/2) - (refR).^(1/2));
    residualG_g = abs((recon_gFull).^(1/2) - (refG).^(1/2));
    residualB_g = abs((recon_bFull).^(1/2) - (refB).^(1/2));
    num = numel(refR);

    gamma_mse = sum(residualR_g(:).^2 + residualG_g(:).^2 + residualB_g(:).^2, 'omitnan') / (3*num);

    recon_rFull(nang.grazingmapIds) = rg(nang.grazingmapIds);
    recon_gFull(nang.grazingmapIds) = gg(nang.grazingmapIds);
    recon_bFull(nang.grazingmapIds) = bg(nang.grazingmapIds);

    recon_rFull = reshape2merlwriter(recon_rFull);
    recon_gFull = reshape2merlwriter(recon_gFull);
    recon_bFull = reshape2merlwriter(recon_bFull);

end

