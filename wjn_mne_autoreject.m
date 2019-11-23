function D=wjn_mne_autoreject(filename)

D=spm_eeg_load(filename);

[outname,chans]= wjn_spm2mne(D.fullfile);
[fdir,ffile,ext]=fileparts(outname);

f=fopen(fullfile(getsystem,'autoreject.txt'),'w+');
fprintf(f,outname)
fclose(f)

command = ['python "' strrep(getsystem,'\','/') 'wjn_py_autoreject.py"'];
system(command) 

autoreject=load(fullfile(fdir,'autoreject.mat'));
rdata =autoreject.rdata;
cdata = autoreject.cdata;
autoreject=rmfield(autoreject,'rdata');
autoreject=rmfield(autoreject,'cdata');
trl_length = diff(autoreject.trl(1:2,1));
d=D(:,:,:);
autoreject.bad_samples=zeros(1,D.nsamples);
nc=0;
for a = 1:size(rdata,1)
    autoreject.sample_index(a,:) = [autoreject.trl(a,1)+1:autoreject.trl(a,1)+trl_length];
    if  ~autoreject.bad_epochs(a)
        nc=nc+1;
        d(chans,autoreject.sample_index(a,:))=cdata(nc,:,2:end);
        autoreject.cleaned_epochs(nc)=a;
    else
        d(chans,autoreject.sample_index(a,:))=rdata(a,:,2:end);
        autoreject.bad_samples(autoreject.sample_index(a,:))=1;
    end
 
end

nD=clone(D,fullfile(D.path,['ar_' D.fname]));
nD(:,:,1) = d(:,:);
nD.autoreject = autoreject;
save(nD);
D=nD;
delete(outname)
% delete('autoreject.mat')
