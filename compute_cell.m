clear all
close all

load Centroidi_15M.mat
plot_figure = 0; % togliere parfor se questo è true per vedere immagine, BRISK e bow

fnames = dir('cell_imgs/*.jpg');
numfids = length(fnames);
%threshold = 0.0290;
threshold = 0.0071;


bvlad_db = false(numfids,size(C,1)*512);
F_db = zeros(numfids,size(C,1));

h = waitbar(0, 'Computing...');
tic;
parfor k = 1:round(numfids)
    I = imread(strcat('cell_imgs/',fnames(k).name));
    I = rgb2gray(I);
    points = detectBRISKFeatures(I);%, 'MinContrast', 0.05, 'MinQuality', 0.05);
    [features, valid_points] = extractFeatures(I, points,'Method','BRISK');
    binary_features = BriskPoint2Binary(features);
    
    if isempty(valid_points) % per il soffitto non trova punti validi
        disp(fnames(k).name); % immagine problematica
        continue % ignora quest'immagine
    end
    
    [b, F] = BVLAD(binary_features, C, 512, threshold);
    
   
    
    bvlad_db(k,:) = b;
    F_db(k,:) = F;
    waitbar(k/numfids);
end
toc
close(h)

% save as logical!

save('cell_db.mat', 'bvlad_db', 'F_db')
%save('bvlad_db.mat', 'bvlad_db')