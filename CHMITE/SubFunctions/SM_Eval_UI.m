function  fh = SM_Eval_UI(waveform, Fs)

global USER_DATA;
USER_DATA.text_Entered = '';

%screen_Size = get(0,'ScreenSize');      % [1 1 W H]
win_Size = SM_GetScreenSize;
fh = figure('Visible','on','Name','CHMITE Eval',...
            'MenuBar','none',...
            'Toolbar','none', ...
            'Color',[1 1 1],...
            'Position',win_Size); 
         
       
% Display instructions
uicontrol(fh,'Style','text',...
            'Visible','on',...
            'String','Wait for the next recording to play.  Then, type the text for this recording (or NR for No Response) and press ENTER:',...
            'Min',1,'Max',4,...
            'FontSize',14, ...
            'BackgroundColor',[1 1 1], ...
            'ForegroundColor',[0.1 0.1 0.1],...
            'HorizontalAlignment','left',...
            'Unit','Normalized',...
            'Position',[0.1 0.5 0.3 0.3]);
            %'Position',[150 (screen_Size(4)/2) 330 120]);
        
edit_Ctl = uicontrol(fh,'Style','edit',...
            'Visible','on',...
            'String','',...
            'Min',1,'Max',2,...
            'FontSize',14, ...
            'BackgroundColor',[1 1 1], ...
            'ForegroundColor',[0.1 0.1 0.1],...
            'HorizontalAlignment','left',...
            'Callback',{@get_Text},... 
            'Units','Normalized',...
            'Position',[0.4 0.5 0.3 0.1]);         
            %'Position',[490 (screen_Size(4)/2)+12 350 30]);         


% Args to pass
mydata.fh = fh;
mydata.waveform = waveform;
mydata.Fs = Fs;
guidata(fh,mydata);

% Replay Button (disabled for now)
repeat_Ctl = uicontrol(fh,'Style','pushbutton','String','REPLAY',...
            'Visible','off',...
            'Units','Normalized',...
            'Position',[0.85 0.1 0.13 0.04]);        
            %'Position',[(screen_Size(3))-90 165 85 30]);        
set(repeat_Ctl,'Callback',{@user_Replay} );


% Submit Button (disabled in favor of ENTER)
proceed_Button_Ctl = uicontrol(fh,'Style','pushbutton',...
    'String','SAVE',...
    'Visible','off',...
            'Units','Normalized',...
            'Position',[0.85 0.1 0.13 0.04]);        
    %'Position',[(screen_Size(3))-90 120 85 30]);        
set(proceed_Button_Ctl,'Callback',{@user_Proceed} );


% Quit Button
quit_Ctl = uicontrol(fh,'Style','pushbutton','String','QUIT',...
            'Visible','on',...
            'Units','Normalized',...
            'Position',[0.85 0.05 0.13 0.04]);        
            %'Position',[(screen_Size(3))-90 75 85 30]);        
set(quit_Ctl,'Callback',{@user_Exit} );


% Put focus on edit 
uicontrol(edit_Ctl);

% Play sound
sound(waveform, Fs);
%figure; plot(waveform)
%player = audioplayer(waveform, Fs);
%play(player);


end




function get_Text(hObj,event)

global USER_DATA

% Get the GUI data.
mydata = guidata(hObj); 

% Get the new value
new_Value = get(hObj,'String');

% See if we should skip dictionary lookup
skip_Dictionary = false;
if strcmp(new_Value(end),'.')
    skip_Dictionary = true;
    new_Value = new_Value(1:end-1);
end
skip_Pos = strfind(new_Value,'NR');
if ~isempty(skip_Pos)
    skip_Dictionary = true;
end

if ~word_In_Dictionary(lower(strtrim(new_Value)))  && ~skip_Dictionary
    USER_DATA.text_Entered = '';
    % Pop up
    fh_Warn = warndlg('This word not found in dictionary');
    uiwait(fh_Warn);   
else
    USER_DATA.text_Entered = lower(strtrim(new_Value));
    USER_DATA.action = 'PROCEED';       % Go to next trial i. e. main path
    display_String = 'user_Proceed: Proceeding to next trial';
    disp(display_String);
    uiresume;    
end


%USER_DATA

end


% No longer called 
function user_Replay(hObj,event)

global USER_DATA
mydata = guidata(hObj); 

% Replay the wav file; do not uiresume.
sound(mydata.waveform,mydata.Fs);

end


% No longer called
function user_Proceed(hObj,event)

global USER_DATA
mydata = guidata(hObj); 

if valid_Text_Entered
    USER_DATA.action = 'PROCEED';       % Go to next trial i. e. main path
    display_String = 'user_Proceed: Proceeding to next trial';
    disp(display_String);
    uiresume;
else

end

end



function user_Exit(hObj,event)

global USER_DATA

USER_DATA.action = 'QUIT';      
uiresume;

end

% No longer called
function valid_Indicator = valid_Text_Entered
        
global USER_DATA

valid_Indicator = true;

if length(USER_DATA.text_Entered) == 0
    valid_Indicator = false;
    my_Warning = sprintf('%s','In order to save, you must enter valid text or NR.  Otherwise, press Quit to end this session.');
    warndlg(my_Warning);
end

    
end


function word_Indicator = word_In_Dictionary(this_Word)

global USER_DATA

% Init false
word_Indicator = false;

% Loop through dictionary
num_Words = length(USER_DATA.dictionary.word);
for word_Num = 1:num_Words
    if strcmp( this_Word,strtrim(lower(USER_DATA.dictionary.word{word_Num})) )
        word_Indicator = true;
        break;
    end
end

end






