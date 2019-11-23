function chns = wjn_tmsi_standard_channels(target)

if ~exist('target','var')
    target = 'LFP';
end

chns = [wjn_create_channels([target 'R'],1:8);...
    wjn_create_channels([target 'L'],1:8);...
    wjn_create_channels(['b' target],1:8);...
    {'Cz-Fz';'EMGR';'EMGL';'bip28';'Z';'Y';'X'};wjn_create_channels('empty',1:7)];