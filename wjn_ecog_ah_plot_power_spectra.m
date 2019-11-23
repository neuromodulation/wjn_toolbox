clear

root = fullfile(mdf,'ecog');

cd(fullfile(root,'raw'))

files  = ffind('*.mat');
save ../files files

for a =6:length(files)
    keep a files root
    d = load(files{a},'signal','labels','CueStimulusTimes');
    i = round(d.CueStimulusTimes(1)*1200):round(d.CueStimulusTimes(end)*1200);
    ch = ci({'STN1','STN2','STN3'},d.labels);
    
    [peak.fft,peak.f]= wjn_raw_fft(d.signal(i,ch)',1200);
    
    figure
    plot(peak.f,peak.fft,'LineWidth',2)
    hold on
    xlim([5 35])
    
    for b = 1:size(peak.fft,1)
        [peak.STNpeak{b},peak.STNpeakfrequency{b}] = findpeaks(peak.fft(b,12:35),'MinPeakDistance',5);
        if isempty(peak.STNpeak{b})
            continue
        end
        peak.STNpeakfrequency{b} = peak.STNpeakfrequency{b}+10;
        [m,i]=max(peak.STNpeak{b});
        peak.STNpeaks(b,:) = [m peak.STNpeakfrequency{b}(i)];
        scatter(peak.STNpeakfrequency{b},peak.STNpeak{b})
    end
    
    [peak.sSTNpeakamp,peak.sSTNcontact] = max(peak.STNpeaks(:,1),[],1);
    peak.sSTNpeakfrequency = peak.STNpeaks(peak.sSTNcontact,2);
    scatter(peak.sSTNpeakfrequency,peak.sSTNpeakamp,'rsq','filled')
    peak.sSTN = d.labels(ch(peak.sSTNcontact));
    myprint(['../STNpeaks/' files{a}(1:end-4)])
    save(['../peak_' files{a}],'peak')
    
end