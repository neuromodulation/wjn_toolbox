function h=fignum(n,l,ca,rs)
if ~exist('ca','var')
    ca=gca;
end


if ~exist('rs','var')

if ~isempty(n);
    rs = [ .4 -.3 +.05 -.05 -.1];
else
    rs = [.15 -.3 +.05 -.05 -.1];
end

end

x=get(ca,'Position');
s = get(gcf,'Position');
set(gcf,'Position',[s(1) s(2) s(3) s(4)+s(4)*rs(1)])
set(ca,'Position',[x(1) x(2)+.1 x(3) x(4)+rs(2)])
if ~isempty(n) && isnumeric(n) && n>=1;
h=annotation('textbox',[0.05 x(4)+rs(3) 0.1 0.1],'String',['Figure ' num2str(n)])
set(h,'FontSize',14,'FontWeight','bold','LineStyle','none')
elseif ~isempty(n) && ischar(n)
    h=annotation('textbox',[0.05 x(4)+rs(3) 0.1 0.1],'String',n)
set(h,'FontSize',14,'FontWeight','bold','LineStyle','none')
end

if exist('l','var') && ~isempty(l);
h=annotation('textbox',[x(1)+rs(5) x(4)+rs(4) 0.1 0.1],'String',l)
set(h,'FontSize',14,'LineStyle','none')
end
