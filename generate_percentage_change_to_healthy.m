clear

root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export\');
cd(root)
lead16
load results
cc = colorlover(5);
cc = cc([1,3,5],:);

for a = 1:length(res.val)-1
    for c = 1:size(res.PD.(res.val{a}),2)
        for b = 1:2
            res.PD.(['ph' res.val{a}])(:,c,b) = 100.*((res.PD.(res.val{a})(:,c,b)./nanmean(res.healthy.(res.val{a})(:,c))));        
            if c<=7
                res.PD.(['phd' res.val{a}])(:,c,b) = 100*((res.PD.(['d' res.val{a}])(:,c,b)./nanmean(res.healthy.(['d' res.val{a}])(:,c))));
            end
        end   
    end
end

save results.mat res
figure
d=[res.PD.drt(:,1,1) res.PD.drt(:,1,2)];
mybar(d)
% ylim([0.9 5])

%% absolute difference

lead16
load results
cc = colorlover(5);
cc = cc([1,3,5],:);

for a = 1:length(res.val)-1
    for c = 1:size(res.PD.(res.val{a}),2)
        for b = 1:2
            res.PD.(['h' res.val{a}])(:,c,b) = res.PD.(res.val{a})(:,c,b)-nanmean(res.healthy.(res.val{a})(:,c));        
            if c<=7
                res.PD.(['hd' res.val{a}])(:,c,b) = res.PD.(['d' res.val{a}])(:,c,b)-nanmean(res.healthy.(['d' res.val{a}])(:,c));
            end
        end   
    end
end

% save results.mat res
figure
d=[res.PD.hrt(:,1,1) res.PD.hrt(:,1,2)];
mybar(d)
% ylim([0.9 5])