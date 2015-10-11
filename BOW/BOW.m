function bow = BOW(X, C)
%   This function extracts the BOW vector.
%
%   INPUT:
%       X: N by l matrix s.t. each of the N rows contains one
%       l-dimensional local descriptor
%       C: the k by l matrix representing the visual vocabulary
%           (which contains k l-dimensional visual words)
%
%   OUTPUT:
%       bow: 1 by k vector (image signature)

    k = size(C,1); % number of visual words
    
    %% compute histogram
    idx = knnsearch(C,X);
    bow = zeros(1,k);
    for ii = 1:k
        neighbours = X(idx==ii,:); % nearest neighbours of c_ii
        bow(ii) = size(neighbours,1);
    end
    bow = bow / sum(bow); % normalisation

end