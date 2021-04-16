function [ CONST ] = SM_SetConstants

% Values for dev environment (Steve's laptop) have been commented out.

% Specify directory for results
% Sub-directories will be created per subject_Num
CONST.resultsDir = './Recordings/';

% Specify where the target wav files are stored
CONST.inputWavDir = './Config/english_Monosyllabic/';

% Specify dir for assigned tasks
CONST.assignedTasksDir = './Tasks/AssignedTasks/';

% Specify dir for completed tasks
CONST.completedTasksDir = './Tasks/CompletedTasks/';

% Specify dir for WIP
CONST.WIPDir = './Tasks/WIP/';

% Specify dir for Evals
CONST.evalDir = './Tasks/Eval/';

% Specify where the word list is
CONST.word_List_Full_Path = './Config/CHMITE_WordList.csv';

% Specify where the word list is
CONST.homonym_List_Full_Path = './Config/CHMITE_Homonyms.csv';

% Specify dictionary fullpath
CONST.dictionary_Full_Path_EN = './Config/dictionaries/en_US_SBL.dic';
CONST.dictionary_Full_Path_SP = './Config/dictionaries/es_ES_1252.txt';
CONST.dictionary_Full_Path_GR = './Config/dictionaries/el_GR_1253.txt';

% Specify whether this is English-only version.  If so, do not give the
% user an option to select the language.
CONST.english_Only = true;


% Specify where the listener list is
CONST.listener_List_Full_Path = './Config/CHMITE_ListenerUIDs.txt';

% Specify dir for Reports
CONST.reportDir = './Reports/';

% Specify condition.  For Speech Meaasure, set to NONE
CONST.condition_String = 'NONE';                     % Use 'MASKER', 'PITCH-SHIFT', 'METRONOME', or 'NONE'

% Specify directory where images are stored.  The images should have the
% same name as the text displayed.
CONST.imageDir = './Images/';
%CONST.imageExtension = '.jpg';
CONST.imageExtension = '.bmp';

% Specify desired frequency when playing audio (in Hz)
CONST.desired_Fs = 48000;

%Specify full paths to all the instructions files (1 per condition)
CONST.instructions_Full_Path_None = './Instructions/CHMITE_Instructions.txt';

% Specify number of audio input/output channels
CONST.nrchannels_In = 2;
CONST.nrchannels_Out = 1; 

% Capture userid
CONST.userid = getenv('USERNAME');

% The following have been moved to the user interface
%{
% Indicate if you want automatic recording (true/false).  If false, the
% user/subject will have to press a button to start recording.
CONST.record_Auto = false;

% Indicate if you want to wait until after the token plays before starting
% to record.  If false, recording will start while the token is playing--an
% option that should be selected if the token is played over headphones.
CONST.record_After_Token = false;
%}








