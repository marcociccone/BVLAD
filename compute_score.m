function [ f ] = compute_score(b_q, b_d, F_q, F_d, l_prime, k)

    f = 0;
    for kk = 1:k
        if F_q(kk) ~= 0 && F_d(kk) ~= 0
            sub_b_q = b_q(1 + (kk-1)*512: kk*512);
            sub_b_d = b_d(1 + (kk-1)*512: kk*512);
            f = f + (1 - sum(xor(sub_b_q,sub_b_d))/l_prime);
        end
    end
    
    f = 1/sqrt(sum(F_q ~= 0)*sum(F_d ~= 0)) * f;
end

