function varargout = Automacion_GUI(varargin)
% AUTOMACION_GUI MATLAB code for Automacion_GUI.fig
%      AUTOMACION_GUI, by itself, creates a new AUTOMACION_GUI or raises the existing
%      singleton*.
%
%      H = AUTOMACION_GUI returns the handle to a new AUTOMACION_GUI or the handle to
%      the existing singleton*.
%
%      AUTOMACION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOMACION_GUI.M with the given input arguments.
%
%      AUTOMACION_GUI('Property','Value',...) creates a new AUTOMACION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Automacion_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Automacion_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Automacion_GUI

% Last Modified by GUIDE v2.5 06-Mar-2022 18:38:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Automacion_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Automacion_GUI_OutputFcn, ...
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

% --- Executes just before Automacion_GUI is made visible.
function Automacion_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Automacion_GUI (see VARARGIN)

% Choose default command line output for Automacion_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Automacion_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.(Cargar imagen)
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes4);
[file,path] = uigetfile('*.png;*.jpeg;*.jpg','Image files','~/Vision');
global vision_images
global start_pos;
global end_pos;
global BlackWidow;
global references;
global flags
global foto
if (file ~= 0)
    persistent first_time;

    foto = iread([path file]); 
    vision_images.original=foto;
    foto = idouble(foto);
    debug_state=0;
    f = msgbox('Procesando imagen...','Busy','help');
    [green_filter,vision_images.green_filter_l,green_filter_l2,green_filter_l3,green_filter_l4,vision_images.red_filter_l] = filterImage(foto,0,0,0,0,0,0,0);
    [start_pos, end_pos,vision_images.Bordes,vision_images.warpedth_g,vision_images.warpedth_r,vision_images.final_linea] = getLineCoords(green_filter,vision_images.green_filter_l,green_filter_l2,green_filter_l3,green_filter_l4,vision_images.red_filter_l,debug_state);
    delete(f);

    start_pos = start_pos./1000;    % Cambio de escala
        end_pos = end_pos./1000;
        axes(handles.axes4);
        imshow(vision_images.green_filter_l)
        axes(handles.axes6);
        imshow(vision_images.red_filter_l)
    if (isnan(start_pos))
        f = msgbox('No se encontraron esquinas\nIntente nuevamente', 'Error','error');
    end
    
    % Parametros de inicializacion
    % Del manipulador
    L1 = 0.130;
    L2 = 0.144;
    L3 = 0.053;
    L4 = 0.144;
    L5 = 0.144;

    % De la hoja
    references.w_hoja = 0.2;
    references.l_hoja = 0.15;
    references.table_origin = [0,0.35]; %x e y de la hoja (respectivamente)
    references.table_height = L1;
    references.marker_offset = 0.05;
    
    % Inicializacion del manipulador y dibujo de hoja
    if((isempty(first_time)))
        axes(handles.axes1);
        plot(1,1)
        hold on
        drawTable(references.w_hoja, references.l_hoja, references.table_origin(1), references.table_origin(2), references.table_height);
        BlackWidow = WidowXMKII(L1,L2,L3,L4,L5,references.table_height+references.marker_offset,references.table_origin);
        first_time = false;
        flags.Robot_initialized=true;
    end
    hold off
    else
     f = msgbox('No se selecciono una imagen.', 'Advertencia','warn');
end

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
axes(handles.axes4);
popup_sel_index = get(handles.popupmenu1, 'Value');
global vision_images;
switch popup_sel_index
    case 1
        imshow(vision_images.green_filter_l);
    case 2
        imshow(vision_images.red_filter_l);
    case 3
        imshow(vision_images.Bordes);
    case 4
        imshow(vision_images.warpedth_g);
    case 5
        imshow(vision_images.warpedth_r);
    case 6
        imshow(vision_images.final_linea);
    case 7
        imshow(vision_images.original);
end

% --- Executes during object creation, after setting all properties.


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Filtro verde', 'Filtro rojo', 'Bordes de la hoja', 'Filtro verde rotado', 'Filtro rojo rotado','Imagen final','Imagen original'});


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
axes(handles.axes6);
popup_sel_index = get(handles.popupmenu3, 'Value');
global vision_images;
switch popup_sel_index
    case 1
        imshow(vision_images.red_filter_l);
    case 2
        imshow(vision_images.green_filter_l);
    case 3
        imshow(vision_images.Bordes);
    case 4
        imshow(vision_images.warpedth_g);
    case 5
        imshow(vision_images.warpedth_r);
    case 6
        imshow(vision_images.final_linea);
    case 7
        imshow(vision_images.original);
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Filtro rojo', 'Filtro verde', 'Bordes de la hoja', 'Filtro verde rotado', 'Filtro rojo rotado','Imagen final','Imagen original'});


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
global t1 t2 t3 t4 flags;
t1=70;
t2=70;
t3=70;
t4=70;
flags.ReachableShown=false;


function pushbutton2_Callback(hObject, eventdata, handles)
    global references;
    global start_pos;
    global end_pos;
    global BlackWidow;
    global flags;
    if (~isnan(start_pos))
    axes(handles.axes1);
    if(flags.ReachableShown==true)
        flags.ReachableShown=false;
        cla
    end
    R = [1, 0, 0;
         0, 0, -1;
         0, 1, 0];
    %Aca muevo el manipulador desde donde este hasta donde comenzara a
    %dibujar.
    cur_pos = BlackWidow.getPosition();
    x0=cur_pos(1);
    y0=cur_pos(2);
    xf = references.table_origin(1) + start_pos(2);
    yf = references.table_origin(2) - start_pos(1);
     P_ = BlackWidow.createLineTrajectory([x0, y0],[xf, yf],20);
    [~, col_P] = size(P_);
    
    P = [P_', ones(col_P,1).*cur_pos(3)]';    
    T = zeros(4,4,col_P);
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    hold on
    drawTable(references.w_hoja, references.l_hoja, references.table_origin(1), references.table_origin(2), references.table_height);    
    BlackWidow.moveWidow(T);    
    %me muevo para abajo
    xf = references.table_origin(1) + start_pos(2);
    yf = references.table_origin(2) - start_pos(1);
    downward = true;
     P = BlackWidow.createDownwardTrajectory([xf, yf],10,downward);
    [~, col_P] = size(P);
    T = zeros(4,4,col_P);
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    BlackWidow.moveWidow(T);  
    %Desde aca dibuja
    x0 = references.table_origin(1) + start_pos(2);
    y0 = references.table_origin(2) - start_pos(1);
    xf = references.table_origin(1) + end_pos(2);
    yf = references.table_origin(2) - end_pos(1);
    BlackWidow.getWidowInPosition(1)
    P_ = BlackWidow.createLineTrajectory([x0, y0],[xf, yf],20);
    [~, col_P] = size(P_);
    cur_pos = BlackWidow.getPosition();
    P = [P_', ones(col_P,1).*cur_pos(3)]';    
    T = zeros(4,4,col_P);
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    hold on
    BlackWidow.moveWidow(T);    
    %dibuja la linea
    X = [references.table_origin(1)+start_pos(2),references.table_origin(1)+end_pos(2)];
    Y = [references.table_origin(2)-start_pos(1),references.table_origin(2)-end_pos(1)];
    Z = [references.table_height,references.table_height];
    plot3(X,Y,Z,'Color','red');
    %Me muevo para arriba
    BlackWidow.getWidowInPosition(0)
    cur_pos = BlackWidow.getPosition();
    xf = cur_pos(1);
    yf = cur_pos(2);
    downward = false;
     P = BlackWidow.createDownwardTrajectory([xf, yf],10,downward);
    [~, col_P] = size(P);    
    T = zeros(4,4,col_P);
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    BlackWidow.moveWidow(T);
    hold off    
    else
        f = msgbox('No se encontraron esquinas', 'Error','error');
    end
    

function popupmenu1_CreateFcn(hObject, eventdata, handles)

function Automacion_GUI_1_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton4.(Espacio Alcanzable)
function pushbutton4_Callback(hObject, eventdata, handles)
    global BlackWidow
    global t1 t2 t3 t4;
    global flags;
    if(flags.Robot_initialized)
    flags.ReachableShown=true;
    axes(handles.axes1);   
    BlackWidow.showReachableSpace(t1,t2,t3,t4);
    else
      f = msgbox('Debe seleccionar una imagen primero.', 'Atenci�n','help');
    end
    
% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
global t1;
t1 = int32(get(handles.slider2, 'Value'));
set(handles.text7, 'String', t1);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
global t2;
t2 = int32(get(handles.slider3, 'Value'));
set(handles.text8, 'String', t2);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
global t3;
t3 = int32(get(handles.slider4, 'Value'));
set(handles.text9, 'String', t3);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
global t4;
t4 = int32(get(handles.slider5, 'Value'));
set(handles.text10, 'String', t4);

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    pert = str2double(get(handles.edit2, 'String'));


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
Filters

