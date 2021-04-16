function ts_Array = SM_Get_Timestamps(CONST)

recordingDir = CONST.resultsDir;

% Init
output_Num = 0;
ts_Array = '';

% Get subjectIDs
folder_Array_SubjectID = SM_Get_Folders(recordingDir);

num_Subjects = length(folder_Array_SubjectID);
if num_Subjects > 0
    for subject_Num = 1:num_Subjects
        subject_Dir = sprintf('%s%s%s',recordingDir,char(folder_Array_SubjectID{subject_Num}),'/');
        folder_Array_Timestamp = SM_Get_Folders(subject_Dir);
        num_Timestamps = length(folder_Array_Timestamp);
        if num_Timestamps > 0
            for timestamp_Num = 1:num_Timestamps
                % Add this subjectID, timestamp to the list
                output_Num = output_Num + 1;
                ts_Array{output_Num} = {char(folder_Array_SubjectID{subject_Num}) char(folder_Array_Timestamp{timestamp_Num})};
            end
        else
            % Do nothing i.e. skip this one
        end
    end
else
    % No subjects
end