clear, clc, close all

tic
N = 150;
%tot_images = 1733;
tot_images = 3756;
%tot_images = 276; % stop after analyzing one room

test_imgs = randi(tot_images,1,N);
fnames = dir('full_imgs/*.jpg');
for kk = 1:N
    if fnames(test_imgs(kk)).name(end-4) == '5' %% ceiling
        test_imgs(kk) = test_imgs(kk) + 2;
    end
end
r = 3;
distances = zeros(N,r);
at_least_one_correct_match = 0;
first_match = 0;
three_matches = 0;
parfor kk = 1:length(test_imgs)
    kk
    test = retrieve_images(test_imgs(kk), 0);
    flag = 0;
    for jj = 1:r
        if test(jj) <= 5 && flag == 0
            at_least_one_correct_match = at_least_one_correct_match + 1;
            flag = 1;
        end
    end
    if test(1) <=5 && test(2) <=5 && test(3) <=5
        three_matches = three_matches + 1;
    end
    if test(1) <= 5
        first_match = first_match + 1;
    end
    distances(kk,:) = test;
end

precision_or = at_least_one_correct_match / N
precision_at_1 = first_match / N
precision_at_3 = three_matches / N

toc