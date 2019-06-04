function h = mypower(f,pow,color,measure,int)

if ~exist('pow','var')
    pow = f;
    f = 1:size(pow,2);
end

if ~exist('int','var')
    int = 1;
end

if size(f,2) ~= size(pow,2)
    pow = pow';
end
if ~exist('measure','var') || isempty(measure)
    measure = 'sem';
end
if ~exist('color','var') || isempty(color)
    color = [.05 .05 .05];
end

mpow = nanmean(pow,1);
% mpow = nanmedian(pow,1);
spow =  eval([measure '(pow)']);

if size(mpow,2) ~= size(spow,2) && strcmp(measure,'sem') && numel(spow)~=numel(mpow)
    spow = eval([measure '(pow)']);
elseif size(mpow,2) ~= size(spow,2) && strcmp(measure,'sem') 
    spow = spow';
end

if int && numel(f)<=1000 && numel(f)>=9
    warning('interpolating')
    h=myline(f,mpow,'color',color);
    hold on
    if strcmp(measure,'sem')
        ciplot(mint(mpow-spow),mint(mpow+spow),mint(f),color);
    else
        ciplot(mint(mpow-spow),mint(mpow+spow),mint(f),color);
    end
else
    warning('no interpolation')
    h=plot(f,mpow,'color',color,'linewidth',2);
    hold on
    if strcmp(measure,'sem')
        ciplot(mpow-spow,mpow+spow,f,color);
    else
        ciplot(mpow-spow,mpow+spow,f,color);
    end
end