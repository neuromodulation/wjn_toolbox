
% root = fullfile(mdf,'tasks','cont_stop');
% cd(root)
% fname = input('Name ','s');
% fid = fopen(fullfile('data',[fname '.txt']),'at');
% fprintf(fid,['\n' '  ' datestr(now) '\n \n']);
addcogent
% cgopen(2,
clear_ao
clear

cgopen(6,32,0,0)
pause(5)

cgopen(6,32,0,1)

% global ai ao
% config_ai;
% config_ao;
% stop(ai)
% flushdata(ai)
% start(ai)
% putsample(ao,[0 0])
% putsample(ao,[-5 -5])
% putsample(ao,[5 5])
% putsample(ao,[0 0])


x = 1;

cgalign('C','B')
cgfont('Arial',32)
cgpencol(1,1,1)
% cgtext('Start',0,0);
% cgflip(0,0,0)
% pause
cc=[149 178 207]./255;
% putsample(ao,[0 0])
% buttons 42 + 54 (L + R Shift)
%
d=1
n=0;
[x,y]=cgmouse(50,30);
tstop = tic;
s=0;
while d ==1
    pos = [x y];
    [x,y,b]=cgmouse;
   dist = wjn_distance(pos,[x y]);
    cgpencol(cc(1),cc(2),cc(3))
    if dist>2
        tstop=tic;  
        s=0;
    else
        if toc(tstop)>.25
            cgpencol(1,0,0)
%             disp('stop')
            if s==0
                tstart = tic;
            end
            s=1;
            if toc(tstart)>2.5
                cgpencol(0,1,0)
            end
        end
    end
    cgpenwid(50)
    cgellipse(0,0,300,300)
    cgpenwid(10)
    cgpencol(.5,.5,.5)
    cgdraw(x,y,x,y)
%     disp()
%     cgellipse(x,y,20,20,'f') 
    cgflip(1,1,1)
end
% clear
% delete logfile.daq