function pct = pctchange(off,on)

pct = (squeeze(off)-squeeze(on))./squeeze(off)*100;