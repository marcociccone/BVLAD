function retrieve_cell( query_idx)
    %
    % r: how many pictures should be retrieved
    % dist: vector of r distances from the query
    % verbose: 1 if you want to show images
    
    % parameters
    l = 512; % dimension of the local descriptor (BRISK)
    l_prime = l; % dimensionality reduction
    %threshold = 0.0290; % binarisation threshold
    threshold = 0.0071;


    %% import the visual vocabulary
    addpath('cell_imgs')
    load Centroidi_15M.mat
    k = size(C,1);

    %% import the BVLAD database
    load cell_db.mat % generare con compute_trainingset_bvlad.m
 

    %% query: extract BVLAD from the query
    fnames = dir('cell_imgs/*.jpg');
    I_q = imread(strcat('cell_imgs/',fnames(query_idx).name));
    I_q = rgb2gray(I_q);
    points = detectBRISKFeatures(I_q);%, 'MinContrast', 0.05, 'MinQuality', 0.05);
    [features, ~] = extractFeatures(I_q, points,'Method','BRISK');
    binary_features = BriskPoint2Binary(features);

    [b_q, F_q] = BVLAD(binary_features, C, l_prime, threshold);

    %% compare the query with every image in the dataset

    %{
    min_dist = sum(xor(bvlad_db(1,:),b_q));
    min_index = 1;
    for kk = 2:size(bvlad_db,1)
        dist = sum(xor(bvlad_db(kk,:),b_q)); % hamming distance
        if dist < min_dist && kk ~= query_idx
            min_dist = dist;
            min_index = kk;
        end
    end



    fnames(min_index).name %, f_max

    I_retr = imread(strcat('/full_imgs/', fnames(min_index).name));
    I_retr = rgb2gray(I_retr);

    subplot(121), imshow(I_q), title(fnames(query_idx).name)
    subplot(122), imshow(I_retr), title(strcat('/full_imgs/', fnames(min_index).name))
    
    %}
    %{
    f_max = compute_score(b_q, bvlad_db(1,:), F_q, F_db(1,:), l_prime, k);
    index_max = 1;
    for kk = 2:size(bvlad_db,1)*0.1
        f = compute_score(b_q, bvlad_db(kk,:), F_q, F_db(kk,:), l_prime, k);
        if f > f_max && kk ~= query_idx
            f_max = f;
            index_max = kk;
            I_retr = imread(strcat('/full_imgs/', fnames(index_max).name));
            I_retr = rgb2gray(I_retr);
            subplot(121), imshow(I_q), title(fnames(query_idx).name)
            subplot(122), imshow(I_retr), title(strcat('/full_imgs/', fnames(index_max).name))
            pause
        end
    end


    fnames(index_max).name, f_max

    I_retr = imread(strcat('/full_imgs/', fnames(index_max).name));
    I_retr = rgb2gray(I_retr);

    subplot(121), imshow(I_q), title(fnames(query_idx).name)
    subplot(122), imshow(I_retr), title(strcat('/full_imgs/', fnames(index_max).name))

    %}
    
    r = 3;

    top_r_indexes = zeros(1,r);
    top_r_indexes(1) = 1;
    top_r_scores = zeros(1,r);
    top_r_scores(1) = compute_score(b_q, bvlad_db(1,:), F_q, F_db(1,:), l_prime, k);
    %for kk = 2:size(bvlad_db,1)
    for kk = 2:size(bvlad_db,1)
        f = compute_score(b_q, bvlad_db(kk,:), F_q, F_db(kk,:), l_prime, k);
        for rr = 1:r
            if f > top_r_scores(rr) && kk ~= query_idx
                cur_ind = kk;
                for l = rr:r
                    aux_f = top_r_scores(l);
                    aux_ind = top_r_indexes(l);
                    top_r_scores(l) = f;
                    top_r_indexes(l) = cur_ind;
                    f = aux_f;
                    cur_ind = aux_ind;
                end
            end
        end
    end
    
    clear bvlad_db
  
    
    
    
    figure
    I_retr_1 = imread(strcat('/cell_imgs/', fnames(top_r_indexes(1)).name));
    I_retr_1 = rgb2gray(I_retr_1);

    I_retr_2 = imread(strcat('/cell_imgs/', fnames(top_r_indexes(2)).name));
    I_retr_2 = rgb2gray(I_retr_2);

    I_retr_3 = imread(strcat('/cell_imgs/', fnames(top_r_indexes(3)).name));
    I_retr_3 = rgb2gray(I_retr_3);

    subplot(221), imshow(I_q), title(strcat('original image:',fnames(query_idx).name))
    subplot(222), imshow(I_retr_1), title(strcat('first: ', fnames(top_r_indexes(1)).name))
    subplot(223), imshow(I_retr_2), title(strcat('second: ', fnames(top_r_indexes(2)).name))
    subplot(224), imshow(I_retr_3), title(strcat('third: ', fnames(top_r_indexes(3)).name))

    
end

