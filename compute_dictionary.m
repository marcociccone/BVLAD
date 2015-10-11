clc
clear all
close all

fnames = dir('full_imgs/*.jpg');
numfids = length(fnames);
total_features = [];
h = waitbar(0, 'Computing...');
tic;
parfor k = 1:numfids
    
    I = imread(strcat('full_imgs/',fnames(k).name));
    I = rgb2gray(I);
    points = detectBRISKFeatures(I, 'MinContrast', 0.05, 'MinQuality', 0.05);
    %total_points = [total_points;points];
    %imshow(I); hold on;
    %plot(points.selectStrongest(20)); close
    [features, valid_points] = extractFeatures(I, points,'Method','BRISK');
    binary_features = BriskPoint2Binary(features);
    total_features = [total_features;binary_features];
    waitbar(k/numfids);
end
toc
close(h)

%[idx,C] = kmeans(total_features,64,'Distance','Hamming', 'MaxIter', 10,'Display', 'iter');

