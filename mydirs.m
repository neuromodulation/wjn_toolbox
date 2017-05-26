function mydirs(dirname)
if exist('dirname','var')
    mkdir(dirname)
    cd(dirname)
end
mkdir scripts
mkdir odata
mkdir playground
mkdir results
cd('scripts')