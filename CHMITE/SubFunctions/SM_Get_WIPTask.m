function [status, WIPTask] = SM_Get_WIPTask(CONST, AssignedTask)

% WIPTask has following structure
%{
    WIPTask.wav(n).wavFilename;
    WIPTask.wav(n).textEntered;
    WIPTask.wav(n).evalTimestamp;
%}

%AssignedTask
WIPTask = struct; 
    
% Does WIP file exist for this assigned task?
WIP_Filename = sprintf('%s_%s_%s_%s%s', 'eval_CHMITE', CONST.userid, AssignedTask.subjectID, AssignedTask.timestamp,'.csv');
WIP_Fullpath = strcat(CONST.WIPDir,WIP_Filename);
WIPTest = exist(WIP_Fullpath,'file');

if WIPTest > 0
    % There is a WIP 
    % Set status
    status = 1;
    % Parse WIP
    fid_WIP = fopen(WIP_Fullpath,'r');
    C = textscan(fid_WIP,'%s%s%s%s%s%s','Delimiter',',');
    num_WIP_Rows = length(C{1});
    for WIP_Row_Num = 1:num_WIP_Rows
        WIPTask.wav(WIP_Row_Num).wavFilename = C{4}{WIP_Row_Num};
        WIPTask.wav(WIP_Row_Num).textEntered = C{5}{WIP_Row_Num};
        WIPTask.wav(WIP_Row_Num).evalTimestamp = C{6}{WIP_Row_Num};
    end
    fclose(fid_WIP)
else
    % There is no WIP 
    % Set status
    status = 0;
end