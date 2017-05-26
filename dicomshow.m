function dicomshow(filename);
if ~exist('filename','var' )
    filename = cellstr(spm_select(Inf,'.dcm'))
end

for a = 5:length(filename);
    info = dicominfo(filename{a});
    [~,n]=fileparts(info.Filename);
    name{a} = n;
    [X,map] = dicomread(filename{a});
    img(:,:,a) = X;
end

a = 6
figure;

while 1
    
   imshow(img(:,:,a));caxis([-2000 2000])
   drawnow
   title(name{a});
   imcontrast;
   h = uicontrol('Style', 'pushbutton', 'String', 'next',...
    'Position', [20 150 100 70], 'Callback', 'close');
   waitfor(h);
    a = a+1;
    
   

%    a = a+1;
   if a>size(img,3);
       return
   end
end

