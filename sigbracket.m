function sigbracket(tex,bars,y,FontSize)
% 
%    tex = e.g. '*' or '**' (default = '*')
%    bars  = e.g. bars that are significantly different (default = [1 2]) 
%    y =  height in plot (default = 'auto') 
%    FontSize...
%
%     '∞∞''.=+UJ_∞''∞∞''.'''.'''''''''._|?]_...'..
%     '',.[YÚ?TG:....................|kT??>_,....
%     ,..f!=Á>j|Ú?:_.∞''-∞∞'.'...._|UT!:]"f>.''..
%     ..-;.f@|"∞-"?++==_=______=|%TT!-|kJ=jfj''''
%     ...]..YG;.-.|#RRTkGUIIUUbBJ|U|=;f%G>f|;'...
%     ...]_-[#Á__ÁRJ>]|<YR##RAYTTYA@Á:=kGj-|?.''.
%     ''->j=<##UIT??!*!][TRBkY>[Ú?YTTT£#B|=<G ..'
%     ...J|+ARYRG;∞∞._"*!!TY?!?!j-∞∞*<RYRRG+G....
%     ..-bAT>|kG]--_-;j_*|[G?[]=;=__.-ÚG+IkR@....
%     '.%Ú?<kb@]__._=∞∞"f]<?;|]*∞f=___|YRRJ+Ú>..'
%     .f]:[Ib@G:Á+>[+= .f?[+|:j..|]!TG:[TIIU+?j..
%     .%|[Ák@G>k@?IÁG?+_f?[G[?--+%?ÁÁ[R@%bB@?<]..
%     .k>[@RbGIbB||RYk#]<]|@;Úfk#kÚÚ!!ÚRVbbBIk]..
%     -?Á[RbbbbARG:==f%><Á[@|?|YÚ;f;-.-<AAAb@<J,.
%     .?<%bRRRÚ??-""|]"f%Tk@TT]_f]-"__fÚ!"[R@Á] .
%     .fÚ?<G]j''∞∞__:;_f!?%G>;-*:|j ''∞∞'-f<J?-..
%     ..-?[Ú;,  ..'">|*-||<Ú?:=.*[]      _:<?∞  .
%     ...."!Ú:_.. . *- -ÁII+II+=.*-   ..=Ú?*,   .
%     ....,.∞"!?Ú+:=-  fKPPPPPWG,.:==|??*∞,     .
%     ''..,.....-*ÚY_ .-R#W####J..|T!"∞..,  .   .
%     .......''..,,.*_..fÚYTYY]..-*....'.........
%     ''''..,...''''.'∞"***!!*"""∞...........'...'
if ~exist('tex','var')
    tex='*';
end
if ~exist('bars','var')
    bars = [1,2];
end

lim=get(gca,'ylim');
if exist('y','var')
    lim(2) = y;
else
    y = lim(2)*1.2;
end

if ~exist('FontSize','var')
    FontSize=14;
end

hold on;
if numel(bars)>1
plot(bars,[lim(2),lim(2)],'color','k')
plot([bars(1) bars(1)],[lim(2)-0.02*lim(2) lim(2)],'color','k')
plot([bars(2) bars(2)],[lim(2)-0.02*lim(2) lim(2)],'color','k')
end
if strcmp(tex(1),'*')
%     keyboard
    if y>0
        t=text(mean(bars),lim(2)+0.015*lim(2),tex);
    else
        t=text(mean(bars),lim(2)+0.1*lim(2),tex);
    end
else
    if y>0
        t=text(mean(bars),lim(2)+FontSize/100*lim(2),tex);
    else
        t=text(mean(bars),lim(2)+0.1*FontSize/100*lim(2),tex);
    end
end
set(t,'FontSize',FontSize,'HorizontalAlignment','center')
try
    ylim([lim(1) lim(2)+0.2*lim(2)])
end

hold off;