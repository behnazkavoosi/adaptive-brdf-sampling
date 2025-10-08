% read BRDF from MERL format
% input
% 1. filename (binary)
% 2. mode : 0 = allow negative values(default) / 1 = nan

function [ brdfR, brdfG, brdfB ] = readmerlbrdf( filename, mode)

BRDF_SAMPLING_RES_THETA_H    = 90;
BRDF_SAMPLING_RES_THETA_D    =  90;
BRDF_SAMPLING_RES_PHI_D      = 360/2;

redScale = 1.0/1500;
greenScale = 1.15/1500;
blueScale = 1.66/1500;

f = fopen(filename);

dims = fread(f,  3, 'int');

n = dims(1)* dims(2) * dims(3);
if (n ~= BRDF_SAMPLING_RES_THETA_H * BRDF_SAMPLING_RES_THETA_D * BRDF_SAMPLING_RES_PHI_D)
    error('wrong dimensions of material');
    fclose(f);
end

tmpR = fread(f,n,'double');
tmpG = fread(f,n,'double');
tmpB = fread(f,n,'double');

brdfR = zeros(90, 90, 180);
brdfG = zeros(90, 90, 180);
brdfB = zeros(90, 90, 180);
for th = 0:89
    for td = 0:89
        for pd = 0:179
            id = pd + td*180 + th*180*90;
            id = id+1;

            brdfR(th+1, td+1, pd+1) = tmpR(id) * redScale;
            brdfG(th+1, td+1, pd+1) = tmpG(id) * greenScale;
            brdfB(th+1, td+1, pd+1) = tmpB(id) * blueScale;

            if mode == 1
                if brdfR(th+1, td+1, pd+1) < 0.0
                    brdfR(th+1, td+1, pd+1) = NaN;
                end
                if brdfG(th+1, td+1, pd+1) < 0.0
                    brdfG(th+1, td+1, pd+1) = NaN;
                end
                if brdfB(th+1, td+1, pd+1) < 0.0
                    brdfB(th+1, td+1, pd+1) = NaN;
                end
            end
        end
    end
end

fclose(f);
end

