function h = myannotation(str)

if ischar(str)
    str={str};
end

l =length(str);
xl = l+2;
nl = 1+xl/10;
cf = gcf;
ca=gca;
pos = get(cf,'position');
apos = get(ca,'position');
napos = [apos(1) .95-apos(4)/nl  apos(3) apos(4)/nl];
bapos = [.05 .05  .9 apos(4)/nl-.3];
set(cf,'position',[pos(1:3) pos(4)*nl])
set(ca,'position',napos)

h=annotation('textbox',bapos,'String',str);