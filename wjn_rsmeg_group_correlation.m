% function wjn_rsmeg_group_correlation(p,target)
clear all, close all,clc
root = wjn_rsmeg_list('root');
cd(root)
types = {'pearson','spearman'};
targets = {'STN','GPi','all'};
[~,leadt]=leadf;
cd(fullfile(root,'voxel_wise_correlation'))
freqbands = wjn_rsmeg_list('freqbands');
freqfolder = wjn_rsmeg_list('freqfolder');
flippo = {'bilateral','flipped_to_L'};
for ty = 1:length(types)
    for flippi = [2 1]
        for t = 1:length(targets)
            for nfreqs = 1:length(freqbands)
                p = wjn_rsmeg_list();
                n=1;
                ns=1;
                
                for a = 1:length(p)
                    
                    
                    try
                        if strcmp(p{a}.target,targets{t}) || strcmp(targets{t},'all')
                            pairs = wjn_rsmeg_list(a,'rscohmappairs');
                            i = ci(freqfolder(nfreqs),pairs(:,1));
                            il = ci('LFP_L',pairs(i,1));
                            ir = ci('LFP_R',pairs(i,1));
                            clear scoh srs srscoh sr
                            for b = 1:length(i)
                                fnames(n,:) = pairs(i(b),1:2);
                                coh =wjn_read_nii(pairs{i(b),1});
                                rs = wjn_read_nii(pairs{i(b),2});
                                if flippi-1
                                                        if ismember(b,ir)
                                                            coh.img = flipud(coh.img);
                                                            rs.img = flipud(rs.img);
                                                        end
                                end

                                scoh(b,:)=coh.img(:);
                                ncoh(n,:) = coh.img(:);
                                srs(b,:) = rs.img(:);
                                nrs(n,:) = rs.img(:);
                                n =n+1;
                                nrscoh(n,:) = rs.img(:).*coh.img(:);
                                srscoh(b,:) = rs.img(:).*coh.img(:);
                                nr(n,1) = corr(rs.img(:),coh.img(:),'rows','pairwise','type',types{ty});
                                sr(b) = corr(rs.img(:),coh.img(:),'rows','pairwise','type',types{ty});
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
                
                NN=ns;
                Ni=n;
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
                myprint([targets{t} '_' freqfolder{nfreqs} '_N' num2str(NN) '_Ni' num2str(Ni) '_' types{ty}])
                %         keyboard
                
                
                
                
                n = size(ncoh,2);
                clear r p
                for c = 1:n
                    
                    [r(c),p(c)]=corr(ncoh(:,c),nrs(:,c),'rows','pairwise','type',types{ty});
                    if ismember(c,1:50000:n)
                        disp([num2str(c) '/' num2str(n)])
                    end
                end
                %         keyboard
                nii =coh;
                nii.img(:) = r(:);
                nii.fname = ['nR_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = p(:);
                nii.fname = ['nP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = r(:).*(p(:)<=0.05);
                nii.fname = ['nRP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = r(:).*(p(:)<=0.001);
                nii.fname = ['nRPP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                
                nii.img(:) = nanmean(ncoh);
                nii.fname = ['nCOH_' targets{t} '_'  freqfolder{nfreqs} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = nanmean(mcoh);
                nii.fname = ['mCOH_' targets{t} '_'  freqfolder{nfreqs} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = nanmean(nrs);
                nii.fname = ['nRS_' targets{t} '_'  freqfolder{nfreqs} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = nanmean(mrs);
                nii.fname = ['mRS_' targets{t} '_'  freqfolder{nfreqs} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = nanmean(nrscoh);
                nii.fname = ['nRSCOH_' targets{t} '_'  freqfolder{nfreqs} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = nanmean(mrscoh);
                nii.fname = ['mRSCOH_' targets{t} '_'  freqfolder{nfreqs} '_N' num2str(Ni) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                
                
                
                n = size(mcoh,2);
                clear r p
                disp([num2str(ns) ' hemispheres in ' targets{t}])
                for c = 1:n
                    [r(c),p(c)]=corr(mcoh(:,c),mrs(:,c),'rows','pairwise','type',types{ty});
                    if ismember(c,1:50000:n)
                        disp([num2str(c) '/' num2str(n)])
                    end
                end
                %
                nii =coh;
                nii.img(:) = r(:);
                nii.fname = ['mR_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_N' num2str(NN) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = p(:);
                nii.fname = ['mP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_N' num2str(NN) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = r(:).*(p(:)<=0.05);
                nii.fname = ['mRP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_N' num2str(NN) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                nii.img(:) = r(:).*(p(:)<=0.001);
                nii.fname = ['mRPP_' targets{t} '_' freqfolder{nfreqs} '_' types{ty} '_N' num2str(NN) flippo{flippi} '.nii'];
                spm_write_vol(nii,nii.img);
                
                clear a c b
            end
        end
    end
end
