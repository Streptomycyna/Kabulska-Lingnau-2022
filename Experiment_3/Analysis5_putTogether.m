function Analysis5_putTogether(resDir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the order and put them together
T_part1 = xlsread(fullfile(resDir,'averaged_featureRatings_part1.xlsx'));
T_part2 = xlsread(fullfile(resDir,'averaged_featureRatings_part2.xlsx'));

T = [T_part1(1:34,:);T_part2(4:5,:);T_part1(35,:);T_part2(1:3,:);T_part1(36:41,:);T_part2(6:8,:)];

% 1:34 - Body parts (10), Objects (5), Trajectory (4), Type of limb mv.(10),
% Posture (5)
% 35:36 - Location
% 37 - Keeping balance
% 38:40 - Harm, Water, Season-dependence
% 41:46 - Change of location, Duration, Contact with others, Pace, Use of
% force, Goal-directedness
% 47:49 - Concentration, Noise, Emotions

new_TT = array2table(T);
pathAndName = fullfile(resDir,'MainResults_avg.xlsx');
writetable(new_TT, pathAndName);

%% Binarize
clear new_TT
yesno_rating = T(1:40,:);
rounded = round(yesno_rating);
roundedList = T;
roundedList(1:40,:) = rounded;
new_TT = array2table(roundedList);
pathAndName = fullfile(resDir,'MainResults_bin.xlsx');
writetable(new_TT, pathAndName);

end