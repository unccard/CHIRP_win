function folder_Array = SM_Get_Folders(input_Dir)

file_Search_String = strcat(input_Dir,'*');
dir_Struct = dir(file_Search_String);
num_Files = length(dir_Struct);
if num_Files > 0
    display_String = sprintf('%s %s %s %s','Found',int2str(num_Files),'files using search string',file_Search_String);
    disp(display_String);
    folder_Num = 0;
    % For each  folder
    for k = 1:num_Files
        if ~isempty(strfind(dir_Struct(k).name,'.')) || ~dir_Struct(k).isdir  % Either . or .. or not a dir
            % Skip this one
        else
            % Use this one
            folder_Num = folder_Num + 1;
            folder_Name{folder_Num} = dir_Struct(k).name;
        end
    end
    if folder_Num > 0
        folder_Array = folder_Name;
    else
        folder_Array = '';
    end
else
    folder_Array = '';
end