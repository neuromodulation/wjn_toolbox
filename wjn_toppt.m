function wjn_toppt(filename,pos,slide,figure1,cl,op)
% wjn_toppt(filename,pos,slide,figure1)

if ~exist('cl','var')
    cl=1;
end

if ~exist('op','var')
    op=1;
end

if ~exist('pos','var') || isempty(pos)
    pos = 'M';
elseif isnumeric(pos) 
    npos = {'NWH','NEH','SWH','SEH'};
    pos = npos{pos};
end

size=get(figure1,'Position');
size(1:2)=[];
size=size.*(500/size(1));

if ~exist('slide','var')
    slide = 'current';
end

if ~exist('figure1','var')
    figure1 = gcf;
end

if ~exist(fullfile(getsystem,'toPPT'),'dir')
    warning('TOPPT TB not in path!')
else
    addpath(genpath(fullfile(getsystem,'toPPT')))
end

[sp,sf] = fileparts(filename);
if isempty(sp)
    sp = cd;
else
    sp = [sp '\'];
end

if op
    if exist(fullfile(sp,[sf '.pptx']),'file')
        toPPT('openExisting',fullfile(sp,[sf '.pptx']))
    else
        warning('New PPTX file')
        toPPT('openExisting',fullfile(mf,['toPPT.pptx']))
    end
end

toPPT('setTitle',strrep(sf,'_',' '),'SlideNumber',slide)
toPPT(figure1,'pos',pos,'Width',size(1),'Height',size(2),'SlideNumber',slide)
pause(2)


pause(2)
if cl
    toPPT('savePath',sp,'saveFilename',sf)
%     toPPT('close',1)
end