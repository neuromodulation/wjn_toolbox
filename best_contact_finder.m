function ind = best_contact_finder(f,data,lf,hf)
% function ind = best_contact_finder(f,data,lf,hf);
% data should be in format frequencies x contacts

lf = searchclosest(f,lf);
hf = searchclosest(f,hf);
mdata = mean(data(lf:hf,:),1);
[~,ind] = max(mdata);