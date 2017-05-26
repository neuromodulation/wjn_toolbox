function t = wjn_hms_start_matlab(mode)
if ~exist('mode','var')
    mode = 'short';
end


switch mode
    case 'short'
        t='plink.exe agh14@orchestra.med.harvard.edu -pw Skrebba$42 bsub -q short -W 12:0 -R "rusage[mem=8000]" -o /home/agh14/julian_last_job.out   -r matlab -nodisplay -singlecomThread -r ';
    case 'interactive'
        t='plink.exe agh14@orchestra.med.harvard.edu -pw Skrebba$42 bsub -q interactive matlab -nojvm -nodesktop';
end