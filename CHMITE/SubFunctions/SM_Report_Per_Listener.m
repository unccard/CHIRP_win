function SM_Report = SM_Report_Per_Listener(CONST, listenerUID)

% This function returns an array of strings.  The caller can then append
% each string to an output file.  The format of the string is the eval
% string with the following information added to the end:
%   -sourceText
%   -score {Correct,Incorrect}

%% Open Homonym List file
homonym_Fullpath = CONST.homonym_List_Full_Path;
fid_Homonym = fopen(homonym_Fullpath, 'r');
H = textscan(fid_Homonym,'%s%s','Delimiter',',');
fclose(fid_Homonym);


%% Open Eval file
eval_Filename = sprintf('%s_%s%s','eval_CHMITE',listenerUID,'.csv');
eval_Fullpath = strcat(CONST.evalDir,eval_Filename);
eval_Test = exist(eval_Fullpath,'file');

if eval_Test > 0
    % Eval file exists for this listener.  Try to open it.
    try
        fid_Eval = fopen(eval_Fullpath, 'r','n','windows-1253');
    catch err
        % Problem opening eval file for this listener or it does not exist yet
        display_String = sprintf('%s %s','Error opening eval file for listener',listenerUID);
        disp(display_String);
        SM_Report = [];
        return
    end
else
    % No eval file for this listener
    SM_Report = [];
    display_String = sprintf('%s %s','No eval file for listener',listenerUID);
    disp(display_String);
    return
end

%% Get Eval strings (with entered text per wav file) from eval file
% For specified listenerUID, get the eval strings, like
% listenerUID, subjectID, recordingSessionTimestamp, wavFilename,textEntered,evalTimestamp
% e.g. slockhar,09876,Jul_12_2014_13_00_09,09876SI-road1.wav,road1,Jul_25_2014_19_58_11
try
    C = textscan(fid_Eval,'%s%s%s%s%s%s','Delimiter',',');
catch err
    SM_Report = [];
    warn_String = sprintf('%s %s','Encountered a problem reading the evaluation file for listener',listenerUID);
    warndlg(warn_String);
    return
end
fclose(fid_Eval);


%% Score
% For each wav file, get the sourceText.  Get a list of homonyms for the
% sourceText (if any).  If the textEntered matches the sourceText or one of
% its homonyms, record a match (Correct); otherwise, record a miss
% (Incorrect).  Add source text and score to each string.
num_Rows = length(C{1});
SM_Report = cell(num_Rows,1);
for row_Num = 1:num_Rows
    % Parse eval string
    subjectID = C{2}{row_Num};
    timestamp = C{3}{row_Num};
    wavFilename = C{4}{row_Num};
    textEntered = C{5}{row_Num};
    textEnteredMod = lower(strtrim(textEntered));
    % Derive recording wav dir
    recording_Wav_Dir = sprintf('%s%s/%s/',CONST.resultsDir,subjectID,timestamp);
    % Get source text
    sourceText = SM_Get_Source_Text(CONST, subjectID, recording_Wav_Dir, wavFilename);
    if isempty(sourceText)
        score = 'ERROR';
        display_String = sprintf('%s %s %s %s %s %s','Report: could not derive source text given subjectID=',subjectID,'; recording_Wav_Dir=',recording_Wav_Dir,'; wavFilename=',wavFilename);
        disp(display_String);
    else
        if strcmp(textEnteredMod,'nr')
            score = 'NR';
        else
             % Get homonyms.  This list includes the original source text
            target_List = SM_Get_Homonyms(CONST, sourceText, H);
            % Compare text entered to target list
            num_Targets = length(target_List);
            score = 'Incorrect';
            for target_Num = 1:num_Targets
                if strcmp(textEnteredMod,target_List{target_Num})
                    score = 'Correct';
                    break;
                end
            end 
        end
    end
    % Append to end of string
    SM_Report{row_Num} =  sprintf('%s,%s,%s,%s,%s,%s,%s,%s',    C{1}{row_Num},C{2}{row_Num},C{3}{row_Num},C{4}{row_Num},C{5}{row_Num},C{6}{row_Num},...
                                                                sourceText,score);
end





