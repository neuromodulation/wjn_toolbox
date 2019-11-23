function wjn_meg_vm_source_localisation(filename,baseline)

sk=[12 12 12];
timeranges = [-1000 0; 0 1000;-1000 1000];
freqranges = [2 7;7 13;13 20;20 35;13 35;40 80];
D=spm_eeg_load(filename);
wjn_meg_source_power(D.fullfile,freqranges,baseline,'go','baseline','dics')
wjn_meg_source_power(D.fullfile,freqranges,timeranges,'move','move','dics')

fname = D.fname;

sname = stringsplit(fname,'spmeeg');
sname = sname{2}(1:end-4);



for c = 1:size(freqranges,1)
    bmean = wjn_nii_smooth(ffind(['mean*' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '*baseline*' sname '.nii'],0),sk);
    baut = wjn_nii_smooth(ffind(['go_aut*' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '*baseline*' sname '.nii'],0),sk);
    bcon = wjn_nii_smooth(ffind(['go_con*' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '*baseline*' sname '.nii'],0),sk);
   
    for b = 1:size(timeranges,1)
           mmean = wjn_nii_smooth(ffind(['mean*' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '*' num2str(timeranges(b,1)) '-' num2str(timeranges(b,2)) '*move*' sname '.nii'],0),sk);
           maut = wjn_nii_smooth(ffind(['move_aut*' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '*' num2str(timeranges(b,1)) '-' num2str(timeranges(b,2)) '*move*' sname '.nii'],0),sk);
           mcon = wjn_nii_smooth(ffind(['move_con*' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '*' num2str(timeranges(b,1)) '-' num2str(timeranges(b,2)) '*move*' sname '.nii'],0),sk);
           
           wjn_nii_diff(mmean,bmean,['m_mean_' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '_' num2str(timeranges(b,1)) '-' num2str(timeranges(b,2)) sname '_corrected.nii']);
           aut=wjn_nii_diff(maut,baut,['m_move_aut_' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '_' num2str(timeranges(b,1)) '-' num2str(timeranges(b,2)) sname '_corrected.nii']);
           con=wjn_nii_diff(mcon,bcon,['m_move_con_' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '_' num2str(timeranges(b,1)) '-' num2str(timeranges(b,2)) sname '_corrected.nii']);
           wjn_nii_diff(mcon,maut,['m_move_con-aut_' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '_' num2str(timeranges(b,1)) '-' num2str(timeranges(b,2)) sname '.nii']);
           wjn_nii_diff(con,aut,['m_move_con-aut_' num2str(freqranges(c,1)) '-' num2str(freqranges(c,2)) '_' num2str(timeranges(b,1)) '-' num2str(timeranges(b,2)) sname '_corrected.nii']);
    end
end
          
mkdir('source_localisation')
movefile('m_*.nii','source_localisation','f')
mkdir('source_images')
movefile('*dics*.nii','source_images','f')

