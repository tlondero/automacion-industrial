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

% Last Modified by GUIDE v2.5 13-Jul-2022 13:04:20

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
global filter_parameters
global BlackWidow;
global references;
global flags
global foto
if (file ~= 0)
    persistent first_time;
    flags.Processed = false;
    foto = iread([path file]); 
    vision_images.original=foto;
    foto = idouble(foto);
    debug_state=0;
    f = msgbox('Procesando imagen...','Busy','help');
%     [vision_images.green_filter_l,~,~,~,~,~,vision_images.red_filter_l] = filterImage(foto,0,0,0,0,0,0,0);
    [vision_images.green_filter_l,~,~,~,~,~,vision_images.red_filter_l] = filterImage(foto,filter_parameters.hsv_sat_lo,filter_parameters.hsv_val_hi,filter_parameters.hsv_val_lo,    filter_parameters.hsv_redhue_hi,filter_parameters.hsv_redhue_lo,filter_parameters.hsv_greenhue_hi,filter_parameters.hsv_greenhue_lo);
    delete(f);

    axes(handles.axes4);
    imshow(vision_images.green_filter_l)
    axes(handles.axes6);
    imshow(vision_images.red_filter_l)


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
        set(handles.popupmenu1, 'String', {'Filtro verde basico', 'Filtro rojo basico'});
        set(handles.popupmenu3, 'String', {'Filtro rojo basico', 'Filtro verde basico'});
     else
     msgbox('No se selecciono una imagen.', 'Advertencia','warn');
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
global vision_images flags;
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
    case 8
        imshow(vision_images.Bordes);
end

% --- Executes during object creation, after setting all properties.


% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end
if(flags.Processed)
            set(hObject, 'String', {'Filtro verde procesado', 'Filtro rojo procesado', 'Bordes de la hoja', 'Filtro verde rotado', 'Filtro rojo rotado','Imagen final','Imagen original', 'Bordes de Hough'});
else 
set(hObject, 'String', {'Filtro verde basico', 'Filtro rojo basico'});
end

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
    case 8
        imshow(vision_images.Bordes);
end

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '');


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
global t1 t2 t3 t4 flags filter_parameters;
t1=70;
t2=70;
t3=70;
t4=70;
flags.ReachableShown=false;
flags.debug_state=false;
flags.Robot_initialized=false;
flags.Processed=false;
filter_parameters.hsv_redhue_hi = (-7.5+27.5)/360; %27.5 grados adelante de -7.5 grados
filter_parameters.hsv_redhue_lo = ((-7.5+360)-27.5)/360; %27.5 grados atras de -7.5 grados
filter_parameters.hsv_greenhue_hi = (110+80)/360; %80 grados arriba de 110 grados
filter_parameters.hsv_greenhue_lo = (110-75)/360; %75 grados abajo de 110 grados
filter_parameters.hsv_sat_lo = 0.14;
filter_parameters.hsv_val_hi = 0.55;
filter_parameters.hsv_val_lo = 0.25;



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
    plot3(X,Y,Z,'Color', [rand, rand, rand], 'MarkerSize', 3, 'LineWidth', 2);
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
        msgbox('No se encontraron esquinas', 'Error','error');
    end
    

function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', '');

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
    msgbox('Debe seleccionar una imagen primero.', 'Atencion','help');
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
function slider4_Callback(~, eventdata, handles)
global t3;
t3 = int32(get(handles.slider4, 'Value'));
set(handles.text9, 'String', t3);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider5_Callback(~, eventdata, handles)
global t4;
t4 = int32(get(handles.slider5, 'Value'));
set(handles.text10, 'String', t4);

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit2_Callback(~, ~, ~)

function edit2_CreateFcn(hObject, ~, ~) %#ok<DEFNU>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(~, ~, handles)
global BlackWidow;
global l1 l2 l3 l4 l5;
global flags
if(flags.Robot_initialized)
    BlackWidow.Widow.links(1).d=double(l1)/1000.0;
    BlackWidow.Widow.links(3).a=sqrt(double(l2^2+l3^2))/1000.0;
    BlackWidow.Widow.links(4).a=double(l4)/1000.0;
    BlackWidow.Widow.links(5).a=double(l5)/1000.0;
    BlackWidow.L1=double(l1)/1000.0;
    BlackWidow.L2=double(l2)/1000.0;
    BlackWidow.L3=double(l3)/1000.0;
    BlackWidow.Lp=sqrt(double(l2^2+l3^2))/1000.0;
    BlackWidow.L4=double(l4)/1000.0;
    BlackWidow.L5=double(l5)/1000.0;
    q=BlackWidow.Widow.getpos;
    axes(handles.axes1);
    BlackWidow.Widow.plot(q);
else
    msgbox('Debe seleccionar una imagen primero.', 'Atencion','help');
end
    
    %ACA es el boton de fonrirmar cambios en las medidas del robot


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(~, ~, ~)
Filters



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(~, ~, handles)
global start_pos;
global end_pos;
global vision_images;
global foto
global filter_parameters;
global flags;
f = msgbox('Procesando imagen...','Busy','help');
[vision_images.green_filter_l,vision_images.green_filter,vision_images.green_filter_l2, vision_images.green_filter_l3,vision_images.green_filter_l4,~,vision_images.red_filter_l] =filterImage(foto,filter_parameters.hsv_sat_lo,filter_parameters.hsv_val_hi,filter_parameters.hsv_val_lo,filter_parameters.hsv_redhue_hi,filter_parameters.hsv_redhue_lo,filter_parameters.hsv_greenhue_hi,filter_parameters.hsv_greenhue_lo);
[start_pos, end_pos,vision_images.Bordes,vision_images.warpedth_g,vision_images.warpedth_r,vision_images.final_linea] = getLineCoords(vision_images.green_filter,vision_images.green_filter_l,vision_images.green_filter_l2,vision_images.green_filter_l3,vision_images.green_filter_l4,vision_images.red_filter_l,flags.debug_state);
delete(f);
start_pos = start_pos./1000;    % Cambio de escala
end_pos = end_pos./1000;
if (isnan(start_pos))
    msgbox('No se encontraron esquinas. Intente nuevamente.', 'Error','error');
else
flags.Processed=true;
        set(handles.popupmenu1, 'String', {'Filtro verde procesado', 'Filtro rojo procesado', 'Bordes de la hoja', 'Filtro verde rotado', 'Filtro rojo rotado','Imagen final','Imagen original', 'Bordes de Hough'});
        set(handles.popupmenu3, 'String', {'Filtro rojo procesado', 'Filtro verde procesado', 'Bordes de la hoja', 'Filtro verde rotado', 'Filtro rojo rotado','Imagen final','Imagen original', 'Bordes de Hough'});
axes(handles.axes4);

popup_sel_index = get(handles.popupmenu1, 'Value');
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
    case 8
        imshow(vision_images.Bordes);
end


axes(handles.axes6);
popup_sel_index = get(handles.popupmenu3, 'Value');
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

end




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(~, eventdata, handles) 
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider7_Callback(~, eventdata, handles)
global l1;
l1 = int32(get(handles.slider7, 'Value'));
set(handles.text17, 'String', l1);

% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(~, eventdata, handles)
global l2;
l2 = int32(get(handles.slider8, 'Value'));
set(handles.text18, 'String', l2);
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(~, eventdata, handles)
global l3;
l3 = int32(get(handles.slider9, 'Value'));
set(handles.text19, 'String', l3);
% ~    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(~,'Value') returns position of slider
%        get(~,'Min') and get(~,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider10_Callback(hObject, eventdata, handles)
global l4;
l4 = int32(get(handles.slider10, 'Value'));
set(handles.text20, 'String', l4);
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider11_Callback(hObject, eventdata, handles)
global l5;
l5 = int32(get(handles.slider11, 'Value'));
set(handles.text22, 'String', l5);
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
global BlackWidow;
global flags
if(flags.Robot_initialized)
    L1 = 0.130;
    L2 = 0.144;
    L3 = 0.053;
    L4 = 0.144;
    L5 = 0.144;
    BlackWidow.Widow.links(1).d=double(L1);
    BlackWidow.Widow.links(3).a=sqrt(double(L2^2+L3^2));
    BlackWidow.Widow.links(4).a=double(L4);
    BlackWidow.Widow.links(5).a=double(L5);
    BlackWidow.L1=double(L1)/1000.0;
    BlackWidow.L2=double(L2)/1000.0;
    BlackWidow.L3=double(L3)/1000.0;
    BlackWidow.Lp=sqrt(double(L2^2+L3^2))/1000.0;
    BlackWidow.L4=double(L4)/1000.0;
    BlackWidow.L5=double(L5)/1000.0;
    q=BlackWidow.Widow.getpos;
    axes(handles.axes1);
    BlackWidow.Widow.plot(q);
else
    msgbox('Debe seleccionar una imagen primero.', 'Atencion','help');
end
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
I = imread('ITBA_LOGO.png');
imshow(I);
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8
