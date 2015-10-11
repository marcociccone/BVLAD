clear all, close all, clc

% parameters%
%k = 64; % size of the visual vocabulary


%% import the visual vocabulary
load Centroidi.mat
k = size(C,1);

%% import the BOW database
load bow_db.mat % generato con compute_trainingset_bow.m


%% query: extract BOW from the query
fnames = dir('full_imgs/*.jpg');
query_idx = 15;
I_q = imread(strcat('full_imgs/',fnames(query_idx).name));
I_q = rgb2gray(I_q);
points = detectBRISKFeatures(I_q, 'MinContrast', 0.05, 'MinQuality', 0.05);
[features, valid_points] = extractFeatures(I_q, points,'Method','BRISK');
binary_features = BriskPoint2Binary(features);

b_q = BOW(binary_features, C);

%% compare the query with every image in the dataset

min_dist = norm(bow_db(query_idx,:) - bow_db(7,:), 2);
min_index = 1;

for kk = 1:size(bow_db,1)
    dist = norm(bow_db(query_idx,:) - bow_db(kk,:), 2);
    if dist < min_dist && kk ~= query_idx
        min_dist = dist;
        min_index = kk;
    end
end



fnames(min_index).name, dist

I_retr = imread(strcat('/full_imgs/', fnames(min_index).name));
I_retr = rgb2gray(I_retr);

subplot(121), imshow(I_q), title(fnames(query_idx).name)
subplot(122), imshow(I_retr), title(strcat('/full_imgs/', fnames(min_index).name))
