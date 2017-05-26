function [h]=myline(x,y,varargin);


if isempty(varargin);
    eval('h=plot(mint(x),mint(y),''LineSmoothing'',''on'',''LineWidth'',3,''color'',''k'')');
else
    extra = [];
    for a = 1:length(varargin);
        if ischar(varargin{a})
            extra = [extra ',''' varargin{a} ''''];
        else
            extra = [extra ',[' num2str(varargin{a}) ']'];
        end
    end
    extra(end+1) = ')';
    eval(['h=plot(mint(x),mint(y),''LineSmoothing'',''on'',''LineWidth'',3,''color'',''k''' extra]);
end
        