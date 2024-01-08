function varargout = AIDE_GUI(varargin)
% AIDE_GUI MATLAB code for AIDE_GUI.fig
%      AIDE_GUI, by itself, creates a new AIDE_GUI or raises the existing
%      singleton*.
%
%      H = AIDE_GUI returns the handle to a new AIDE_GUI or the handle to
%      the existing singleton*.
%
%      AIDE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AIDE_GUI.M with the given input arguments.
%
%      AIDE_GUI('Property','Value',...) creates a new AIDE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AIDE_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AIDE_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AIDE_GUI

% Last Modified by GUIDE v2.5 04-May-2017 13:14:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AIDE_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @AIDE_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before AIDE_GUI is made visible.
function AIDE_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AIDE_GUI (see VARARGIN)

% Choose default command line output for AIDE_GUI
handles.output = hObject;

set(handles.StartSample_edit,'visible','off')
set(handles.StopSample_edit,'visible','off')

% FDR
handles.FDR_corr=1;
set(handles.FDRno_radio,'value',0);
set(handles.FDRyes_radio,'value',1);

%p_thres
set(handles.pthresh_edit,'string','0.0001');

% Axes
cla(handles.axes1)
axes(handles.axes1)
rectangle('Visible','off')
set(handles.axes1,'Tag','axes1')

cla(handles.axes2)
axes(handles.axes2)
rectangle('Visible','off')
set(handles.axes2,'Tag','axes2')

% add all folders to path
addpath(genpath(pwd));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AIDE_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AIDE_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject, handles);


% --- Executes on slider movement.
function Channels_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Channels_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Results Activation_Points

if exist('Results','var')
    handles.Chnum=round(get(hObject,'Value'));
    
    if handles.Chnum>0

    AIDE_plot(handles.axes1,Results,handles.fs,Activation_Points,handles.Chnum)
    AIDE_Tsig_plot(handles.axes2,Results,handles.fs,Activation_Points,handles.Chnum)

    set(handles.Channel_text,'string', num2str(Results.Channels2Include(handles.Chnum)))
    else
    end
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Channels_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channels_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
guidata(hObject, handles);


% --- Executes on button press in Save_push.
function Save_push_Callback(hObject, eventdata, handles)
% hObject    handle to Save_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Results Activation_Points

[filename, pathname] = uiputfile('*.mat', 'Save as');

save([pathname filename],'Results','Activation_Points')

guidata(hObject, handles);


% --- Executes on button press in Open_push.
function Open_push_Callback(hObject, eventdata, handles)
% hObject    handle to Open_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HBO HHB

[handle.filen, handle.pathn] = uigetfile('*.mat','Select the fNIRS data file');
load([handle.pathn handle.filen])

set(handles.Filename_text,'string',[handle.pathn handle.filen])

set(handles.ApplyAIDE_push,'Enable','on') 

[handles.AllSignals]=Cbsi(HBO,HHB); 

guidata(hObject, handles);



function StartSample_edit_Callback(hObject, eventdata, handles)
% hObject    handle to StartSample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartSample_edit as text
%        str2double(get(hObject,'String')) returns contents of StartSample_edit as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StartSample_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartSample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);



function StopSample_edit_Callback(hObject, eventdata, handles)
% hObject    handle to StopSample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StopSample_edit as text
%        str2double(get(hObject,'String')) returns contents of StopSample_edit as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function StopSample_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StopSample_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);



function MaxBoxDur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to MaxBoxDur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxBoxDur_edit as text
%        str2double(get(hObject,'String')) returns contents of MaxBoxDur_edit as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function MaxBoxDur_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxBoxDur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);



function ChExcl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ChExcl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChExcl_edit as text
%        str2double(get(hObject,'String')) returns contents of ChExcl_edit as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ChExcl_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChExcl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


% --- Executes on button press in FDRyes_radio.
function FDRyes_radio_Callback(hObject, eventdata, handles)
% hObject    handle to FDRyes_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
    handles.FDR_corr=1;
    set(handles.FDRno_radio,'value',0);
end


% Hint: get(hObject,'Value') returns toggle state of FDRyes_radio
guidata(hObject, handles);


% --- Executes on button press in FDRno_radio.
function FDRno_radio_Callback(hObject, eventdata, handles)
% hObject    handle to FDRno_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'value')==1
    handles.FDR_corr=0;
    set(handles.FDRyes_radio,'value',0);
end

% Hint: get(hObject,'Value') returns toggle state of FDRno_radio
guidata(hObject, handles);


% --- Executes on button press in ApplyAIDE_push.
function ApplyAIDE_push_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyAIDE_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HBO HHB Results Act_points Act_points_thresh boxcar Convolution Activation_Points Channels2Include

% % handles.startsample=str2num(get(handles.StartSample_edit,'string'));
% % handles.stopsample=str2num(get(handles.StopSample_edit,'string'));
handles.MaxBoxDur=str2num(get(handles.MaxBoxDur_edit,'string'));
handles.p_thresh=str2num(get(handles.pthresh_edit,'string'));
handles.Channels2Exclude=str2num(get(handles.ChExcl_edit,'string'));
handles.fs=str2num(get(handles.fs_edit,'string'));

if ~isempty(handles.p_thresh) && ~isempty(handles.fs)
    
    if (~isempty(handles.MaxBoxDur) && handles.MaxBoxDur>0) || isempty(handles.MaxBoxDur)
        [handles.AllSignals]=Cbsi(HBO,HHB); % Activation Signal
        
        [Results, Act_points, Act_points_thresh, boxcar, Convolution, Channels2Include]=ApplyAIDE(handles.AllSignals,0.05,handles.p_thresh,handles.fs,handles.Channels2Exclude,handles.FDR_corr,[],[],handles.MaxBoxDur);
        
        [Activation_Points, Results]=reshape_results(Act_points_thresh, Results.Channels2Include, Results);
        
        axes(handles.axes1);
        
        handles.Chnum=1;
        AIDE_plot(handles.axes1,Results,handles.fs,Activation_Points,handles.Chnum)
        AIDE_Tsig_plot(handles.axes2,Results,handles.fs,Activation_Points,handles.Chnum)
        
        if length(Results.Channels2Include)==1
            set(handles.Channels_slider,'Visible','on','Min',0,'Max',length(Results.Channels2Include),...
                'Value',1,'SliderStep',[1 1])
        else set(handles.Channels_slider,'Visible','on','Min',1,'Max',length(Results.Channels2Include),...
                'Value',1,'SliderStep',[1/(length(Results.Channels2Include)-1) 1/(length(Results.Channels2Include)-1)])
        end
        set(handles.Channel_text,'string', num2str(Results.Channels2Include(handles.Chnum)))
    else warndlg('boxcar duration')
    end
else
    warndlg('Please, check p_thresh or sampling frequency')
end

guidata(hObject, handles);


function pthresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pthresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pthresh_edit as text
%        str2double(get(hObject,'String')) returns contents of pthresh_edit as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pthresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pthresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function LoadResults_Push_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to LoadResults_Push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Results

[handle.filen, handle.pathn] = uigetfile('*.mat','Select AIDE results data file');
load([handle.pathn handle.filen])

set(handles.Filename_text,'string',[handle.pathn handle.filen])

set(handles.ApplyAIDE_push,'Enable','off') 

 
handles.AllSignals=Results.Signal;
handles.fs=Results.fs;

handles.Chnum=1;
AIDE_plot(handles.axes1,Results,handles.fs,Activation_Points,handles.Chnum)
AIDE_Tsig_plot(handles.axes2,Results,handles.fs,Activation_Points,handles.Chnum)

if length(Results.Channels2Include)==1
    set(handles.Channels_slider,'Visible','on','Min',0,'Max',length(Results.Channels2Include),...
        'Value',1,'SliderStep',[1 1])
else set(handles.Channels_slider,'Visible','on','Min',1,'Max',length(Results.Channels2Include),...
        'Value',1,'SliderStep',[1/(length(Results.Channels2Include)-1) 1/(length(Results.Channels2Include)-1)])
end
set(handles.Channel_text,'string', num2str(Results.Channels2Include(handles.Chnum)))


guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over PaperLink_txt.
function PaperLink_txt_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to PaperLink_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
website='http://dx.doi.org/10.1016/j.neuroimage.2017.05.001';
web('-browser',website);
guidata(hObject, handles);



function fs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs_edit as text
%        str2double(get(hObject,'String')) returns contents of fs_edit as a double
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function fs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);
