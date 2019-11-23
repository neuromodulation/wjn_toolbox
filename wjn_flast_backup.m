function varargout = wjn_flast(varargin)
%WJN_FLAST MATLAB code file for wjn_flast.fig
%      WJN_FLAST, by itself, creates a new WJN_FLAST or raises the existing
%      singleton*.
%
%      H = WJN_FLAST returns the handle to a new WJN_FLAST or the handle to
%      the existing singleton*.
%
%      WJN_FLAST('Property','Value',...) creates a new WJN_FLAST using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to wjn_flast_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WJN_FLAST('CALLBACK') and WJN_FLAST('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WJN_FLAST.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wjn_flast

% Last Modified by GUIDE v2.5 01-Apr-2018 21:24:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wjn_flast_OpeningFcn, ...
                   'gui_OutputFcn',  @wjn_flast_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before wjn_flast is made visible.
function wjn_flast_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for wjn_flast
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles.npixels.String = '5 2000';
handles.run.UserData.files = ffind('*.jpg')';
handles.run.UserData.path = cd;
handles.run.UserData.target = cd;

% UIWAIT makes wjn_flast wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wjn_flast_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in source.
function source_Callback(hObject, eventdata, handles)
% hObject    handle to source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[files,pathname]=uigetfile({'*.jpg'},'MultiSelect','on');

handles.run.UserData.files = files;
handles.run.UserData.path = pathname;
handles.source.String = pathname;

% --- Executes on button press in target.
function target_Callback(hObject, eventdata, handles)
% hObject    handle to target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
target = uigetdir;
handles.run.UserData.target = target;
handles.target.String = target;


% --- Executes on button press in visible.
function visible_Callback(hObject, eventdata, handles)
% hObject    handle to visible (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of visible



function npixel_Callback(hObject, eventdata, handles)
% hObject    handle to npixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of npixel as text
%        str2double(get(hObject,'String')) returns contents of npixel as a double


% --- Executes during object creation, after setting all properties.
function npixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to npixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nimages_Callback(hObject, eventdata, handles)
% hObject    handle to nimages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nimages as text
%        str2double(get(hObject,'String')) returns contents of nimages as a double


% --- Executes during object creation, after setting all properties.
function nimages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nimages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function npercentiles_Callback(hObject, eventdata, handles)
% hObject    handle to npercentiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of npercentiles as text
%        str2double(get(hObject,'String')) returns contents of npercentiles as a double


% --- Executes during object creation, after setting all properties.
function npercentiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to npercentiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outsize_Callback(hObject, eventdata, handles)
% hObject    handle to outsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outsize as text
%        str2double(get(hObject,'String')) returns contents of outsize as a double


% --- Executes during object creation, after setting all properties.
function outsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noutput_Callback(hObject, eventdata, handles)
% hObject    handle to noutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noutput as text
%        str2double(get(hObject,'String')) returns contents of noutput as a double


% --- Executes during object creation, after setting all properties.
function noutput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

root = handles.run.UserData.path;
files = handles.run.UserData.files';
targetfolder = handles.run.UserData.target;
% keyboard
if handles.visible.Value
    visible = 'on';
else
    visible='off';
end

mp = str2double(stringsplit(handles.npixel.String,' '));
mn = str2double(stringsplit(handles.nimages.String,' '));
if mn(2)>length(files)
    mn(2) = length(files);
end
npc = str2double(stringsplit(handles.npercentiles.String,' '));
outsize = str2double(stringsplit(handles.outsize.String,' '));
mg = str2double(handles.noutput.String);
% mp = [500 2000]; % max pixel of the square
% mn = [2 15]; % max number of images
% mg = 5000; % number of generated images
% npc = [10 90]; % max percentile of color mix
% outsize = [1000 1000];
cd(root);


for nx = 1:mg
    keep nx ops mp mn mi files va mnc npc mg outsize visible targetfolder
    nd=[];
    while isempty(nd)
        n=randi(mn,1);
        i = randperm(length(files),n);
        np = randi(mp,1);
        nd = nan([length(i) np np 3]);
        iout = [];
        
        for a = 1:length(i)
            d=imread(files{i(a)});
            s = size(d);
            if s(1)/2<=np || s(2)/2 <=np
                iout = [iout a];
                continue
            else
                xrun=1;
                while xrun
                ix = np+randi(s(1)-2*np,1);
                iy = np+randi(s(2)-2*np,1);
                sx = ix+1-np:ix;
                sy = iy+1-np:iy;
%                 try
                nd(a,:,:,:) = d(sx,sy,:);
                xrun=0;
%                 end
                end
            end
            %     imagesc(d(sx,sy,:));
        end
        nd(iout,:,:,:)=[];
    end
    nprc = randi(npc,1);    
%     close all
    prc = nprc;
    nc = uint8(squeeze(prctile(nd,prc,1)));
%     keyboard
    inc = imresize(nc,[5000 5000],'bicubic');
    of=figure('Visible',visible);
    imagesc(squeeze(inc));
    set(gca,'XTick',[],'YTick',[],'XColor','none','YColor','none','box','off');
%     keyboard
    figone(20,20),
    if strcmp(visible,'on')
        set(gca,'position',[0.11 0.11 .785 .79])
    else
        
        set(gca,'position',[0 0 1 1])
    end
    drawnow
    ops(nx,:) = [nx n np prc]
    fname = strrep(strrep([datestr(datetime) '_' num2str(ops(nx,:))],' ','_'),':','_');
    print(of,fullfile(targetfolder,[fname '.jpg']),'-djpeg','-r600')
    disp(['printed ' num2str(nx) ' of ' num2str(mg)])
end
