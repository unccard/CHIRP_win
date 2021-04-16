function [status, thisAssignedTask] = SM_Gen_AssignedTask_From_Task_File(this_Listener_Task_File)

% The filename convention for listener task files is task_CHMITE_listenerUID_subjectID_timestamp.csv
% So, we just need to extract subjectID and ts from the filename.  Note
% that the timestamp has underscores in it.

% Init
thisAssignedTask = struct;
status = 1;

% SubjectID is between the third and fourth underscores
x = strfind(this_Listener_Task_File,'_');
if length(x) < 4
    status = 0;
    display_String = sprintf('%s %s %s','Could not parse task filename',this_Listener_Task_File,': Not enough underscores.');
    disp(display_String);
    return
else
    start_Pos = x(3) + 1;
    end_Pos = x(4) - 1;
    thisAssignedTask.subjectID = this_Listener_Task_File(start_Pos:end_Pos);
end

% Timestamp between fourth underscore and period
y = strfind(this_Listener_Task_File,'.csv');
if length(y) ~= 1
    status = 0;
    display_String = sprintf('%s %s %s','Could not parse task filename',this_Listener_Task_File,': Number of dots not equal 1.');
    disp(display_String);
    return
else
    start_Pos = x(4) + 1;
    end_Pos = y(1) - 1;
    thisAssignedTask.timestamp = this_Listener_Task_File(start_Pos:end_Pos);
end

    
    
    






