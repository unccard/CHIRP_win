function [ CONST ] = SM_SetConstants_Per_Language(CONST)

% This just the start of override of constants if language is not English.
% At this point, since we're just doing Record, we defer homonymns and
% dictionaries.

global USER_DATA

switch USER_DATA.language_Index_Selected
    case 2
        % Specify where the target wav files are stored
        CONST.inputWavDir = './Config/spanish_Targets/';
        % Specify where the word list is
        CONST.word_List_Full_Path = './Config/CHMITE_WordList_Spanish.csv';
    case 3
        % Specify where the target wav files are stored
        CONST.inputWavDir = './Config/greek_Targets/';
        % Specify where the word list is
        CONST.word_List_Full_Path = './Config/CHMITE_WordList_Greek.csv';
    otherwise
        % Leave the default (English), which was set in SM_SetConstants.m.
end












