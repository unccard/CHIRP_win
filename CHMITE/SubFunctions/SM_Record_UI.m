function [fh, text_Ctl, proceed_Button_Ctl, repeat_Ctl, quit_Ctl, record_Indicator_Ctl, pause_Button_Ctl] = SM_Record_UI

global USER_DATA;

%screen_Size = get(0,'ScreenSize');
win_Size = SM_GetScreenSize;
fh = figure('Visible','on','Name','',...
            'MenuBar','none',...
            'Toolbar','none', ...
            'Color',[1 1 1],...
            'Position',win_Size);
set(fh,'KeyPressFcn',{@decode_Key});        
       
% Display word
text_Ctl = uicontrol(fh,'Style','text',...
            'Visible','on',...
            'String','',...
            'Min',1,'Max',5,...
            'FontSize',56, ...
            'BackgroundColor',[1 1 1], ...
            'ForegroundColor',[0.1 0.1 0.1],...
            'HorizontalAlignment','center',...
            'Units','Normalized',...
            'Position',[0,0.4,1,0.2]);
        %'Position',[150 (3*screen_Size(4)/5) screen_Size(3)-300 200]

% Recording indicator
record_Indicator_Ctl = uicontrol(fh,'Style','text',...
            'Visible','on',...
            'String','',...
            'BackgroundColor',[1 1 1], ...
            'ForegroundColor',[1 0.1 0.1],...
            'HorizontalAlignment','center',...
            'Units','Normalized',...
            'Position',[0.85,0.25,0.13,0.04]);
        %'Position',[150 (1*screen_Size(4)/10) screen_Size(3)-300 120]
% Args to pass
mydata.fh = fh;
guidata(fh,mydata);


    
% Repeat
repeat_Ctl = uicontrol(fh,'Style','pushbutton','String','REPEAT (C)',...
    'Visible','off',...
    'Units','Normalized',...
    'Position',[0.85,0.2,0.13,0.04]);
    %'Position',[(screen_Size(3))-150 165 160 30]);
set(repeat_Ctl,'Callback',{@user_Repeat} );


% Proceed (either RECORD or NEXT TRIAL)
proceed_Button_Ctl = uicontrol(fh,'Style','pushbutton',...
    'String','',...
    'Visible','off',...
    'Units','Normalized',...
    'Position',[0.85,0.15,0.13,0.04]);
%'Position',[(screen_Size(3))-150 120 160 30]);
set(proceed_Button_Ctl,'Callback',{@user_Proceed} );



% Pause
pause_Button_Ctl = uicontrol(fh,'Style','pushbutton',...
    'String','PAUSE (Z)',...
    'Visible','off',...
    'Units','Normalized',...
    'Position',[0.85,0.1,0.13,0.04]);
%'Position',[(screen_Size(3))-150 75 160 30]);
set(pause_Button_Ctl,'Callback',{@user_Pause} );

% Quit
quit_Ctl = uicontrol(fh,'Style','pushbutton','String','QUIT',...
    'Visible','off',...
    'Units','Normalized',...
    'Position',[0.85,0.05,0.13,0.04]);
%'Position',[(screen_Size(3))-150 30 160 30]);
set(quit_Ctl,'Callback',{@user_Exit} );


end


function decode_Key(hObj,event)

global USER_DATA;

switch upper(char(event.Key))
    case 'Z'
        user_Pause(hObj,event)
    case 'X'
        user_Proceed(hObj,event)
    case 'C'
        user_Repeat(hObj,event)
    otherwise
        upper(char(event.Key))
end

end



function user_Repeat(hObj,event)

global USER_DATA
mydata = guidata(hObj); 

USER_DATA.action = 'REPEAT';      
refresh(mydata.fh)
uiresume;

end



function user_Proceed(hObj,event)

global USER_DATA
mydata = guidata(hObj); 

USER_DATA.action = 'PROCEED';       % Could be record or go to next trial i. e. main path
refresh(mydata.fh)
uiresume;

end


function user_Pause(hObj,event)

global USER_DATA
mydata = guidata(hObj); 

USER_DATA.action = 'PAUSE';       % Could be record or go to next trial i. e. main path
refresh(mydata.fh)
uiresume;

end



function user_Exit(hObj,event)

global USER_DATA

USER_DATA.action = 'QUIT';      
uiresume;

end
        



