function wjn_gifti2mat(filename)

s=export(gifti(filename));

[dir,file,ext]=fileparts(filename);

save(fullfile(dir,[file '.mat']),'-struct','s')