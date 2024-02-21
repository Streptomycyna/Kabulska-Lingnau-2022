function Analysis1_infoAboutActions(resDir)
% Get number of ratings per action that we'll need later 

% The output goes to 'ratingsPerAction'
% Next step: Part1 - to Analysis2_featureRedunancyRemoval;
%            Part2 - to Analysis2_recodeLocationToBinary
%    afterwards, both - to Analysis3_normalization

%% Part 1
rawData = xlsread(fullfile(resDir,'raw/Raw_part1.xlsx'));
NumberOfRatings = [10,10,10,9,9,9,9,9,10,11,10,11,11,9,9,9,9,9,11,9,11,11,9,9,9,9,9,9,9,...
    10,9,10,9,11,9,9,9,9,9,9,11,9,9,9,10,10,9,9,9,9,9,9,9,9,10,11,9,9,9,10,9,9,9,10,...
    9,9,10,9,9,11,9,10,9,9,9,9,9,9,9,9,9,10,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9];
resultList = rawData;
save(fullfile(resDir,'resultList_part1'), 'resultList')
ratingsPerAction = NumberOfRatings;
save(fullfile(resDir,'ratingsPerAction_part1'), 'ratingsPerAction')

%% Part 2
rawData = xlsread(fullfile(resDir,'raw/Raw_part2.xlsx'));
NumberOfRatings = [8,8,8,8,7,7,7,9,8,7,7,7,7,7,7,7,8,8,7,7,7,8,8,7,7,7,7,8,8,...
    7,7,8,7,8,7,7,7,7,7,8,8,8,7,7,8,8,7,8,8,7,7,7,7,8,7,8,7,8,7,8,7,8,7,7,7,7,8,...
    9,7,8,7,8,9,8,8,7,7,7,7,7,8,7,7,7,7,8,7,7,9,7,7,8,7,7,7,9,7,8,7,8];
resultList = rawData;
save(fullfile(resDir,'resultList_part2'), 'resultList')
ratingsPerAction = NumberOfRatings;
save(fullfile(resDir,'ratingsPerAction_part2'), 'ratingsPerAction')

end