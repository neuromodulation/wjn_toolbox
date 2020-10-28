

fr=50;
v = VideoWriter(['fname.mp4'],'MPEG-4');
v.FrameRate=fr;
v.Quality = 95;
open(v)
%camzoom(7);campan(0,-.6)
for a = 1:length(TN)
    writeVideo(v,getframe(gcf));    
    pause(1/fr)
end

