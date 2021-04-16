function SM_Load_Dictionary(dictionary_Fullpath,lang)

global USER_DATA

%% Open Dictionary
switch lang
    case 'EN'
        fid_Dictionary = fopen(dictionary_Fullpath, 'r');
    case 'SP'
        fid_Dictionary = fopen(dictionary_Fullpath, 'r','n','windows-1252');
    case 'GR'
        fid_Dictionary = fopen(dictionary_Fullpath, 'r','n','windows-1253');
    otherwise
        fid_Dictionary = fopen(dictionary_Fullpath, 'r');
end
%pwd
%dictionary_Fullpath
H = textscan(fid_Dictionary,'%s');
fclose(fid_Dictionary);

num_Words = length(H{1});
k = 1;
for word_Num = 1:num_Words
    tmp = H{1}{word_Num};
    if ~isempty(strfind(tmp,'ZZZ')) || (length(tmp) < 2)
        % Skip this one
    else
        pos1 = strfind(tmp,'/');
        if ~isempty(pos1) && pos1(1) > 1
            tmp2 = tmp(1:pos1(1)-1);
        else
            tmp2 = tmp;
        end
        USER_DATA.dictionary.word{k} = tmp2;
        k = k + 1;
    end
end