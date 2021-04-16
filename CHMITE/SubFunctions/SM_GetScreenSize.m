% This was added to normalize screen size across functions and to limit the
% maximum window size when this is run on a large screen.
% EB 3/23/21

function win_Size = SM_GetScreenSize

win_Size = get(0,'ScreenSize');      % [1 1 W H]

MaxWidth = 1500;
MaxHeight = 1000;

if win_Size(3) > MaxWidth
    MarginPts = (win_Size(3) - MaxWidth)/2;
    win_Size(1) = MarginPts;
    win_Size(3) = MaxWidth;
end

if win_Size(4) > MaxHeight
    MarginPts = (win_Size(4) - MaxHeight)/2;
    win_Size(2) = MarginPts;
    win_Size(4) = MaxHeight;
end
