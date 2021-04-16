function CONST = SM_Mkdirs(CONST)

global USER_DATA

% Create result dir per subject, if necessary
resultsDir_Per_Subject = sprintf('%s%s%s',CONST.resultsDir, USER_DATA.subject_ID,'/');
if ~exist(resultsDir_Per_Subject)
    mkdir(resultsDir_Per_Subject);
end

% Create timestamped sub-directory
TimeStamp=datestr(now(),'mmm_dd_yyyy_HH_MM_SS');
ts_ResultsDir_Per_Subject = sprintf('%s%s%s',resultsDir_Per_Subject, TimeStamp,'/');
sprintf('%s %s','Creating the following directory to store this sessions recordings:',ts_ResultsDir_Per_Subject); 
mkdir(ts_ResultsDir_Per_Subject);

% Return
CONST.ts_ResultsDir_Per_Subject = ts_ResultsDir_Per_Subject;


