function fentferner
%Entfernt alle f's in allen Textdateien im Ordner.


str1 = 'f';
str2 = '';
txtfiles = cellstr(ls('*.txt'));

for a = 1:length(txtfiles);
    infile = txtfiles{a};
    outfile = txtfiles{a};



% in case of single characters, escape special characters 
% (at least someof them)
switch str1
    case {'\' '.'}
        str1 = ['\' str1];
end


%% The PERL stuff
perlCmd = sprintf('"%s"',fullfile(matlabroot, 'sys\perl\win32\bin\perl'));
perlstr = sprintf('%s -i.bak -pe"s/%s/%s/g" "%s"', perlCmd, str1, str2,infile);

[s,msg] = dos(perlstr);

%% rename files if outputfile given
if ~isempty(msg)
    error(msg)
else
    if nargin > 3 % rename files
        if strcmp('-nobak',outfile)
            delete(sprintf('%s.bak',infile));
        else
            movefile(infile, outfile);
            movefile(sprintf('%s.bak',infile), infile);
        end
    end
end
end
