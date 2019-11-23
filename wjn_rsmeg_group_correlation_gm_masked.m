% function wjn_rsmeg_group_correlation(p,target)
clear all, close all,clc
root = wjn_rsmeg_list('root');
cd(root)
types = {'pearson','spearman'};
targets = {'STN','GPi'};
[~,leadt]=leadf;
mask = ea_load_nii(fullfile(leadt,'parcellations','greymatter_mask2mm.nii'));

freqbands = wjn_rsmeg_list('freqbands');
freqfolder = wjn_rsmeg_list('freqfolder');
for ty = 1:length(types)
for t = 1:length(targets)
    for nfreqs = 1:length(freqbands)
        p = wjn_rsmeg_list();
        n=1;
        ns=1;
        
        for a = 1:length(p)
            
            
            try
                if strcmp(p{a}.target,targets{t})
                    pairs = wjn_rsmeg_list(a,'rscohmappairs');
                    i = ci(freqfolder(nfreqs),pairs(:,1));
                    il = ci('LFP_L',pairs(i,1));
                    ir = ci('LFP_R',pairs(i,1));
                    clear scoh srs srscoh sr
                    for b = 1:length(i)
                        fnames(n,:) = pairs(i(b),1:2);
                        coh =wjn_read_nii(pairs{i(b),1});
                        rs = wjn_read_nii(pairs{i(b),2});
                        if ismember(b,il)
                            coh.img = flipud(coh.img);
                            rs.img = flipud(rs.img);
                        end
                        scoh(b,:)=coh.img(:).*mask.img(:);
                        ncoh(n,:) = coh.img(:).*mask.img(:);
                        srs(b,:) = rs.img(:).*mask.img(:);
                        nrs(n,:) = rs.img(:).*mask.img(:);
                        n =n+1;
                        nrscoh(n,:) = rs.img(:).*coh.img(:).*mask.img(:);
                        srscoh(b,:) = rs.img(:).*coh.img(:).*mask.img(:);
                        nr(n,1) = corr(rs.img(:).*mask.img(:),coh.img(:).*mask.img(:),'rows','pairwise','type',types{ty});
                        sr(b) = corr(rs.img(:).*mask.img(:),coh.img(:).*mask.img(:),'rows','pairwise','type',types{ty});
                    end
                    mcoh(ns,:)=nanmean(scoh(ir,:));
                    mrs(ns,:)=nanmean(srs(ir,:));
                    mrscoh(ns,:) = nanmean(srscoh(ir,:));
                    mr(ns,1) = nanmean(sr(ir));
                    ns=ns+1;
                    
                    mcoh(ns,:)=nanmean(scoh(il,:));
                    mrs(ns,:)=nanmean(srs(il,:));
                    mrscoh(ns,:)= nanmean(srscoh(il,:));
                    mr(ns,1) = nanmean(sr(il));
                    ns=ns+1;
                    
                end
            catch
                warning(['N = ' num2str(a)])
            end
            
        end
        
        
        figure
        mybar({nr mr})
        if signrank(nr)<=0.05
            sigbracket('*',1,.2)
        end
        if signrank(mr)<=0.05
            sigbracket('*',2,.2)
        end
        ylabel('Correlation coefficient')
        set(gca,'XTickLabel',{'N','M'})
        myprint([targets{t} '_' freqfolder{nfreqs} '_' types{ty}])
%         keyboard
       
        
%         imask = mask.img(:)==0;
%         nncoh = ncoh(:,imask);
        n = size(ncoh,2);
        clear r p
        for c = 1:n
            if mask.img(c)>0
            [r(c),p(c)]=corr(ncoh(:,c),nrs(:,c),'rows','pairwise','type',types{ty});
            else
                r(c)=nan;
                p(c) = nan;
            end
            if ismember(c,1:50000:n)
                disp([num2str(c) '/' num2str(n)])
            end
        end
%         keyboard
        nii =coh;
        nii.img(:) = r(:);
        nii.fname = ['nR_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = p(:);
        nii.fname = ['nP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = r(:).*(p(:)<=0.05);
        nii.fname = ['nRP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = r(:).*(p(:)<=0.001);
        nii.fname = ['nRPP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        
        nii.img(:) = nanmean(ncoh);
        nii.fname = ['nCOH_' targets{t} '_' freqfolder{nfreqs} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = nanmean(mcoh);
        nii.fname = ['mCOH_' targets{t} '_' freqfolder{nfreqs} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = nanmean(nrs);
        nii.fname = ['nRS_' targets{t} '_' freqfolder{nfreqs} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = nanmean(mrs);
        nii.fname = ['mRS_' targets{t} '_' freqfolder{nfreqs} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = nanmean(nrscoh);
        nii.fname = ['nRSCOH_' targets{t} '_' freqfolder{nfreqs} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = nanmean(mrscoh);
        nii.fname = ['mRSCOH_' targets{t} '_' freqfolder{nfreqs} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        
        
        
        n = size(mcoh,2);
        clear r p
        disp([num2str(ns) ' hemispheres in ' targets{t}])
        for c = 1:n       
            if mask.img(c)>0
                [r(c),p(c)]=corr(mcoh(:,c),mrs(:,c),'rows','pairwise','type',types{ty});
            else
                r(c)=nan;
                p(c) = nan;
            end
       
            if ismember(c,1:50000:n)
                disp([num2str(c) '/' num2str(n)])
            end
        end
        %
        nii =coh;
        nii.img(:) = r(:);
        nii.fname = ['mR_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = p(:);
        nii.fname = ['mP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty}  '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = r(:).*(p(:)<=0.05);
        nii.fname = ['mRP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        nii.img(:) = r(:).*(p(:)<=0.001);
        nii.fname = ['mRPP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_gm_masked.nii'];
        spm_write_vol(nii,nii.img);
        
        clear a c b
    end
end
end

