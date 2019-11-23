function outname=wjn_dytrat_rereference(filename)

d = load(filename);

d=rmfield(d,'Keyboard');

fnames = fieldnames(d);

chans = {'EP','M1','M3','M13'};
vars = {'ei','m1i','m3i'};
ei=ci({'EP'},fnames);
m1i = ci('M_0',fnames);
m3i = ci('M_3',fnames);


for a = 1:length(vars)
    d.(fnames{eval(vars{a})}).title = chans{a};
end
d.M13 = d.(fnames{m1i});
d.M13.title = 'M13';
d.M13.values = d.(fnames{m1i}).values-d.(fnames{m3i}).values;

d=orderfields(d);
outname=['r_' filename];
save(outname,'-struct','d')