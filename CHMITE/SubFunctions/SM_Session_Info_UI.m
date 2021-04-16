function fh_Session_Info  = SM_Session_Info_UI

% Globals
global USER_DATA;

% Initialize vars
USER_DATA.subject_ID = 'Unknown';
USER_DATA.record_Auto = true;
USER_DATA.record_After_Token = false;
USER_DATA.language_Index_Selected = 1;
%USER_DATA.subject_Age = -1;
%USER_DATA.subject_Gender = 'male';


% Figure
%scrsz = get(groot,'ScreenSize');
win_Size = SM_GetScreenSize;
fh_Session_Info = figure('Visible','on','Name','Session Info',...
    'MenuBar','none',...
    'Toolbar','none',...
    'Color',[0.8000    0.8000    0.8000], ...
    'Position',win_Size);
    %'Position',[scrsz(3)/4 scrsz(4)/6 scrsz(3)/2 0.6*scrsz(4)]);

% Init mydata, used to share figure handle with
% nested functions
mydata.fh = fh_Session_Info;
guidata(fh_Session_Info,mydata);

% Button group --just like the way it looks
bg_Ctl = uibuttongroup('visible','on',...
    'parent',fh_Session_Info,...
    'Position',[0.78 0 .22 1]);

%% Language
if ~USER_DATA.english_Only
    uicontrol(fh_Session_Info,'Style','text',...
        'String','Language',...
        'Min',1,'Max',2,...
        'BackgroundColor',[0.8000    0.8000    0.8000], ...
        'FontUnits','normalized',...
        'FontSize',0.55, ...
        'HorizontalAlignment', 'left', ...
        'Units','normalized',...
        'Position',[0.05 0.85 0.1 0.05]);
    
    uicontrol(fh_Session_Info,'Style','listbox',...
        'FontUnits','normalized',...
        'FontSize',0.18, ...
        'String',{'English','Spanish','Greek'},...
        'Units','normalized',...
        'Position',[0.15 0.75 0.2 0.15],...
        'Value',1,...
        'Callback',{@get_Language});
end

%% Subject ID
uicontrol(fh_Session_Info,'Visible','On',...
    'Style','text',...
    'String','Subject ID',...
    'Min',1,'Max',2,...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'FontUnits','normalized',...
    'FontSize',0.55, ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized',...
    'Position',[0.05 0.65 0.1 0.05]);
uicontrol(fh_Session_Info,'Visible','On',...
    'Style','edit',...
    'String','',...
    'Min',1,'Max',2,...
    'HorizontalAlignment', 'left', ...
    'FontUnits','normalized',...
    'FontSize',0.55, ...
    'Units','normalized',...
    'Position',[0.15 0.65 0.2 0.05],...
    'Callback',{@get_Subject_ID});

%% Auto Record?
% Real Button group
bg_Auto_Ctl = uibuttongroup('visible','off',...
    'Position',[0.1 0.36 .5 .2],'parent',fh_Session_Info,...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'BorderType','none', ...
    'SelectionChangeFcn', @bg_Auto_Selection_Changed);

% Instructions
uicontrol(fh_Session_Info,'Visible','Off',...
    'Style','text',...
    'String','Should the program record automatically per trial, or should the user have to press the Record button?',...
    'Min',1,'Max',2,...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'FontUnits','normalized',...
    'FontSize',0.35, ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized',...
    'Position',[.05 0.5 0.7 0.09]);
% Radio buttons
rb1_Auto_Ctl = uicontrol(fh_Session_Info,'Style','Radio',...
    'String','Record automatically',...
    'Tag','auto', ...
    'Parent', bg_Auto_Ctl, ...
    'FontUnits','normalized',...
    'FontSize',0.35, ...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'Position',[15 40  300 40]);
rb2_Auto_Ctl = uicontrol(fh_Session_Info,'Style','Radio',...
    'String','Press Record button',...
    'Tag','manual', ...
    'Parent', bg_Auto_Ctl, ...
    'FontUnits','normalized',...
    'FontSize',0.35, ...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'Position',[15 10  300 40]);
set(bg_Auto_Ctl,'SelectedObject',rb1_Auto_Ctl);      % Default to record automatically


%% Record After Token?
% Real Button group
bg_Wait_Ctl = uibuttongroup('visible','off',...
    'Position',[0.1 0.15 .65 .2],'parent',fh_Session_Info,...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'BorderType','none', ...
    'SelectionChangeFcn', @bg_Wait_Selection_Changed);

% Instructions
uicontrol(fh_Session_Info,'Visible','Off',...
    'Style','text',...
    'String','Should recording wait until after the target word has played?',...
    'Min',1,'Max',2,...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'FontUnits','normalized',...
    'FontSize',0.6, ...
    'HorizontalAlignment', 'left', ...
    'Units','normalized',...
    'Position',[.05 0.28 0.7 0.05]);
% Radio buttons
rb1_Wait_Ctl = uicontrol(fh_Session_Info,'Style','Radio',...
    'String','Wait for target word to finish playing before starting to record',...
    'Tag','wait', ...
    'Parent', bg_Wait_Ctl, ...
    'FontUnits','normalized',...
    'FontSize',0.35, ...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'Position',[15 35  700 40]);
rb2_Wait_Ctl = uicontrol(fh_Session_Info,'Style','Radio',...
    'String','Do not wait for the target word',...
    'Tag','ignore', ...
    'Parent', bg_Wait_Ctl, ...
    'FontUnits','normalized',...
    'FontSize',0.35, ...
    'BackgroundColor',[0.8000    0.8000    0.8000], ...
    'Position',[15 5  600 40]);
set(bg_Wait_Ctl,'SelectedObject',rb2_Wait_Ctl);      % Default to do not wait


%{
%% Subject Age
uicontrol(fh_Session_Info,'Style','text',...
                                'String','Subject Age',...
                                'Min',1,'Max',2,...
                                'BackgroundColor',[0.8000    0.8000    0.8000], ...
                                'FontSize',8, ...
                                'HorizontalAlignment', 'right', ...
                                'Position',[50 315-30 125 20]);
uicontrol(fh_Session_Info,'Style','edit',...
                                'String','',...
                                'Min',1,'Max',2,...
                                'FontSize',8, ...
                                'HorizontalAlignment', 'right', ...
                                'Callback',{@get_Subject_Age}, ...
                                'Position',[195 320-30 40 20]);

%% Subject Gender
% Real Button group
bg_Real_Ctl = uibuttongroup('visible','on',  'Position',[0.21 0.265 .4 .5],'parent',fh_Session_Info,...
                                        'BackgroundColor',[0.8000    0.8000    0.8000], ...
                                        'BorderType','none', ...
                                        'SelectionChangeFcn', @bg_Selection_Changed);

% Instructions
uicontrol(fh_Session_Info,'Style','text',...
                                'String','Subject Gender',...
                                'Min',1,'Max',2,...
                                'BackgroundColor',[0.8000    0.8000    0.8000], ...
                                'FontSize',8, ...
                                'HorizontalAlignment', 'right', ...
                                'Position',[50 315-90 125 20]);
% Radio buttons
rb1_Ctl = uicontrol(fh_Session_Info,'Style','Radio',...
                'String','male',...
                'Tag','male', ...
                'Parent', bg_Real_Ctl, ...
                'BackgroundColor',[0.8000    0.8000    0.8000], ...
                'Position',[50 120  80 20]);
rb2_Ctl = uicontrol(fh_Session_Info,'Style','Radio',...
                'String','female',...
                'Tag','female', ...
                'Parent', bg_Real_Ctl, ...
                'BackgroundColor',[0.8000    0.8000    0.8000], ...
                'Position',[50 120-30  80 20]);
set(bg_Real_Ctl,'SelectedObject',rb1_Ctl);      % Default
%}

%% Submit Changes
submit_Ctl = uicontrol(fh_Session_Info,'Style','pushbutton','String','Continue',...
    'FontUnits','normalized',...
    'FontSize',0.5, ...
    'Min',1,'Max',3,...
    'Units','normalized',...
    'Position',[0.8 0.1 0.18 0.05]);
set(submit_Ctl,'Callback',{@user_Submit} );


end




%% Callbacks
function get_Language(hObject, eventdata, handles)

global USER_DATA
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns contents
% contents{get(hObject,'Value')} returns selected item from listbox1
items = get(hObject,'String');
index_selected = get(hObject,'Value');
USER_DATA.language_Index_Selected = index_selected;
%item_selected = items{index_selected};
%display(item_selected);

end

function get_Subject_ID(hObj,event)

global USER_DATA

% Get the new value
new_Value = strtrim(get(hObj,'String'));

% Update USER_DATA
if length(new_Value) > 0
    USER_DATA.subject_ID = new_Value;
else
    warndlg('Please enter a subject ID.');
end

end


function get_Subject_Age(hObj,event)

global USER_DATA

% Get the new value
new_Value = strtrim(get(hObj,'String'));

% Update USER_DATA
if length(new_Value) > 0
    USER_DATA.subject_Age = str2num(new_Value);
end

end


function bg_Auto_Selection_Changed(hObj,eventdata)

global USER_DATA

% Get the GUI data.
mydata = guidata(hObj);

switch get(eventdata.NewValue,'Tag')
    case 'auto'
        USER_DATA.record_Auto = true;
    case 'manual'
        USER_DATA.record_Auto = false;
    otherwise
        %USER_DATA.record_Auto = false;
        error('Unknown string for auto record');
end

end


function bg_Wait_Selection_Changed(hObj,eventdata)

global USER_DATA

% Get the GUI data.
mydata = guidata(hObj);

switch get(eventdata.NewValue,'Tag')
    case 'wait'
        USER_DATA.record_After_Token = true;
    case 'ignore'
        USER_DATA.record_After_Token = false;
    otherwise
        %USER_DATA.record_After_Token = false;
        error('Unknown string for record after token');
end

end


function user_Submit(hObj,event)

global USER_DATA

% Get the GUI data.
mydata = guidata(hObj);

if strcmp(USER_DATA.subject_ID,'Unknown')
    warndlg('Please enter a subject ID.');
else
    % Resume
    uiresume(mydata.fh);
end

end

