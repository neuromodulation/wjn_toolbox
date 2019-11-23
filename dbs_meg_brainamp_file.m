function eegfile = dbs_meg_brainamp_file(megfile)

startind  = 0;
exception = 0;

if ~isempty(strfind(megfile, 'test_BrainampDBS_20140609_01.ds'))
    megpattern = 'test_BrainampDBS_20140609_';
    eegfile = 'test.vhdr';
    exception = 1;
    
end


if ~exception
    ind = strfind(megfile, megpattern);
    ind = str2num(megfile(ind+length(megpattern):(ind+length(megpattern)+1)));
    
    strind  = num2str(ind+startind);
    eegfile = [eegpattern repmat('0', 1, 4-length(strind)) strind '.vhdr'];
end

    