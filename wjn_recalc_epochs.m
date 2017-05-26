function rtrl = wjn_recalc_epochs(trl,fsample)

l = diff([trl(1,1) trl(1,2)]);
o = round(trl(1,3)*fsample);

for a = 1:size(trl,1);
    rtrl(a,:) = [round(trl(a,1)*fsample) round(trl(a,1)*fsample)+round(l*fsample) o];
end


