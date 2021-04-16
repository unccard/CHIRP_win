function sourceText = SM_Get_Source_Text(CONST, subjectID, recording_Wav_Dir, wavFilename)

% Init
sourceText = '';

% Extract segment from wavFilename
strpos1 = strfind(wavFilename,'_CHMITE_') + 8;
strpos2 = strfind(wavFilename,'.wav') - 1;
wavFilename_Segment = wavFilename(strpos1:strpos2);

% Get subject's wordList
wordList_Fullpath = sprintf('%s%s%s',recording_Wav_Dir,subjectID,'_CHMITE_WordList.txt');
fid_WL = fopen(wordList_Fullpath,'r','n','windows-1253');
if fid_WL > 0
    W = textscan(fid_WL,'%s%s%s','Delimiter',',');
    fclose(fid_WL);
else
    return
end

% Determine whether this task is in English or not
matfileName = sprintf('%s%s_%s_%s%s',recording_Wav_Dir, subjectID, CONST.experiment_ID, 'CONST','.mat');  % Copied from SM_Controller_Per_Run
if exist(matfileName,'file') > 0
    V = load(matfileName);
    lang = SM_Get_Recording_Language( V.CONST );
else
    lang = 'EN'; % Default
end

% Get source text from wordList, given the wavFilename segment
if strcmp(lang,'EN') 
    num_Rows = length(W{1});
    for row_Num = 1:num_Rows
        target_Text = lower(strtrim((W{3}{row_Num})));
        if strcmp(wavFilename_Segment,target_Text)
            sourceText = lower(strtrim((W{2}{row_Num})));
            break;
        end
    end
else
    alt_Start_Pos = strfind(wavFilename_Segment, ' ') + 1;
    sourceText = wavFilename_Segment(alt_Start_Pos(1):end);
end

