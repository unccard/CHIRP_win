function target_List = SM_Get_Homonyms(CONST, sourceText, H)

% Include the source text in the target list
target_List{1} = sourceText;
target_Num = 1;

% Add any homonyms
num_Rows = length(H{1});
for row_Num = 1:num_Rows
    if strcmp(sourceText,H{1}{row_Num})
        target_Num = target_Num + 1;
        target_List{target_Num} = lower(strtrim(H{2}{row_Num}));
    end
end



