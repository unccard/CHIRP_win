function [selected_Word_Shuffled, selected_WavFileNameSansExtension_Shuffled, randomized_List_Order] = SM_Get_WordList_Per_Run( wordList_File,  shuffled_WordList_Full_Path)

% This function randomly chooses one word per list.  The chosen words are
% then shuffled, so the list number is also random.

% wordToDisplay and wavFileNameSansExtension are cell arrays 1 x num_Lines-1 (in the wordList i.e.
% #words as we skip the header).  listNum is an array 1 x num_Lines-1

global USER_DATA

% Open and textscan word list
fid_wordList = fopen(wordList_File);
wordList =  textscan(fid_wordList,'%s %s %s', 'Delimiter', ',');

% Extract useful data, skipping header row, processing wordList{column}{row}
num_Lines = length(wordList{1});
num_Words = num_Lines - 1;
for k = 1:num_Words
    f1{k} = wordList{1}{k+1};
    f2{k} = wordList{2}{k+1};
    f3{k} = wordList{3}{k+1};
end

% Convert list number to int array
listNum = zeros(1,num_Words);
for k = 1:num_Words
    listNum(k) = str2num(f1{k});
end

% Now that we know how many lists there are, get ready to select a word per
% list
max_ListNum_Value = max(listNum);
selected_Word = cell(1,max_ListNum_Value);
selected_WavFileNameSansExtension = cell(1,max_ListNum_Value);
selected_Word_Shuffled = cell(1,max_ListNum_Value);
selected_WavFileNameSansExtension_Shuffled = cell(1,max_ListNum_Value);

% Pick a word from each list (or for now, just the index of the word in the
% list)
for listNum_Value = 1:max_ListNum_Value
    % Which index values belong to this list?  (Don't assume the words are
    % in order.)
    index_Per_ListNum_Value = find(listNum == listNum_Value);
    % How many words per list?
    num_Words_Per_List = length(index_Per_ListNum_Value);
    % Pick one
    pointer = randi(num_Words_Per_List);
    selected_Index = index_Per_ListNum_Value(pointer);
    selected_Word{listNum_Value} = f2{selected_Index};
    selected_WavFileNameSansExtension{listNum_Value} = strtrim(f3{selected_Index});
    % Modify wav filename if language is Spanish (2) or Greek (3).
    % Otherwise, if English (1) leave as is. This modification is needed
    % because wav files for these languages had the list# pre-pended to the
    % filename as well as a folder per list#.  Only the filename is
    % addressed here.  The subfolder is handled by the caller.
    switch USER_DATA.language_Index_Selected
        case {2,3}
            selected_WavFileNameSansExtension{listNum_Value} = sprintf('%s %s',int2str(listNum_Value),selected_WavFileNameSansExtension{listNum_Value});
        otherwise
    end
end

% Close word list
fclose(fid_wordList);

% At this point, we have a selected_Word from each list and its associated
% wav file name (sans extension).  Now, we need to randomize over the
% lists.
randomized_List_Order = randperm(max_ListNum_Value);


% Shuffle and save the shuffled word list
fid_Shuffled = fopen(shuffled_WordList_Full_Path,'w');
fprintf(fid_Shuffled,'%s\r\n','TrialNum,WordPresented,WavFilePlayed');
for k = 1:max_ListNum_Value
    selected_List = randomized_List_Order(k);
    selected_Word_Shuffled{k} = selected_Word{selected_List};
    selected_WavFileNameSansExtension_Shuffled{k} = selected_WavFileNameSansExtension{selected_List};
    myString = [int2str(k),',', ...
                selected_Word_Shuffled{k},',', ...
                selected_WavFileNameSansExtension_Shuffled{k} ];
    fprintf(fid_Shuffled,'%s\r\n',myString);
end
fclose(fid_Shuffled);


