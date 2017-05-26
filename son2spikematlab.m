function son2spikematlab(filename)
if ~exist('filename','var');
    [filename,path] = uigetfile('*.smr');
    cd(path);
end

if ~strcmp(filename(length(filename)-2:length(filename)),'smr');
    fid = fopen([filename '.smr']);
    
else
    fid = fopen(filename)
    filename = filename(1:length(filename)-4);
end
SONImport(fid);
close all;
sonmat = load(filename);
pause(5);
movefile([filename '.mat'],['son_' filename '.mat'],'f');
pause(5);
names = fieldnames(sonmat);
for a = 1:length(names);
    sizemax(a)=max(size(sonmat.(names{a})));
end
maxlength = max(sizemax);
nchannels = sonmat.FileInfo.channels;


for a = 1:nchannels;
    if isfield(sonmat,['head' num2str(a)])
    kind = eval(['sonmat.head' num2str(a) '.kind']);
    varname = strrep(eval(['sonmat.head' num2str(a) '.title']),' ','_');
        if kind == 1 && strcmp(varname,'dummy') == 0;
            if exist('Fs','var') == 0;
                Fs=eval('sonmat.head1.sampleinterval');
            end
            
        values = eval(['sonmat.chan' num2str(a)]);
        if length(values) < maxlength;
            values(length(values)+1:maxlength)=0;
        end
        channel.values = double(values);
        channel.title = varname;
        channel.comment = 'son2spikematlab';
        channel.interval = 1/Fs;
        channel.length = length(channel.values);
        channel.units = 'V';
        channel.offset = 0;
        channel.start = 0;
        channel.times(:,1) = linspace(0,channel.length/Fs,channel.length);
      

        x.(channel.title) = channel;
        clear channel values varname
        end
    end
end
pause(5);
save(filename,'-struct','x');