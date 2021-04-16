function SM_Gen_Task_File(CONST, this_subjectID, this_timestamp, this_listenerID)

% Write assigned task "message" file like task_CHMITE_jlo_09875_Jul_14_2014_13_00_09

% Determine fullpath
fullpath = sprintf('%s%s_%s_%s_%s%s',CONST.assignedTasksDir,'task_CHMITE', this_listenerID, this_subjectID,this_timestamp,'.csv'); 

if exist(fullpath,'file') == 0
    % Create (empty) file 
    fid = fopen(fullpath,'w');
    fclose(fid);
end


