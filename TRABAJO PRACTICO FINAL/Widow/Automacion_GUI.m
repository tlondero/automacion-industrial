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

% Last Modified by GUIDE v2.5 06-Mar-2022 14:14:11

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

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Automacion_GUI.




% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes Automacion_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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
global green_filter_l;
global Bordes;
global red_filter_l;
global warpedth_g;
global warpedth_r;
global final_linea;
global original;
global table_origin;
global start_pos;
global end_pos;
global BlackWidow;
global w_hoja;
global l_hoja;
global table_height;
global Robot_initialized;
if (file ~= 0)
    persistent first_time;

    foto = iread([path file]); 
    original=foto;
    foto = idouble(foto);
    debug_state=0;
    [start_pos, end_pos,green_filter_l,red_filter_l,Bordes,warpedth_g,warpedth_r,final_linea] = getLineCoords(foto,debug_state);
    start_pos = start_pos./1000;    % Cambio de escala
    end_pos = end_pos./1000;
    imshow(green_filter_l)
    axes(handles.axes6);
    imshow(red_filter_l)



    % Parametros de inicializacion
    % Del manipulador
    L1 = 0.130;
    L2 = 0.144;
    L3 = 0.053;
    L4 = 0.144;
    L5 = 0.144;

    % De la hoja
    w_hoja = 0.2;
    l_hoja = 0.15;
    table_origin = [0,0.35]; %x e y de la hoja (respectivamente)
    table_height = L1;
    marker_offset = 0.05;

    % Inicializacion del manipulador y dibujo de hoja
    if((isempty(first_time)))
        axes(handles.axes1);
        plot(1,1)
        hold on
        drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);
        BlackWidow = WidowXMKII(L1,L2,L3,L4,L5,table_height+marker_offset,table_origin);
        first_time = false;
        Robot_initialized=true;
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
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
axes(handles.axes4);
popup_sel_index = get(handles.popupmenu1, 'Value');
global green_filter_l;
global Bordes;
global red_filter_l;
global warpedth_g;
global warpedth_r;
global final_linea;
global original;
switch popup_sel_index
    case 1
        imshow(green_filter_l);
    case 2
        imshow(red_filter_l);
    case 3
        imshow(Bordes);
    case 4
        imshow(warpedth_g);
    case 5
        imshow(warpedth_r);
    case 6
        imshow(final_linea);
    case 7
        imshow(original);
end
% {'Filtro verde', 'Filtro rojo', 'Bordes de la hoja', 'Filtro verde rotado', 'Filtro rojo rotado','Imagen final'});
% ,green_filter_l,red_filter_l,Bordes,warpedth_g,warpedth_r,final_linea
% --- Executes during object creation, after setting all properties.


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Filtro verde', 'Filtro rojo', 'Bordes de la hoja', 'Filtro verde rotado', 'Filtro rojo rotado','Imagen final','Imagen original'});


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
axes(handles.axes6);
popup_sel_index = get(handles.popupmenu3, 'Value');
global green_filter_l;
global Bordes;
global red_filter_l;
global warpedth_g;
global warpedth_r;
global final_linea;
global original;
switch popup_sel_index
    case 1
        imshow(red_filter_l);
    case 2
        imshow(green_filter_l);
    case 3
        imshow(Bordes);
    case 4
        imshow(warpedth_g);
    case 5
        imshow(warpedth_r);
    case 6
        imshow(final_linea);
    case 7
        imshow(original);
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Filtro rojo', 'Filtro verde', 'Bordes de la hoja', 'Filtro verde rotado', 'Filtro rojo rotado','Imagen final','Imagen original'});


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
global t1 t2 t3 t4;
t1=70;
t2=70;
t3=70;
t4=70;

% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton2 (Mover manipulador).
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global table_origin;
    global start_pos;
    global end_pos;
    global BlackWidow;
    global w_hoja;
    global l_hoja;
    global table_height;
    global ReachableShown
    if (~isnan(start_pos))
    axes(handles.axes1);
    if(ReachableShown==true)
        ReachableShown=false;
        cla
    end
    %Aca muevo el manipulador desde donde este hasta donde comenzara a
    %dibujar.
    cur_pos = BlackWidow.getPosition();
    x0=cur_pos(1);
    y0=cur_pos(2);
    z0=cur_pos(3);
    xf = table_origin(1) + start_pos(2);
    yf = table_origin(2) - start_pos(1);
     P_ = BlackWidow.createLineTrajectory([x0, y0],[xf, yf],20);
    [row_P, col_P] = size(P_);
    R = [1, 0, 0;
         0, 0, -1;
         0, 1, 0];
    P = [P_', ones(col_P,1).*cur_pos(3)]';    
    T = zeros(4,4,col_P);
    
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    
    hold on
    
    drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);    
    BlackWidow.moveWidow(T);    
    %me muevo para abajo
    xf = table_origin(1) + start_pos(2);
    yf = table_origin(2) - start_pos(1);
    downward = true;
     P = BlackWidow.createDownwardTrajectory([xf, yf],10,downward);
    [~, col_P] = size(P);
    R = [1, 0, 0;
         0, 0, -1;
         0, 1, 0];
        
    T = zeros(4,4,col_P);
    
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    
    drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);    
    BlackWidow.moveWidow(T);  
    %Desde aca dibuja
    x0 = table_origin(1) + start_pos(2);
    y0 = table_origin(2) - start_pos(1);
    xf = table_origin(1) + end_pos(2);
    yf = table_origin(2) - end_pos(1);
    
    BlackWidow.getWidowInPosition(1)
    
    P_ = BlackWidow.createLineTrajectory([x0, y0],[xf, yf],20);
    [row_P, col_P] = size(P_);
    R = [1, 0, 0;
         0, 0, -1;
         0, 1, 0];
    cur_pos = BlackWidow.getPosition();
    
    P = [P_', ones(col_P,1).*cur_pos(3)]';    
    T = zeros(4,4,col_P);
    
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    hold on
    drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);    
    BlackWidow.moveWidow(T);    
    %dibuja la linea
    X = [table_origin(1)+start_pos(2),table_origin(1)+end_pos(2)];
    Y = [table_origin(2)-start_pos(1),table_origin(2)-end_pos(1)];
    Z = [table_height,table_height];
    plot3(X,Y,Z,'Color','red');
    %Me muevo para arriba
    BlackWidow.getWidowInPosition(0)
    cur_pos = BlackWidow.getPosition();
    xf = cur_pos(1);
    yf = cur_pos(2);
    downward = false;
     P = BlackWidow.createDownwardTrajectory([xf, yf],10,downward);
    [~, col_P] = size(P);
    R = [1, 0, 0;
         0, 0, -1;
         0, 1, 0];
        
    T = zeros(4,4,col_P);
    
    for i=1:col_P
        T(:,:,i) = [R, P(:,i); 0, 0, 0, 1];
    end
    
    drawTable(w_hoja, l_hoja, table_origin(1), table_origin(2), table_height);    
    BlackWidow.moveWidow(T);
    hold off    
    else
        f = msgbox('No se encontraron esquinas', 'Error','error');
    end
    

function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --------------------------------------------------------------------
function Automacion_GUI_1_Callback(hObject, eventdata, handles)
% hObject    handle to Automacion_GUI_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.(Espacio Alcanzable)
function pushbutton4_Callback(hObject, eventdata, handles)
    global BlackWidow
    global ReachableShown
    global t1 t2 t3 t4;
    global Robot_initialized;
    if(Robot_initialized)
    ReachableShown=true;
    axes(handles.axes1);   
    BlackWidow.showReachableSpace(t1,t2,t3,t4);
    else
      f = msgbox('Debe seleccionar una imagen primero.', 'Atención','help');
    end
    
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
global t1;
t1 = int32(get(handles.slider2, 'Value'));
set(handles.text7, 'String', t1);

% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t2;
t2 = int32(get(handles.slider3, 'Value'));
set(handles.text8, 'String', t2);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t3;
t3 = int32(get(handles.slider4, 'Value'));
set(handles.text9, 'String', t3);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t4;
t4 = int32(get(handles.slider5, 'Value'));
set(handles.text10, 'String', t4);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
    pert = str2double(get(handles.edit2, 'String'));

% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
