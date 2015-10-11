function [ C ] = BriskPoint2Binary( features )

    f = features.Features;
    C = zeros(size(f,1), 512);
    if ~isempty(f) 
        bin_f = de2bi(f','left-msb'); %2816x8 = 64x8 X 44 features
        C = reshape(bin_f',512, []);
        C = double(C');
    end
end

