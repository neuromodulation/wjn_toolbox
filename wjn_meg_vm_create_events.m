function D=wjn_meg_vm_create_events(filename)

D=spm_eeg_load(filename);
t=D.time;
d = round(1000.*D(157,:,1));

% vals = [-52 -42 -32 27 37 47] ;
vals = [-48 -38 -28 31 41 51];
nd = zeros(size(d));
for a = 1:length(vals)
%     i = find();
    nd(d>=(vals(a)-4.9)&d<=(vals(a)+4.9))=vals(a);
end

go_aut = mydiff(nd==vals(1))==1;
go_con = mydiff(nd==vals(4))==1;
move_aut = mydiff(nd==vals(1))==-1;
move_con = mydiff(nd==vals(4))==-1;
stop_aut = mydiff(nd==vals(3))==1;
stop_con = mydiff(nd==vals(6))==1;



figure,
plot(D.time,go_aut),hold on,
plot(D.time,move_aut)
plot(D.time,stop_aut)
plot(D.time,go_con)
plot(D.time,move_con)
plot(D.time,stop_con)
legend('go','move','stop')
plot(D.time,nd./100),plot(D.time,abs(D(159,:,1))+abs(D(160,:,1)))


igo_aut = find(go_aut);
igo_con = find(go_con);
imove_aut = find(move_aut);
imove_con = find(move_con);
istop_aut = find(stop_aut);
istop_con = find(stop_con);


trl = [];
conditionlabels = [];
for a =1:length(igo_aut)
    icm = imove_aut(imove_aut>igo_aut(a));
    im=wjn_sc(icm,igo_aut(a));
    d = icm(im)-igo_aut(a);
    if d<3*D.fsample
        ics = istop_aut(istop_aut>icm(im));
        is=wjn_sc(ics,icm(im));
        d = ics(is)-icm(im);
        if d<6*D.fsample
            trl = [trl;igo_aut(a);icm(im);ics(is)];
            conditionlabels=[conditionlabels {'go_aut','move_aut','stop_aut'}];
        end
    end
end

l = length(trl);
plot(t(trl),ones(size(trl)),'g*')


for a =1:length(igo_con)
    icm = imove_con(imove_con>igo_con(a));
    im=wjn_sc(icm,igo_con(a));
    d = icm(im)-igo_con(a);
    if d<2*D.fsample
        ics = istop_con(istop_con>icm(im));
        is=wjn_sc(ics,icm(im));
        d = ics(is)-icm(im);
        if d<6*D.fsample
            trl = [trl;igo_con(a);icm(im);ics(is)];
            conditionlabels=[conditionlabels {'go_con','move_con','stop_con'}];
        end
    end
end

plot(t(trl(l+1:end)),ones(size(trl(l+1:end))),'r*')

[trl,i]=sort(trl);

conditionlabels = conditionlabels(i);

D=chanlabels(D,159,'X');
D=chanlabels(D,160,'Y');
D=chanlabels(D,157,'trigger');


D.itrl = trl;
D.trl = trl./D.fsample;
D.conditionlabels = conditionlabels;
save(D)


