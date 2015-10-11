function [ b, F ] = BVLAD(X, C, l_prime, threshold)
%   This function extracts the BVLAD vector.
%
%   INPUT:
%       X: N by l (binary?) matrix s.t. each of the N rows contains one
%       l-dimensional local descriptor
%       C: the k by l matrix representing the visual vocabulary
%           (which contains k l-dimensional visual words)
%       l_prime: dimensionality reduction parameter
%       threshold: binarisation threshold
%
%   OUTPUT:
%       b: 1 by (l_prime x k) binary vector (image signature)
%       F: contains the indexes of the visual words observed in the image

    l = size(X,2);
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
            r_ii = r_ii + (C(ii,:) - neighbours(jj,:));
        end
        R(ii,:) = r_ii;
        F(ii) = 1;
    end

    

    %% apply a power law to the residuals & normalise each residual
    alpha = 0.8; % suggested value in the article
    R = sign(R).*(abs(R).^alpha);
    %R = R.^alpha;
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


    %% final normalisation & binarisation
    R = R/sqrt(k); % same as R/norm(R,2)
    R(R>threshold) = 1;
    R(R<threshold) = 0;
    b = logical(R); % BVLAD image signature
    F = logical(F);

end