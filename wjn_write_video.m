function wjn_write_video(fname,frames,framerate)



vw=VideoWriter(fname,'MPEG-4');

if exist('framerate','var')
    vw.FrameRate=framerate;
end

vw.Quality = 100;
open(vw);
writeVideo(vw,frames);
close(vw);