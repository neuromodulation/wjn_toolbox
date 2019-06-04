function [pct,d] = wjn_pct_change(off,on)


d=off-on;
pct = (d./off)*100;