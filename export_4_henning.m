clear
root = fullfile(mdf,'visuomotor_tracking_ANA\MatLab Export')
cd(root)

load final_results_21022017.mat


PD = results.PD;
HC = results.healthy;
    
data = {'rt','mv','v','merror'};

