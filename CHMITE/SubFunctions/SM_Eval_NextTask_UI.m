function  fh = SM_Eval_NextTask_UI()

global USER_DATA;

screen_Size = get(0,'ScreenSize');      % [1 1 W H]
fh = figure('Visible','on','Name','CHMITE Eval',...
            'MenuBar','none',...
            'Toolbar','none', ...
            'WindowStyle', 'modal', ...
            'Color',[1 1 1],...
            'Position',[300 300 600 400]); 
         
       
% Display instructions
uicontrol(fh,'Style','text',...
            'Visible','on',...
            'String','You finished this set of wav files. Do you want to proceed to the next set?',...
            'Min',1,'Max',4,...
            'FontSize',14, ...
            'BackgroundColor',[1 1 1], ...
            'ForegroundColor',[0.1 0.1 0.1],...
            'HorizontalAlignment','left',...
            'Position',[100 200 400 80]);
           


% Args to pass
mydata.fh = fh;
guidata(fh,mydata);


% Submit Button (disabled in favor of ENTER)
proceed_Button_Ctl = uicontrol(fh,'Style','pushbutton',...
    'String','PROCEED',...
    'Visible','on',...
    'Position',[600-100 100 85 30]);        
set(proceed_Button_Ctl,'Callback',{@user_Proceed} );


% Quit Button
quit_Ctl = uicontrol(fh,'Style','pushbutton','String','QUIT',...
            'Visible','on',...
            'Position',[600-100 55 85 30]);        
set(quit_Ctl,'Callback',{@user_Exit} );


end



function user_Proceed(hObj,event)

global USER_DATA 

USER_DATA.action = 'PROCEED';       % Go to next trial i. e. main path
uiresume;

end



function user_Exit(hObj,event)

global USER_DATA

USER_DATA.action = 'QUIT';      
uiresume;

end

