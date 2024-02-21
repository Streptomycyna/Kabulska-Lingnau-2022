function Analysis5_putTogether_reduced(resDir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the order and put them together

T_part1 = xlsread(fullfile(resDir,'averaged_featureRatings_part1_reduced.xlsx'));
T_part2 = xlsread(fullfile(resDir,'averaged_featureRatings_part2.xlsx'));

T = [T_part1(1:29,:);T_part2(4:5,:);T_part1(30,:);T_part2(1:3,:);T_part1(31:36,:);T_part2(6:8,:)];

% 1:29 - Body parts (5), Objects (5), Trajectory (4), Type of limb mv. (10),
% Posture (5)
% 30:31 - Location
% 32 - Keeping balance
% 33:35 - Harm, Water, Season-dependence
% 36:41 - Change of location, Duration, Contact with others, Pace, Use of
% force, Goal-directedness
% 42:44 - Concentration, Noise, Emotions

new_TT = array2table(T);
pathAndName = fullfile(resDir,'MainResults_avg_reduced.xlsx');
writetable(new_TT, pathAndName);

%% Binarize
clear new_TT
yesno_rating = T(1:40,:);
rounded = round(yesno_rating);
roundedList = T;
roundedList(1:40,:) = rounded;
new_TT = array2table(roundedList);
pathAndName = fullfile(resDir,'MainResults_bin_reduced.xlsx');
writetable(new_TT, pathAndName);

end