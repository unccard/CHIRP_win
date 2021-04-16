function listener_Task_File = SM_Get_Task_Files(CONST, listenerID, complete)

if complete
    input_Dir = CONST.completedTasksDir;
else
    input_Dir = CONST.assignedTasksDir;
end
file_Search_String = sprintf('%s%s%s%s',input_Dir,'*',listenerID,'*.csv');
try
    dir_List = dir(file_Search_String);
    [rows, cols] = size(dir_List);
    num_Files = rows;
catch err
    num_Files = 0;
end

% Get the task list
if num_Files > 0
    task_File_Datenum = zeros(1,num_Files);
    display_String = sprintf('%s %s %s %s','Found',int2str(num_Files),'files in',input_Dir);
    disp(display_String);
    % For each task file in the assigned task dir (for this listener)
    for k = 1:num_Files
        task_File_Name = dir_List(k).name;
        task_File_Name_Trimmed{k} = strtrim(task_File_Name);
        %task_File_Datenum(k) = dir_List(k).datenum
    end
    % Order task list by datenum
    %[~,sort_Index] = sort(task_File_Datenum);
    sort_Index = randperm(num_Files);
    for k = 1:num_Files
        listener_Task_File{k} = task_File_Name_Trimmed{sort_Index(k)};
    end
else
    listener_Task_File = '';
end




