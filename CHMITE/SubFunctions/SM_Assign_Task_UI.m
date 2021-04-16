function fh = SM_Assign_Task_UI(listener_List)

% Temp
%listener_List = {'slockhar','jlo'};

global USER_DATA

% Figure
%screen_Size = get(0,'ScreenSize');      % [1 1 W H]
win_Size = SM_GetScreenSize;
fh = figure('Color',[1 1 1],...
            'Position',win_Size);
        
% Display instructions
instruction_Text1 = 'Assign a timestamp folder to a listener by using the drop-down in the "Assign To" column.  If a listener is already assigned, this will assign one other listener to the same timestamp folder.  You can assign multiple timestamps before clicking on SUBMIT.  Clicking on SUBMIT will update this screen.  When you are done with assignments, click on QUIT to end the session';
instruction_Text2 = 'To delete an assignment, check the ones you want to delete and then press the SUBMIT button.  If the assignment status is "Not Started", it will be deleted, and the screen will be refreshed.';
instruction_Text = sprintf('%s\n\n%s',instruction_Text1,instruction_Text2);
uicontrol(fh,'Style','text',...
            'Visible','on',...
            'String',instruction_Text,...
            'Min',1,'Max',5,...
            'FontSize',12, ...
            'HorizontalAlignment','left',...      
            'BackgroundColor',[1 1 1], ...
            'ForegroundColor',[0.1 0.1 0.1],...
            'Units','normalized',...
            'HorizontalAlignment','left',...
            'Position',[.18 0.45 0.5 0.4]);
        
% uitable        
columnname =   {'SubjectID', 'Timestamp', 'Already Assigned To', 'Status', 'Assign To', 'Delete'};
columnformat = {'char', 'char', 'char', 'char', listener_List, 'logical'}; 
columneditable =  [false false false false true true]; 
columnwidth = {'auto', 100, 'auto','auto','auto','auto'};
t = uitable('Units','normalized',...
            'Position',[0.18 0.1 0.5 0.5], ...
            'Data', USER_DATA.table,... 
            'ColumnName', columnname,...
            'ColumnFormat', columnformat,...
            'ColumnEditable', columneditable,...
            'CellEditCallback',{@edit_callback}, ...
            'FontSize',12, ...
            'RowName',[],...
            'columnwidth',{80, 150, 100,100,100,100});
        
        
% Submit Button
proceed_Button_Ctl = uicontrol(fh,'Style','pushbutton',...
    'String','SUBMIT',...
    'Visible','on',...
    'Units','normalized',...
    'Position',[0.85 .1 .15 0.04]);
    %'Position',[(screen_Size(3))-90 120 85 30]);
set(proceed_Button_Ctl,'Callback',{@user_Assign} );


% Quit Button
quit_Ctl = uicontrol(fh,'Style','pushbutton','String','QUIT',...
    'Visible','on',...
    'Units','normalized',...
    'Position',[0.85 .05 .15 0.04]);
    %'Position',[(screen_Size(3))-90 75 85 30]);
set(quit_Ctl,'Callback',{@user_Exit} );


                
function edit_callback(hObject, eventdata)
% hObject    Handle to uitable1 (see GCBO)
% eventdata  Currently selected table indices

global USER_DATA

% Get the list of currently selected table cells
sel = eventdata.Indices;     % Get selection indices (row, col)
                             % Noncontiguous selections are ok
selcol = unique(sel(:,2));  % Get all selected data col IDs
selrow = unique(sel(:,1));  % Get all selected data row IDs
table = get(hObject,'Data'); % Get copy of uitable data

% Save edits
USER_DATA.table = table;




function user_Assign(hObj,event)

global USER_DATA
mydata = guidata(hObj); 

USER_DATA.action = 'PROCEED';       % Go to next trial i. e. main path
uiresume;




function user_Exit(hObj,event)

global USER_DATA

USER_DATA.action = 'QUIT';      
uiresume;


                