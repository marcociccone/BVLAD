clear, clc, close all

tic
N = 50;
tot_images = round(1730*0.1);

invalid_imgs = [];

test_imgs = randi(tot_images,1,N);
fnames = dir('full_imgs/*.jpg');
load bow_db
for kk = 1:N
    if fnames(test_imgs(kk)).name(end-4) == '5' || ismember(test_imgs(kk), invalid_imgs)%% ceiling
        test_imgs(kk) = test_imgs(kk) + 2;
    end
end


distances = zeros(N,3);
at_least_one_correct_match = 0;
first_match = 0;
three_matches = 0;
for kk = 1:length(test_imgs)
    kk
    distances(kk,:) = retrieve_images(test_imgs(kk), 0);
    %pause
    flag = 0;
    for jj = 1:length(distances(kk,:))
        if distances(kk,jj) <= 5 && flag == 0
            at_least_one_correct_match = at_least_one_correct_match + 1;
            flag = 1;
        end
    end
    if distances(kk,1) <=5 && distances(kk,2) <= 5 && distances(kk,3) <= 5
        three_matches = three_matches + 1;
    end
    if distances(kk,1) <= 5
        first_match = first_match + 1;
    end
end

precision_or = at_least_one_correct_match / N
precision_at_1 = first_match / N
precision_at_3 = three_matches / N

toc