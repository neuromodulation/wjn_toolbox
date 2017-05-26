% function wjn_cogent_start(screen_resolution,nscreen)

addcogent
if ~exist('screen_resolution','var')
    screen_resolution = 6;
end
if ~exist('nscreen','var')
    nscreen = 1;
end
cgopen(screen_resolution,16,0,nscreen);
cgpencol(0,0,0);
cgfont('Arial',40);
cgtext('+',0,0);
cgflip(1,1,1);