% svdMat : training mat file.
% npca : number of samples we want.
% locationFile : '.mat' file

% optimTime : in seconds
% Q matrix is normalized before doing the SOMP optimization.
function [optimTime] = mainOptimization(U, S, V, npca, nlocation, samplingFile)


    % psuedo-inverse of Q is inv(S)*inv(U) = inv(S)*Ut
    Q = pinv(S(1:npca, 1:npca)) * U(:, 1:npca)';
    Vt = V.';
    Vt = Vt(1:npca, 1:npca);

    Q = NormalizeColumns(Q);
    disp('Q is normalized.');

    % doing optimization with SOMP
    disp('doing SOMP...');
    tStart = tic; 
    [nzl] = SOMPNS(Q, Vt, nlocation, []);
    tEnd = toc(tStart);
    optimTime = tEnd;
    disp('done SOMP...');

    % saving locations
    nzl = nzl';

    save(samplingFile, 'nzl', 'npca');
    disp('done saving locations ...');


end


