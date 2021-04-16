function SM_Controller_Per_Run(CONST)

%{
% A/V cues > TOKEN_DURATION > RECORD > Disable buttons/+++/[Startmasker] > FRINGE_DURATION > Visual cues/Enable buttons/Capture audio   > NEXT TRIAL > Disable buttons/stop recording/save audio
%                                                                                                                                       > REPEAT     > Disable buttons/stop recording
%                                                                                                                                       > QUIT       > Disable buttons/stop recording/save audio                                                       
%                           > REPEAT
%                           > QUIT
%}

%{ 
Assumptions:
    1.  If pitch-shift option is used, the pitch-shifted speech will be recorded as follows:
        a) If using STK (and e.g. M-Audio sound card), the pitch-shifted speech is fed back to channel 2's audio input
        b) If using Audapter (and MOTU), the pitch-shifted speech is captured via AudapterIO.
%}

% Need to know gender of subject (if pitch-shifting using Audapter)

% 20140402:     Starting with msk_R03 code, modify for replacement of
%               Speech Measures.

% 20140709:     Remove support for pitch-shifting and metronome


% Globals (for comm with UI)
global USER_DATA;        

% Defaults
action = 'PROCEED';                         % Can be 'PROCEED', 'REPEAT' or 'QUIT' or 'PAUSE'
repeat_Flag = false;

% Pause intervals
INTERVAL_BETWEEN_TRIALS = 3.0;              % secs
INTERVAL_BETWEEN_IMAGE_AND_TOKEN = 0.1;     % secs
FRINGE_DURATION = 0;                        % secs
AUDIO_SEGMENT = 1;                          % secs

% Convert from USER_DATA
CONST.subject_ID = USER_DATA.subject_ID;
CONST.record_Auto = USER_DATA.record_Auto;
CONST.record_After_Token = USER_DATA.record_After_Token;

%% SETUP AUDIO

% EB set up recorder ahead of time to reduce latency
r = audiorecorder(CONST.desired_Fs, 16, 1);

% Init PTB
%InitializePsychSound;        % SBL

% Open Channel for Audio Out
% Open the default audio device [], with default mode [] (==Only playback),
% and a required latencyclass of zero 0 == no low-latency mode, as well as
% a frequency of freq and nrchannels sound channels.
% This returns a handle to the audio device:
%pahandle_Out = PsychPortAudio('Open', [], [], 0, CONST.desired_Fs, CONST.nrchannels_Out);

% Open Channel for Audio In
% Open the default audio device [], with mode 2 (== Only audio capture),
% and a required latencyclass of zero 0 == no low-latency mode, as well as
% a frequency of 44100 Hz and 2 sound channels for stereo capture.
% This returns a handle to the audio device:
%try
%    pahandle_In = PsychPortAudio('Open', [], 2, 0, CONST.desired_Fs, CONST.nrchannels_In);
%catch err
    % Close output and retry with input/output on same device
%    PsychPortAudio('Close');
%    pause(1);
    %{ 
    If you perform simultaneous playback and recording, you can provide a 2 element vector
    for 'channels', specifying different numbers of output channels and input
    channels. The first element in such a vector defines the number of playback
    channels, the 2nd element defines capture channels. E.g., [2, 1] would define 2
    playback channels (stereo) and 1 recording channel.
    %}
%    pahandle_Master = PsychPortAudio('Open', [], 3+8, 0, CONST.desired_Fs, [2, 1]);
%    PsychPortAudio('Start',pahandle_Master,0,0,1);
%    pause(1);
    % Mode 2 is for record
%    pahandle_In = PsychPortAudio('OpenSlave', pahandle_Master, 2, 1);
    % Mode 1 is for Playback
%    pahandle_Out = PsychPortAudio('OpenSlave', pahandle_Master, 1, 1);
%end
    

% Preallocate an internal audio recording  buffer with a capacity of 10 seconds:
%PsychPortAudio('GetAudioData', pahandle_In, 10);



%% PREPARE TO RUN TRIALS

% Display instructions for this run
% Specify full paths for all of the instructions files
switch CONST.condition_String       % 'MASKER' or 'NONE'
    case 'MASKER'
        CONST.instructions_Full_Path = CONST.instructions_Full_Path_Masker;
    otherwise
        CONST.instructions_Full_Path = CONST.instructions_Full_Path_None;
end
fid_instr = fopen(CONST.instructions_Full_Path,'r');
k = 0;
tline = fgets(fid_instr);
while ischar(tline)
    k = k + 1;
    instr{k} = tline;
    tline = fgets(fid_instr);
end
fclose(fid_instr);
fhInstr = SM_Instructions_UI(CONST, instr);
uiwait(fhInstr);
close(fhInstr);
action = USER_DATA.action;
switch action
    case 'QUIT'
        return
    otherwise
        % Keep going
end

% Background
screen_Size = get(0,'ScreenSize');
background = figure('Visible','on','Name','CHMIT-E',...
            'MenuBar','none',...
            'Toolbar','none', ...
            'Color',[0.1 0.1 0.1],...
            'Position',screen_Size);



% Load and randomize word list / pert vals (and save the shuffled version
% of the ctl file)
%shuffled_Control_File_Full_Path = sprintf('%s%s%s%s%s%s', CONST.resultsDir, CONST.subject_ID, '/', CONST.subject_ID, CONST.experiment_ID, '.cfg');
%[idx_data stim_data stim_id wavFilenameForWordSansExtension ~] = randomize_Control_File_Data(CONST.control_File_Full_Path, shuffled_Control_File_Full_Path);

shuffled_WordList_Full_Path = sprintf('%s%s_%s_%s', CONST.ts_ResultsDir_Per_Subject, CONST.subject_ID, CONST.experiment_ID, 'WordList.txt');
[selected_Word, selected_WavFileNameSansExtension, randomized_List_Order] = SM_Get_WordList_Per_Run( CONST.word_List_Full_Path , shuffled_WordList_Full_Path );
stim_data = selected_Word;

% Initialize myResults
for i = 1:length(stim_data)
    myResults(i).recordedaudio = [];
end

% Init screen (so we don't pop up a new screen each trial
[fh1, text_Ctl, proceed_Button_Ctl, repeat_Ctl, quit_Ctl, record_Indicator_Ctl, pause_Button_Ctl] = SM_Record_UI;


    



%% RUN TRIALS

% Trials
trial_Num = 1;
num_Trials = length(stim_data);
while trial_Num <= num_Trials

    % USER INTERACTION #1:
    % a) Visual cues: Word flashes onto screen.  Optional image display.  
    % b) Associated audio is played.
    % c) Buttons are visible.  RECORD, REPEAT, and QUIT are enabled.    
    % Display word
    USER_DATA.word_To_Display = stim_data{trial_Num};
    set(text_Ctl,'String',USER_DATA.word_To_Display);
    % Display image
    if CONST.display_Image
        USER_DATA.image_To_Display = sprintf('%s%s%s',CONST.imageDir, USER_DATA.word_To_Display, CONST.imageExtension);
        if ~exist(USER_DATA.image_To_Display)
            USER_DATA.image_To_Display = '';
        end
    else
        USER_DATA.image_To_Display = '';
    end 
    %USER_DATA.image_To_Display
    if ~isempty(USER_DATA.image_To_Display)
        % Display image
        rgb = imread(USER_DATA.image_To_Display);
        axes('Position',[0.25, 0.1, 0.5, 0.5]);
        image(rgb);
        axis off;
    end
    % Play word
    pause(INTERVAL_BETWEEN_IMAGE_AND_TOKEN);
    wavFilenameForWord = sprintf('%s%s',selected_WavFileNameSansExtension{trial_Num},'.wav');
    disp(wavFilenameForWord)
    switch USER_DATA.language_Index_Selected
        case {2,3}
            % For Spanish and Greek, wav files are organized into subfolders per list
            wav_Subfolder = sprintf('%s %s%s','List',int2str(randomized_List_Order(trial_Num)),'/');
            this_WavDir = strcat(CONST.inputWavDir,wav_Subfolder);
        otherwise
            this_WavDir = CONST.inputWavDir;
    end
    
    % play with audioplayer instead of psych toolbox
    [token_Duration_Secs,h] = SM_PlayWav_PTB(wavFilenameForWord, this_WavDir, CONST.desired_Fs);
    token_Start_Tic = tic;
    
    if CONST.record_Auto
        % Auto Record
        % No need to enable buttons for RECORD, REPEAT or QUIT.  Just automatically select the RECORD option.
        title_String = sprintf('%s %s %s %s %s','CHMIT-E:  Trial',int2str(trial_Num),'of',int2str(num_Trials),' ');
        set(fh1,'Name',title_String);
        repeat_Flag = false;    % This will cause us to proceed on to recording (below)
    else
        % Manual Record
        % Set button properties to RECORD, REPEAT or QUIT and then wait for user to press a button
        set(repeat_Ctl, 'Visible','on','Enable','on');
        set(proceed_Button_Ctl,'String','RECORD (X)', 'Visible','on','Enable','on');
        set(quit_Ctl, 'Visible','on', 'Enable', 'on');
        % Prompt user for input--when to proceed
        title_String = sprintf('%s %s %s %s %s','CHMIT-E:  Trial',int2str(trial_Num),'of',int2str(num_Trials),':    Click RECORD to start recording');
        set(fh1,'Name',title_String);
        uiwait(fh1);
        action = USER_DATA.action;
        switch action
            case 'REPEAT'
                repeat_Flag = true;
            case 'QUIT'
                break;
            otherwise
                % Keep going 
                repeat_Flag = false;
        end
        % Disable and hide buttons
        set(repeat_Ctl, 'Visible','off','Enable','off');
        set(proceed_Button_Ctl,'String','RECORD (X)', 'Visible','off','Enable','off');
        set(quit_Ctl, 'Visible','off', 'Enable', 'off');
    end
    
    if ~repeat_Flag
        
        % User interaction #2: RECORD 
        % a) Start recording audio input from subject.
        % b) Prompt user to respond (REPEAT, NEXT TRIAL, or QUIT)
        %
        
        % If CONST.record_After_Token, wait until token is done playing;
        if CONST.record_After_Token
            while toc(token_Start_Tic) < token_Duration_Secs
                pause(0.1);
            end
        end
        
        % Start audio capture immediately and wait for the capture to start.
        % We set the number of 'repetitions' to zero,
        % i.e. record until recording is manually stopped.        
        %PsychPortAudio('Start', pahandle_In, 0, 0, 1);      
        
        % Display recording indicator
        set(record_Indicator_Ctl,'String','RECORDING');
        
        % Audio capture
        % (Since we're evaluating it every loop, no need to stuff
        % USER_DATA.action into action.)
        % EB functional recorder
        record(r);        
        
        % Reset USER_DATA.action ahead of next prompt (for audio capture)
        USER_DATA.action = '';
        
        % Init myResults
        myResults(trial_Num).recordedaudio = [];
        
        % Prompt user for input--when to stop this trial (and go on to the next one)
        % Set button properties to NEXT TRIAL, REPEAT or QUIT
        set(repeat_Ctl, 'Visible','on','Enable','on');     
        set(proceed_Button_Ctl,'String','NEXT TRIAL (X)', 'Visible','on','Enable','on');
        set(pause_Button_Ctl, 'Visible','on','Enable','on');
        set(quit_Ctl, 'Visible','on', 'Enable', 'on');
        title_String = sprintf('%s %s %s %s %s','CHMIT-E:  Trial',int2str(trial_Num),'of',int2str(num_Trials),':    Click NEXT TRIAL to go to the next trial; REPEAT to repeat this trial');
        set(fh1,'Name',title_String);
        refresh(fh1);

        while isempty(USER_DATA.action)
            %audiodata = PsychPortAudio('GetAudioData', pahandle_In);
            %pause(AUDIO_SEGMENT);
            %myResults(trial_Num).recordedaudio = [myResults(trial_Num).recordedaudio audiodata];  
            pause(0.1);
        end
        %audiodata = PsychPortAudio('GetAudioData', pahandle_In);
        %pause(AUDIO_SEGMENT/5);
        %myResults(trial_Num).recordedaudio = [myResults(trial_Num).recordedaudio audiodata];
        stop(r);
        myResults(trial_Num).recordedaudio = getaudiodata(r, 'double');
        
        % Disable and hide buttons AND remove displayed word
        set(repeat_Ctl, 'Visible','off','Enable','off');
        set(proceed_Button_Ctl,'String','RECORD (X)', 'Visible','off','Enable','off');
        set(pause_Button_Ctl, 'Visible','off','Enable','off');
        set(quit_Ctl, 'Visible','off', 'Enable', 'off');
        set(text_Ctl,'String','');

        % Before proceeding to next trial, we need to a) stop recording and b) stop masker (if necessary).
        % Stop recording
        %PsychPortAudio('Stop', pahandle_In);
        set(record_Indicator_Ctl,'String','');
        
        
        action = USER_DATA.action;
        switch action
            case 'PROCEED'

                % Save recording for this trial as a wav file
                outputWavFileName1 = sprintf('%s%s_%s_%s%s',CONST.ts_ResultsDir_Per_Subject, CONST.subject_ID, CONST.experiment_ID, selected_WavFileNameSansExtension{trial_Num},'.wav'); 
                %y_Channel1 = myResults(trial_Num).recordedaudio(1,:);
                % EB this method returns a single channel
                y_Channel1 = myResults(trial_Num).recordedaudio';
                audiowrite(outputWavFileName1, y_Channel1, CONST.desired_Fs); 
                
                % Check for clipping
                max_Amplitude = max(myResults(trial_Num).recordedaudio(1,:));
                if max_Amplitude >= 1 
                    warn_String = sprintf('%s %s%s','The max amplitude in the last recording was',num2str(max_Amplitude),'.  Values greater than 1 will be clipped in the wav file.');
                    fh_Warn = warndlg(warn_String);
                    uiwait(fh_Warn);
                end
                            
                % Display progress visually, but make sure focus stays on
                % the main screen
                %fh_wb = waitbar(trial_Num/num_Trials,' ','Position',[20 70 270 60], 'WindowStyle', 'normal');
                              
                % Next trial
                trial_Num = trial_Num + 1;
                pause(INTERVAL_BETWEEN_TRIALS);
                
                % Close waitbar so it doesn't interfere with hot keys
                %close(fh_wb)
                
            case 'QUIT'

                % Save recording for this trial as a wav file
                outputWavFileName1 = sprintf('%s%s_%s_%s%s',CONST.ts_ResultsDir_Per_Subject, CONST.subject_ID, CONST.experiment_ID, selected_WavFileNameSansExtension{trial_Num},'.wav'); 
                y_Channel1 = myResults(trial_Num).recordedaudio';
                audiowrite(outputWavFileName1, y_Channel1, CONST.desired_Fs);
                
                % Check for clipping
                max_Amplitude = max(myResults(trial_Num).recordedaudio(1,:));
                if max_Amplitude >= 1 
                    warn_String = sprintf('%s %s%s','The max amplitude in the last recording was',num2str(max_Amplitude),'.  Values greater than 1 will be clipped in the wav file.');
                    fh_Warn = warndlg(warn_String);
                    uiwait(fh_Warn);
                end                
                
                break;  % Exit out of the trial loop
                
            case 'REPEAT'
                % Do nothing i.e. don't save audio and don't increment to
                % next trial number
                
            case 'PAUSE'
                % Do not save recording and do not increment to next trial.
                % So, this is like REPEAT except we wait for a
                % USER_DATA.action that is not PAUSE.
                
                % Prompt user for input--when to stop this trial (and go on to the next one)
                % Set button properties to REPEAT or QUIT
                set(repeat_Ctl, 'Visible','on','Enable','on');     
                set(quit_Ctl, 'Visible','on', 'Enable', 'on');
                title_String = sprintf('%s %s %s %s %s','CHMIT-E:  Trial',int2str(trial_Num),'of',int2str(num_Trials),':    Click REPEAT to repeat this trial');
                set(fh1,'Name',title_String);
                set(record_Indicator_Ctl,'String','PAUSED');
                refresh(fh1);
                
                % Wait
                while (strcmp(USER_DATA.action,'PAUSE'))
                    pause(1);
                end
                set(record_Indicator_Ctl,'String','');
                
                % Toggle buttons off again
                set(repeat_Ctl, 'Visible','off','Enable','off');     
                set(quit_Ctl, 'Visible','off', 'Enable', 'off');
                
                if (strcmp(USER_DATA.action,'QUIT'))
                    break;
                end
                
            otherwise
                error('Unknown USER_DATA.action');
        end
    
    end % if ~repeat_flag
   
    % Turn off display of image.
    if ~isempty(USER_DATA.image_To_Display)
        cla
    end 
    
      
end


%% SHUTDOWN

% Close any screens still open
close(fh1);
close(background);
try
    close(fh_wb);
catch err
end

% Stop and close the audio devices:
%PsychPortAudio('Close', pahandle_Out);
%PsychPortAudio('Close', pahandle_In);


%% SAVE SETTINGS
matfileName = sprintf('%s%s_%s_%s%s',CONST.ts_ResultsDir_Per_Subject, CONST.subject_ID, CONST.experiment_ID, 'CONST','.mat');
save(matfileName,'CONST');






