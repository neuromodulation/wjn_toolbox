function wjn_hms_job(mcommand,mode)
if ~exist('mode','var')
    mode = 'short';
end

mf = getsystem;
ml = wjn_hms_start_matlab(mode);
job = mcommand;
dos(fullfile(mf,[ml job]));