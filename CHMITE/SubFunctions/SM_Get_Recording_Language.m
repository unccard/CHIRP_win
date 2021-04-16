function lang = SM_Get_Recording_Language( CONST )

% Default
lang = 'EN';

x = strfind(CONST.word_List_Full_Path,'Spanish');
if ~isempty(x)
    % This is Spanish
    lang = 'SP';
end

x = strfind(CONST.word_List_Full_Path,'Greek');
if ~isempty(x)
    % This is Greek
    lang = 'GR';
end

display_String = sprintf('%s %s','This recording is in',lang);
%disp(display_String);
    

end

