
%subjects = {'SW', 'MW', 'JS', 'KB', 'LM', 'PB', 'JP', 'DS', 'WB', 'RP', 'JB', 'CP', 'JA', 'MC', 'JN', 'DF', 'DP'};
%subjects = {'OX01', 'OX02', 'OX04','OX06', 'OX08', 'OX09', 'OX13', 'OX14', 'OX15'};
%subjects = {'OX05'};
%subjects = {'OX03', 'OX07', 'OX11', 'OX12'};

subjects = {'PLFP11'};

band = [13 20];

banddir = sprintf('band_%d_%dHz', band);

clear matlabbatch;
matlabbatch{1}.spm.stats.results.spmmat = {'SPM.mat'};
matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.0001;
matlabbatch{1}.spm.stats.results.conspec.extent = 0;
matlabbatch{1}.spm.stats.results.conspec.mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.print = false;
matlabbatch{1}.spm.stats.results.write.none = 1;

aXYZ = [];
p = [];
for s = 1:numel(subjects)
    for on = 0:1
        try
            [files, seq, root, details] = dbs_subjects(subjects{s}, on);
        catch
            continue;
        end
        
        for c = 1:numel(details.chan)
            try
                cd(fullfile(root, 'SPMrest', banddir, details.chan{c}));
                
                if exist('SPM.mat', 'file')
                    spm_jobman('run', matlabbatch);
                    table = spm_list('List',evalin('base', 'xSPM'));                   
                    mXYZ = [];
                    for i = 1:size(table.dat, 1)
                        if ~isempty(table.dat{i, 6})
                            p = [p table.dat{i, 7}];
                            mXYZ = [mXYZ;table.dat{i, 12}'];
                        end
                    end
                    
                    
                    if isequal(details.chan{c}(5), 'L') && ~isempty(mXYZ)
                        mXYZ(:, 1) = -1* mXYZ(:, 1);
                    end
                    
                    aXYZ = [aXYZ; mXYZ];
                end
            end
        end
    end
end

%%
%q = fdr_correct_pvals(p, 0.01);

%sXYZ = aXYZ(q<0.01, :);

sXYZ = aXYZ;

Fgraph  = spm_figure('GetWin','Graphics'); figure(Fgraph); clf
iskull  = export(gifti(fullfile(spm('dir'), 'canonical', 'iskull_2562.surf.gii')), 'patch');
patch('vertices',iskull.vertices,'faces',iskull.faces,'EdgeColor','k','FaceColor','none');
hold on
plot3(sXYZ(:, 1), sXYZ(:, 2), sXYZ(:, 3), 'r.', 'MarkerSize', 20);
axis image off