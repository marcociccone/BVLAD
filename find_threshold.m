clear, clc, close all

N = 300;
tot_images = 1733;
test_imgs = randi(tot_images,1,N);

load Centroidi.mat
k = size(C,1); 
l_prime = 512;
fnames = dir('cell_imgs/*.jpg');
bvlads = zeros(size(fnames,1),512*256);

for kk = 1:size(fnames,1)
    kk
    I = imread(strcat('cell_imgs/',fnames(kk).name));
    I = rgb2gray(I);
    points = detectBRISKFeatures(I);%, 'MinContrast', 0.05, 'MinQuality', 0.05);
    [features, valid_points] = extractFeatures(I, points,'Method','BRISK');
    X = BriskPoint2Binary(features);
    
    if isempty(valid_points) % per il soffitto non trova punti validi
        disp(fnames(kk).name); % immagine problematica
        continue % ignora quest'immagine
    end
    
    l = 512;
    k = size(C,1); % number of visual words
    
    %% compute the residual for each visual word c_i wrt to the vectors belonging to it

    % the rows of R contain the l-dimensional residual relative to each
    % centroid c_i (i=1, 2, ..., k)
    R = zeros(k,l);
    F = zeros(1,k);

    % compute the k residuals
    idx = knnsearch(C,X);
    % finds the nearest neighbours for each centroid in C
    for ii = 1:k
        if ~any(idx == ii)
            % if this image doesn't contain the ii-th visual word, skip
            continue
        end
        neighbours = X(idx==ii,:); % nearest neighbours of c_ii
        r_ii = zeros(1,l);
        for jj = 1:size(neighbours,1)
            r_ii = r_ii + abs(C(ii,:) - neighbours(jj,:));
        end
        R(ii,:) = r_ii;
        F(ii) = 1;
    end

    

    %% apply a power law to the residuals & normalise each residual

    alpha = 0.8; % suggested value in the article
    R = sign(R).*(abs(R).^alpha);

    for ii = 1:k
        if norm(R(ii,:),2) ~= 0
            R(ii,:) = R(ii,:)/norm(R(ii,:),2);
        end
        % avoid normalising vectors with norm = 0
    end


    %% principal component analysis (PCA) (not necessary)
    %{
    % http://infolab.stanford.edu/~ullman/mmds/ch11.pdf
    % obtain column-wise zero empirical mean (along l)
    for ii = 1:l
        R(:,ii) = R(:,ii) - mean(R(:,ii));
    end
    
    [U,S,V] = svd(R);
    
    V = V';
    R = U*S(:,1:l_prime)*V(1:l_prime,:);

    %}
    %% concatenate the residuals to a row vector
    R = reshape(R,1,k*l_prime);
    
    bvlads(kk,:) = R;
end

mean2(bvlads)