
color1 = color_converter([242,109,113]);
color2 = color_converter([179,232,141]);
color3 = color_converter([244,224,156]);
color4 = color_converter([237,244,235]);

root = 'C:\Vim_meg\';mkdir(fullfile(root,'images'))
patients = {'LN04','LN12','LN14','LN16','LN17','LN19','LN20'};
conditions = {'Rest','Tremor'}
kind = {'native','headloc'}
cd(root);
xlswrite(fullfile(root,'global_maxima.xls'),{'ID','condition','LFP Channel','Alpha','Anatomy','Beta','Anatomy'},1,'A1');
can = 'C:\SPM12\canonical\single_subj_T1.nii'
cd images\
n=1;
for a = 1:length(patients);
    load(fullfile(root,patients{a},['meg_prep_' patients{a}]),'lfpchans','tfile');
    for c = 1:length(conditions);
        for b  = 1:length(lfpchans);
        
            for k=1%:length(kind);
                n=n+1;
        [~,tfile,~]=fileparts(tfile);
        imga = fullfile(root,patients{a},conditions{c},'source_coherence',kind{k},...
        [lfpchans{b} '_7_13'],['smdics_refcoh_' tfile '.nii']);
        imgb = fullfile(root,patients{a},conditions{c},'source_coherence',kind{k},...
        [lfpchans{b} '_15_30'],['smdics_refcoh_' tfile '.nii']);
        t1 = spm_vol_nifti(imga);
        [dat, xyz] = spm_read_vols(t1);
        [unused, mxind] = max(dat(:));
        gma= xyz(:, mxind);
        t2 = spm_vol_nifti(imgb);
        [dat, xyz] = spm_read_vols(t2);
        [unused, mxind] = max(dat(:));
        gmb= xyz(:, mxind);
        blabel=get_mni_anatomy(gmb);
        alabel=get_mni_anatomy(gma);
        spm_orthviews('reset')
        spm_check_registration(can);
        spm_orthviews('reposition', gma);
        spm_orthviews('addcolouredimage',1,imgb,color1)
%         spm_orthviews('redraw');
        spm_orthviews('addcolouredimage',1,imga,color2)    
  
        spm_orthviews('redraw');
        stringtitle = [patients{a} ' ' lfpchans{b}];
        stringa = [' Alpha: ' num2str(gma') ' mm'];
        stringb = [' Beta: ' num2str(gmb') ' mm'];
        an=annotation('textbox',[0.2 0.9 0.5 0.1],'String',{stringtitle,conditions{c},stringa,stringb,kind{k}},'LineStyle','none');
        myfont(an);
        H = annotation('textbox',[0.53 0.4 0.45 0.1],'STring',{['Current location ' num2str(gma') 'mm'], 'Global Maximum for Alpha Coherence',alabel});
        set(H,'FontSize',9,'FitHeightToText','on'); myfont(H);set(H,'Fontsize',11);set(H,'EdgeColor','none','linestyle','none')
        set(an,'Fontsize',16,'EdgeColor','none','HorizontalAlignment','center','FitHeightToText','on')
        spm_orthviews('XHairs','on')
        set(gca,'color','k')
        myprint([conditions{c} '_' patients{a} '_' lfpchans{b} '_' kind{k} '_Alpha']);
        set(H,'String',[])
        set(H,'STring',{['Current location ' num2str(gmb') 'mm'], 'Global Maximum for Beta Coherence',blabel});
        set(H,'FontSize',9,'FitHeightToText','on'); myfont(H);set(H,'Fontsize',11);set(H,'EdgeColor','none','linestyle','none')
        set(an,'Fontsize',16,'EdgeColor','none','HorizontalAlignment','center','FitHeightToText','on')
        spm_orthviews('XHairs','on')
        set(gca,'color','k') 
        spm_orthviews('reposition', gmb);
        spm_orthviews('redraw');
        myprint([conditions{c} '_' patients{a} '_' lfpchans{b} '_' kind{k} '_Beta']);

         set(H,'String',[])
        set(H,'STring',['Current location: Center']);
        set(H,'FontSize',9,'FitHeightToText','on'); myfont(H);set(H,'Fontsize',11);set(H,'EdgeColor','none','linestyle','none')
        set(an,'Fontsize',16,'EdgeColor','none','HorizontalAlignment','center','FitHeightToText','on')
        spm_orthviews('XHairs','on')
        spm_orthviews('reposition', [0 0 0]');
        spm_orthviews('redraw');
        myprint([conditions{c} '_' patients{a} '_' lfpchans{b} '_' kind{k} '_Center']);
        close all;spm_orthviews('reset')    
        xlswrite(fullfile(root,'global_maxima.xls'),{patients{a},conditions{c},lfpchans{b},num2str(gma'),alabel,num2str(gmb'),blabel},1,['A' num2str(n)]);
            end
        end
    end
end