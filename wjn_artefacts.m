function D = wjn_artefacts(filename,channels,trials,newfile)

 if ~exist('newfile','var') || isempty(newfile)
     if ~strcmp(filename(1),'a')
        newfile=1;
     else
         newfile =0;
     end
 end
 D=spm_eeg_load(filename);
 fname = D.fname;
 if newfile
 D=wjn_spm_copy(D.fullfile,['a' D.fname]);
 end
 if ~exist('channels','var') || isempty(channels)
     channels = D.chanlabels;
 elseif isnumeric(channels)
     channels = D.chanlabels(channels,channels,trials);
 elseif ischar(channels)
     channels = {channels};
 end
 

 
 chs = ci(channels,D.chanlabels);
 
  cht=unique(D.chantype(chs));
  chts = [];
  for a =1:length(chs)+length(cht)
      if a<=length(chs)
          chts{a} = chs(a);
          nchannels{a} = strrep(channels{a},'_',' ');
      else
        chts{a}=ci(cht{a-length(chs)},D.chantype,1);
        channels{a} = cht{a-length(chs)};
        nchannels{a} = strrep(channels{a},'_',' ');
      end
  end
 
 if ~exist('trials','var') || isempty(trials) || strcmp(trials,'all')
     trl = 1:D.ntrials;
     trials = D.conditions;
 elseif isnumeric(trials)
     trl = trials;
     trials = D.conditions(trl);
 else
      trl = ci(trials,D.conditions);
 end
 
 type = D.transformtype;
 
switch type
    case 'time';
 
figure
figone(length(chs)+5,30)
bt = D.badtrials;
art = zeros(size(trl));
if ~isempty(bt)
    art(bt)=1;
end
x=0;
n=1;
s=1;
msig = [];
while x==0
        t = trl(s);
     for c = 1:length(chts);
         if n
         sig = [];
         for d = 1:length(chts{c});
            sig(d,:) = squeeze(D(chts{c}(d),:,t)./max(abs(D(chts{c}(d),:,t)))-.1);
         end
         msig(c,:) = nanmean(sig,1)+c;
         end           
     end
      plot(D.time,msig)
         hold on
         if art(t)
             text(D.time(round(D.nsamples*.1)),length(chts)+.5,'BAD','color','r','FontSize',20)   
         end
%          keyboard
     set(gca,'YTick',1:length(chts),'YTickLabel',nchannels)
     ylim([0 length(chts)+1])
     xlabel('PST [s]')
     title([trials{t} ' N = ' num2str(t) ' BAD = ' num2str(art(t))])
     drawnow
     p = spm_input('Artefact?',.95,'b',{'bad','good','last','next','save','exit'},[1 0 -1 2 3 4]);
     hold off
     n=0;
     if p ==0 || p == 1
         art(t) = p;
         if p
             text(D.time(round(D.nsamples*.1)),length(chts)+.5,'BAD','color','r','FontSize',20)
             pause(.3)
         else
            text(D.time(round(D.nsamples*.1)),length(chts)+.5,'GOOD','color','g','FontSize',20)
             pause(.3)
         end
         if s<=length(trl)-1;
             s=s+1;
             n=1;
         end
     elseif p==-1 && s>=2;
         s=s-1;
         n=1;
     elseif p == 2 && s<=length(trl)-1;
         s=s+1;
         n=1;
     elseif p == 3
         save(D)
     elseif p == 4
         break
     end    
end

    case 'TF'
        
        
ns = [ceil(numel(chs)/3) 3];
cs = D.condlist;
for ics =1:length(cs);
figure
figone(length(chs)+15,30)
for c = length(chs):-1:1;
     subplot(ns(1),ns(2),c)
        tf = squeeze(nanmean(D(chs(c),:,:,D.indtrial(cs{ics})),4));
        f = D.frequencies;
        rtf = wjn_raw_baseline(tf,f);
        
     caxis([-50 50])
     imagesc(D.time,D.frequencies,rtf)
     axis xy
     if c==1
         title(cs{ics})
     end
     ylabel(strrep(D.chanlabels{chs(c)},'_',' '));
     ylim([3 97]);
     xlim([D.time(5) D.time(end-4)])
     if strcmp(fname(1),'r')
         caxis([-50 100])
     end
 end
end
        
figure
figone(length(chs)+15,30)
bt = D.badtrials;
art = zeros(size(trl));
if ~isempty(bt)
    art(bt)=1;
end
x=0;
n=1;
s=1;
msig = [];
while x==0
        t = trl(s);
     for c = length(chs):-1:1;
         subplot(ns(1),ns(2),c)
         
                 tf = squeeze(nanmean(D(chs(c),:,:,t),4));
        f = D.frequencies;
        rtf = wjn_raw_baseline(tf,f);
        imagesc(D.time,D.frequencies,rtf)
        axis xy
     caxis([min(min(rtf)) max(max(rtf))])
     colorbar
         axis xy
          ylim([3 97]);
%          title([trials{t} ' N = ' num2str(t) ' BAD = ' num2str(art(t))])
     if strcmp(fname(1),'r')
         caxis([-50 100])
     end         
ylabel(strrep(D.chanlabels{chs(c)},'_',' '));
         if c==1;
             ax = gca;
         end
          
     end
         if art(t)
             text(D.time(round(D.nsamples*.1)),length(chs)+.5,'BAD','color','r','FontSize',20)   
         end

     xlabel('PST [s]')
     title([trials{t} ' N = ' num2str(t) ' BAD = ' num2str(art(t))])
     drawnow
     p = spm_input('Artefact?',.95,'b',{'bad','good','last','next','save','exit'},[1 0 -1 2 3 4]);
     hold off
     n=0;
     if p ==0 || p == 1
         art(t) = p;
         if p
             text(D.time(round(D.nsamples*.1)),length(chts)+.5,'BAD','color','r','FontSize',20)
             pause(.3)
         else
            text(D.time(round(D.nsamples*.1)),length(chts)+.5,'GOOD','color','g','FontSize',20)
             pause(.3)
         end
         if s<=length(trl)-1;
             s=s+1;
             n=1;
         end
     elseif p==-1 && s>=2;
         s=s-1;
         n=1;
     elseif p == 2 && s<=length(trl)-1;
         s=s+1;
         n=1;
     elseif p == 3
         save(D)
     elseif p == 4
         break
     end    
end
        
        
        
end

close 
save(['artfile_' D.fname],'art','filename','channels','trl','trials')
D=badtrials(D,find(art),1);
save(D);
disp(['Bad trials:'])
D.badtrials'
save(D)

      
        