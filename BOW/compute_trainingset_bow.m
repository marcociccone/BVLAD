clc
clear
close all

load Centroidi_15M.mat
plot_figure = 0; % togliere parfor se questo è true per vedere immagine, BRISK e bow

fnames = dir('full_imgs/*.jpg');
numfids = length(fnames);

bow_db = zeros(numfids, size(C,1));
invalid_imgs = [];

h = waitbar(0, 'Computing...');
tic;
for k = 1:numfids
    k
    I = imread(strcat('full_imgs/',fnames(k).name));
    I = rgb2gray(I);
    points = detectBRISKFeatures(I);
    [features, valid_points] = extractFeatures(I, points, 'Method', 'BRISK');
    binary_features = BriskPoint2Binary(features);
    
    if isempty(valid_points) % per il soffitto non trova punti validi
        disp(fnames(k).name); % immagine problematica
        invalid_imgs = [invalid_imgs, k];
        continue % ignora quest'immagine
    end
    
    b = BOW(binary_features, C);
    
    if plot_figure == 1 
        subplot(211)
        imshow(I); hold on;
        plot(points.selectStrongest(20));
        subplot(212)
        bar(1:size(C,1), b), pause
    end
    bow_db(k,:) = b;
    waitbar(k/numfids);
end
toc
close(h)

save('bow_db.mat', 'bow_db')
