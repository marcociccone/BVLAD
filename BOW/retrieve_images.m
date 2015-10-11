function [ dist ] = retrieve_images( query_idx, verbose)
    %
    % r: how many pictures should be retrieved
    % dist: vector of r distances from the query
    


    %% import the visual vocabulary
    addpath('full_imgs')
    load Centroidi_15M.mat
    k = size(C,1);

    %% import the BVLAD database
    load bow_db.mat % generare con compute_trainingset_bvlad.m
    load map.mat

    %% query: extract BVLAD from the query
    fnames = dir('full_imgs/*.jpg');
    I_q = imread(strcat('full_imgs/',fnames(query_idx).name));
    I_q = rgb2gray(I_q);
    points = detectBRISKFeatures(I_q);
    [features, valid_points] = extractFeatures(I_q, points,'Method','BRISK');
    binary_features = BriskPoint2Binary(features);

    b_q = BOW(binary_features, C);

    %% compare the query with every image in the dataset
    
    r = 3;
    
    top_r_indexes = zeros(1,r);
    top_r_indexes(1) = 1;
    top_r_dist = ones(1,r)*Inf;
    top_r_dist(1) = norm(bow_db(query_idx,:) - bow_db(1,:), 2);
   
    for kk = 2:round(size(bow_db,1)*0.1)
        dist = norm(bow_db(query_idx,:) - bow_db(kk,:), 2);
        for rr = 1:r
            if dist < top_r_dist(rr) && kk ~= query_idx
                cur_ind = kk;
                for l = rr:r
                    aux_dist = top_r_dist(l);
                    aux_ind = top_r_indexes(l);
                    top_r_dist(l) = dist;
                    top_r_indexes(l) = cur_ind;
                    dist = aux_dist;
                    cur_ind = aux_ind;
                end
            end
        end
    end
    
    % compute distances
    
    coord_q = image_T(find(ismember(image_files,fnames(query_idx).name)));
    coord_q = coord_q{1,1};
    coord_q = [coord_q(1,4), coord_q(2,4)];
    coord_I1 = image_T(find(ismember(image_files,fnames(top_r_indexes(1)).name)));
    coord_I1 = coord_I1{1,1};
    coord_I1 = [coord_I1(1,4), coord_I1(2,4)];
    coord_I2 = image_T(find(ismember(image_files,fnames(top_r_indexes(2)).name)));
    coord_I2 = coord_I2{1,1};
    coord_I2 = [coord_I2(1,4), coord_I2(2,4)];
    coord_I3 = image_T(find(ismember(image_files,fnames(top_r_indexes(3)).name)));
    coord_I3 = coord_I3{1,1};
    coord_I3 = [coord_I3(1,4), coord_I3(2,4)];
    
    dist_I1 = norm(coord_q-coord_I1,2);
    dist_I2 = norm(coord_q-coord_I2,2);
    dist_I3 = norm(coord_q-coord_I3,2);
    
    
    % plot the top 3
    if verbose == 1
        figure
        I_retr_1 = imread(strcat('/full_imgs/', fnames(top_r_indexes(1)).name));
        I_retr_1 = rgb2gray(I_retr_1);

        I_retr_2 = imread(strcat('/full_imgs/', fnames(top_r_indexes(2)).name));
        I_retr_2 = rgb2gray(I_retr_2);

        I_retr_3 = imread(strcat('/full_imgs/', fnames(top_r_indexes(3)).name));
        I_retr_3 = rgb2gray(I_retr_3);

        subplot(221), imshow(I_q), title(strcat('original image:',fnames(query_idx).name))
        subplot(222), imshow(I_retr_1), title(strcat('first: ', fnames(top_r_indexes(1)).name, ...
            ' at ', num2str(dist_I1), 'm'))
        subplot(223), imshow(I_retr_2), title(strcat('second: ', fnames(top_r_indexes(2)).name, ...
            ' at ', num2str(dist_I2), 'm'))
        subplot(224), imshow(I_retr_3), title(strcat('third: ', fnames(top_r_indexes(3)).name, ...
            ' at ', num2str(dist_I3), 'm'))
    end
    
    dist = [dist_I1; dist_I2; dist_I3];
end

