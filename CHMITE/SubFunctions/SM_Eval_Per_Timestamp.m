function Eval = SM_Eval_Per_Timestamp(CONST, AssignedTask)

% This function accepts an AssignedTask and returns an Eval struct, having
% the following fields:
%   -subjectID (from AssignedTask)
%   -timestamp (from AssignedTask)
%   -wav(n).wavFilename
%   -wav(n).textEntered
%   -wav(n).evalTimestamp
%   -status {'INITIAL', 'WIP', 'COMPLETE'}

% The Eval.status tells the caller what to do with the Eval.

global USER_DATA 

Eval = struct;
Eval.status = 'INITIAL'; 

% Derive recording wav dir
recording_Wav_Dir = sprintf('%s%s/%s/',CONST.resultsDir,AssignedTask.subjectID,AssignedTask.timestamp);

% Copy AssignedTask.subjectID,AssignedTask.timestamp to Eval
Eval.subjectID = AssignedTask.subjectID;
Eval.timestamp = AssignedTask.timestamp;

% Is there already a WIP for this subjectID, timestamp?  If so, get the data from the WIP (already completed)
[WIP_status, WIPTask] = SM_Get_WIPTask(CONST, AssignedTask);
if WIP_status > 0
   num_WIP_Wavs = length(WIPTask.wav); 
else
    num_WIP_Wavs = 0;
end

% Determine whether this task is in English or not
matfileName = sprintf('%s%s_%s_%s%s',recording_Wav_Dir, Eval.subjectID, CONST.experiment_ID, 'CONST','.mat');  % Copied from SM_Controller_Per_Run
if exist(matfileName,'file') > 0
    V = load(matfileName);
    lang = SM_Get_Recording_Language( V.CONST );
else
    lang = 'EN'; % Default
end
USER_DATA.lang = lang;

% Load the appropriate dictionary (per language)
switch lang
    case 'EN'
        % Load dictionary (which sets USER_DATA.dictionary.word{word_Num})
        dictionary_Full_Path = CONST.dictionary_Full_Path_EN;        
    case 'SP'
        dictionary_Full_Path = CONST.dictionary_Full_Path_SP;
    case 'GR'
        dictionary_Full_Path = CONST.dictionary_Full_Path_GR;
    otherwise
        dictionary_Full_Path = CONST.dictionary_Full_Path_EN;
end
SM_Load_Dictionary(dictionary_Full_Path,lang);


% Process individual wav files for this task (ts)
file_Search_String = sprintf('%s%s',recording_Wav_Dir,'*.wav');
dir_List = dir(file_Search_String);
[rows, cols] = size(dir_List);
num_Files = rows;
randomized_Index = randperm(num_Files);
if num_Files > 0
    display_String = sprintf('%s %s %s %s','Found',int2str(num_Files),'files in',recording_Wav_Dir);
    disp(display_String);
    % For each wav file in the recording_Wav_Dir
    for k = 1:num_Files
        % Get wav file full path
        wav_File_Name = dir_List(randomized_Index(k)).name;
        wav_File_Name_Trimmed{k} = strtrim(wav_File_Name);
        wav_File_Fullpath = sprintf('%s%s',recording_Wav_Dir,char(wav_File_Name_Trimmed{k}));
        % If this wavefile is in the WIP, skip it; otherwise, pass it to the listener ui.
        skip_This_Wav = false;
        if num_WIP_Wavs > 0 
            for WIP_Wav_Num = 1:num_WIP_Wavs
                if strcmp(char(wav_File_Name_Trimmed{k}),WIPTask.wav(WIP_Wav_Num).wavFilename)
                    skip_This_Wav = true;
                    WIP_Wav_Num_Saved = WIP_Wav_Num;
                    break;  % break out of this loop on WIP Wavs as soon as we find a match
                end
            end
        end
        if skip_This_Wav          
            % Save WIPTask to Eval struct (to be returned)
            Eval.wav(k).wavFilename = char(wav_File_Name_Trimmed{k});
            Eval.wav(k).textEntered = WIPTask.wav(WIP_Wav_Num_Saved).textEntered;
            Eval.wav(k).evalTimestamp = WIPTask.wav(WIP_Wav_Num_Saved).evalTimestamp;          
            USER_DATA.action = 'PROCEED';   % Simulate user
        else
            % Get input from listener
            display_String = sprintf('%s %s','Evaluating', wav_File_Fullpath);
            disp(display_String);
            %msgbox(display_String);
            wav_File_Fullpath
            [waveform,Fs] = audioread(wav_File_Fullpath);
            [fh_Eval] = SM_Eval_UI(waveform(:,1), Fs);
            uiwait(fh_Eval);
            close(fh_Eval);
            if strcmp(USER_DATA.action, 'PROCEED')
                % Save to Eval struct (to be returned)
                Eval.wav(k).wavFilename = char(wav_File_Name_Trimmed{k});
                Eval.wav(k).textEntered = USER_DATA.text_Entered;
                Eval.wav(k).evalTimestamp = datestr(now(),'mmm_dd_yyyy_HH_MM_SS');
            else
                % QUIT
                break;
            end
            %pause(1);  % pause before next iteration
        end
    end
    % After processing the wav files for this task (ts), now update the status of this set.
    if strcmp(USER_DATA.action, 'PROCEED')
        % We got through the loop on wav files without quitting, so, the task (ts) must be complete.
        Eval.status = 'COMPLETE';
    else
        if k > 1    % If user quits before processing the first item, there should be no WIP
            Eval.status = 'WIP';
        end
    end
end



