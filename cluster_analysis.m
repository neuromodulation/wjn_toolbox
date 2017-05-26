function [p, cluster_bin] = cluster_analysis(input,inputA, inputB, flag, one_vs_two_sided)
% input: matrix of size # subjects x # time points, already averaged across
% trials; either define "input", if there is only 1 group to be tested against 
% zero, or define both "inputA" and "inputB", if two groups are to be compared 
% against each other
% flag = 1 for single-group tests or repeated-measures tests (2 groups); flag = 2 for two independent
% groups;
% one_vs_two_sided = 1 for one-tailed and = 2 for two-tailed tests;
% for one-tailed tests, the condition with the higher hypothesized value
% has to be defined as inputA
% flag = 3 for trial permutation (disabled, since not yet debugged). matrix of size # subjects x # trials x #
% time points

if one_vs_two_sided == 1
    t_thresh = 1.64;
    %t_thresh = 1.28;
elseif one_vs_two_sided == 2
    t_thresh = 1.96;
    %t_thresh = 1.64;
end
nb_permuts = 10000; 


if flag == 1
    if isempty(input)
        input = inputA - inputB;
    end
    
    nb_subj = size(input,1);
    nb_comps = power(2,nb_subj);

    nb_greater = 0;
    [test_stat_orig, cluster_bin, IX_max_cluster, cluster, signed_bin_t_thresh] = test_stat(input, [], [], flag, t_thresh, one_vs_two_sided);
    
    for i = 1:nb_comps
        binp = ones(nb_subj,1);
        binp_part = -1 *round((dec2bin(i-1) == '1') -0.5);
        binp(nb_subj-numel(binp_part)+1:nb_subj) = binp_part;
        binp = repmat(binp,[1 size(input,2)]);

        [test_stat_perm, ~, ~, ~, ~] = test_stat(binp .* input,[],[],flag, t_thresh, one_vs_two_sided);
        nb_greater = nb_greater + (test_stat_perm > test_stat_orig);
    end;

    p = nb_greater/nb_comps;
    
elseif flag == 2
    input = [inputA; inputB];

    [diff_AB, cluster_bin, IX_max_cluster, cluster, signed_bin_t_thresh] = test_stat([], inputA, inputB, flag, t_thresh, one_vs_two_sided);
    n_A = size(inputA,1);
    n_B = size(inputB,1);
    n_tot = n_A + n_B;
    

    get_pot_resamps = nchoosek([1:size(input,1)],n_A);
    A_resamp = [];
    B_resamp = [];
    diff_AB_permut = [];
    for o = 1:nb_permuts
        j = ceil(rand(1,1)*size(get_pot_resamps,1));
        A_resamp(o,:,:) = input(get_pot_resamps(j,:),:);
        keep_B = [1:size(input,1)];
        for k = 1:size(A_resamp,2)
            deleteIX = min(find(keep_B == get_pot_resamps(j,k)));
            keep_B = [keep_B(1:deleteIX-1),keep_B(deleteIX+1:end)];
        end
        B_resamp(o,:,:) = input(keep_B,:);
        [diff_AB_permut(o), ~, ~, ~, ~] = test_stat([], squeeze(A_resamp(o,:,:)), squeeze(B_resamp(o,:,:)), flag, t_thresh, one_vs_two_sided);
    end
    diff_AB_permut = diff_AB_permut;

    p = length(find(diff_AB_permut >= diff_AB))/nb_permuts; %%% größer als, nicht größer gleich!!!!!


% elseif flag == 3
%     rand('twister',sum(100*clock))  
%     
%     diff_AB = test_stat([], squeeze(nanmean(inputA,2)), squeeze(nanmean(inputB,2)), flag, t_thresh, one_vs_two_sided)
%     
%     diff_AB_permut = [];
%     for o = 1:nb_permuts
%         r = 0;
%         
%         A_resamp = []; B_resamp = [];
%         for nbsubj = 1:length(find(isnan(inputA(:,1,1))==0))
%             
%             inputA_proc = inputA(nbsubj,:,:);
%             inputA_proc = inputA_proc(1,~isnan(inputA_proc(1,:,1)),:);
%             inputB_proc = inputB(nbsubj,:,:);
%             inputB_proc = inputB_proc(1,~isnan(inputB_proc(1,:,1)),:);
%             input_proc = cat(2,inputA_proc, inputB_proc);
%             n_A = size(inputA_proc,2);
%             n_B = size(inputB_proc,2);
%    
%             resamp = [];
%             while r < n_A
%                 pot_num = ceil(rand(1,1)*(n_A+n_B));
%                 if ~ismember(pot_num,resamp)
%                     resamp = [resamp, pot_num];
%                     r = r + 1;
%                 end
%             end
%             A_resamp(nbsubj,:) = squeeze(nanmean(input_proc(:,resamp,:),2));
%             keep_B = [1:n_A + n_B];
%             for k = 1:length(resamp)
%                 deleteIX = min(find(keep_B == resamp(k)));
%                 keep_B = [keep_B(1:deleteIX-1),keep_B(deleteIX+1:end)];
%             end
%             B_resamp(nbsubj,:) = squeeze(nanmean(input_proc(:,keep_B,:),2));
%         end
%         diff_AB_permut(o) = test_stat([], A_resamp, B_resamp, flag, t_thresh, one_vs_two_sided);
%         
%     end
% 
%     p = length(find(diff_AB_permut >= diff_AB))/nb_permuts; %%% größer als, nicht größer gleich!!!!!
%     p
end



%%
function [max_cluster, max_cluster_bin, IX_max_cluster, cluster, signed_bin_t_thresh] = test_stat(input, inputA, inputB, flag, t_thresh, one_vs_two_sided)
if flag == 1
    [~,~,~, stats] = ttest(input);
    tval = stats.tstat;
elseif flag == 2
    [~,~,~, stats] = ttest2(inputA,inputB);
    tval = stats.tstat;
elseif flag == 3
    [~,~,~, stats] = ttest(inputA-inputB);
    tval = stats.tstat;
end


if one_vs_two_sided == 1
    bin_t_thresh = tval > t_thresh;
elseif one_vs_two_sided == 2
    bin_t_thresh = abs(tval) > t_thresh;
end
cluster = [];
bin_t_thresh = bin_t_thresh;

signed_bin_t_thresh = bin_t_thresh.*sign(tval);
for i = 1:length(bin_t_thresh)
    if abs(signed_bin_t_thresh(i)) == 1
        if i == 1
            cluster(i) = 1;
        elseif and(signed_bin_t_thresh(i-1) ~= 0,signed_bin_t_thresh(i-1) == signed_bin_t_thresh(i))
             cluster(i) = cluster(i-1);
        elseif and(signed_bin_t_thresh(i-1) ~= 0,signed_bin_t_thresh(i-1) ~= signed_bin_t_thresh(i))
             cluster(i) = cluster(i-1) + 1;
        elseif signed_bin_t_thresh(i-1) == 0
            cluster(i) = max(cluster) + 1;
        end
    else
        cluster(i) = 0;
    end
end   

count_cluster = max(cluster);
sum_t_clusters = [];
for i = 1:count_cluster
    if one_vs_two_sided == 1
        sum_t_clusters(i) = nansum(tval(cluster==i));
        if sum_t_clusters(i) < 0
            sum_t_clusters(i) = 0;
        end
    elseif one_vs_two_sided == 2
        sum_t_clusters(i) = abs(nansum(tval(cluster==i)));
    end
end
[max_cluster, IX_max_cluster] = max(sum_t_clusters);

if ~isempty(IX_max_cluster)
    max_cluster_bin = cluster == IX_max_cluster;
else
    max_cluster_bin = zeros(size(cluster,1),size(cluster,2));
end
if isempty(max_cluster)
    max_cluster = 0;
end