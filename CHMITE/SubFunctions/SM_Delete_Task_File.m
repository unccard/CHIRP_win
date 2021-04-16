function SM_Delete_Task_File(CONST, this_subjectID, this_timestamp, this_listenerID)

% Delete assigned task "message" file like task_CHMITE_jlo_09875_Jul_14_2014_13_00_09

% Determine fullpath
fullpath = sprintf('%s%s_%s_%s_%s%s',CONST.assignedTasksDir,'task_CHMITE', this_listenerID, this_subjectID,this_timestamp,'.csv'); 
display_String = sprintf('%s %s','SM_Delete_Task_File: fullpath = ',fullpath);
disp(display_String);
    
if exist(fullpath,'file') > 0
    display_String = sprintf('%s %s','Trying to delete',fullpath);
    disp(display_String);
    % Delete (empty) file 
    try
        delete(fullpath);
    catch err
        % Display
        disp(err)
    end
end


