%% import the visual vocabulary
    addpath('cell_imgs')
    load Centroidi_15M.mat
    k = size(C,1);
    l = 512; % dimension of the local descriptor (BRISK)
    l_prime = l; % dimensionality reduction
    threshold =     0.0290; % binarisation threshold
    query_idx = 1;
    %% import the BVLAD database
    load cell_db.mat % generare compute_cell.m
   

    %% query: extract BVLAD from the query
    fnames = dir('cell_imgs/*.jpg');
    fnames_query = dir('query_imgs/*.jpg');
    I_q = imread(strcat('query_imgs/',fnames_query(query_idx).name));
    I_q = rgb2gray(I_q);
    points = detectBRISKFeatures(I_q, 'MinContrast', 0.05, 'MinQuality', 0.05);
    [features, ~] = extractFeatures(I_q, points,'Method','BRISK');
    binary_features = BriskPoint2Binary(features);

    [b_q, F_q] = BVLAD(binary_features, C, l_prime, threshold);
    %{
    r = 3;

    top_r_indexes = zeros(1,r);
    top_r_indexes(1) = 1;
    top_r_scores = zeros(1,r);
    top_r_scores(1) = compute_score(b_q, bvlad_db(1,:), F_q, F_db(1,:), l_prime, k);
    for kk = 2:16
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
    
    figure
        I_retr_1 = imread(strcat('/cell_imgs/', fnames(top_r_indexes(1)).name));
        I_retr_1 = rgb2gray(I_retr_1);

        I_retr_2 = imread(strcat('/cell_imgs/', fnames(top_r_indexes(2)).name));
        I_retr_2 = rgb2gray(I_retr_2);

        I_retr_3 = imread(strcat('/cell_imgs/', fnames(top_r_indexes(3)).name));
        I_retr_3 = rgb2gray(I_retr_3);

        subplot(221), imshow(I_q), title(strcat('original image:',fnames(query_idx).name))
        subplot(222), imshow(I_retr_1), title('first')
        subplot(223), imshow(I_retr_2), title('second')
        subplot(224), imshow(I_retr_3), title('third')
    %}

    %top_r_scores = compute_score(b_q, bvlad_db(1,:), F_q, F_db(1,:), l_prime, k);
    top_r_scores = sum(xor(b_q,bvlad_db(1,:)));
    top_idx = 1;
    for kk = 2:15
        %f = compute_score(b_q, bvlad_db(kk,:), F_q, F_db(kk,:), l_prime, k);
        f = sum(xor(b_q,bvlad_db(kk,:)));
        if f < top_r_scores %prima era >
            top_r_scores = f;
            top_idx = kk;
        end
    end
    
    figure
    I_retr_1 = imread(strcat('/cell_imgs/', fnames(top_idx).name));
        I_retr_1 = rgb2gray(I_retr_1);
        
    subplot(211), imshow(I_q)
    subplot(212), imshow(I_retr_1)