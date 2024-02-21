function Analysis3_normalizationOfRatings(resDir)
%%%%%%%%%%
% I'm normalizing the data to have values from 0 to 1
% Input: Part1: Analysis2_featurRedundancyRemoval (file
% 'resultList_part1_afterReduction')
% Part2: Analysis2_recodeLocationToBinary (file 'resultList_part2')
% Next step: Analysis4_meanOfRatings

%% Part 1
load(fullfile(resDir,'resultList_part1_afterReduction'));
T=newList; % it's already ordered by binaries and continuous
yesno_rating = T([1:35],:);
% Normalization of Yes/No ratings
yesno_rating(yesno_rating==1)=0;
yesno_rating(yesno_rating==2)=1;
%Normalization of continuous ratings
cont_rating = T([36:end],:);
norm_data = [];
for i = 1:size(cont_rating,1)
    norm_data_forOneTheme = (cont_rating(i,:)-min(cont_rating(i,:)))/(max(cont_rating(i,:))-min(cont_rating(i,:)));
    norm_data(i,:) = norm_data_forOneTheme;
end

% Create an excel sheet with normalized data
TT = [yesno_rating;norm_data];
TT_table = array2table(TT);
pathAndName = fullfile(resDir, 'normalized_featureRatings_part1.xlsx');
writetable(TT_table, pathAndName);

%% Part 2 (emotion, location etc)
clear T
clear TT
clear cons_rating
clear yesno_rating
clear norm_data

load(fullfile(resDir,'resultList_part2_afterRecodedLoc'));
T=newList;
yesno_rating = T(1:5,:);
% Normalization of Yes/No ratings
yesno_rating(yesno_rating==1)=0;
yesno_rating(yesno_rating==2)=1;

%Normalization of continuous ratings
cont_rating = T(6:8,:);
for i = 1:size(cont_rating,1)
    norm_data_forOneTheme = (cont_rating(i,:)-min(cont_rating(i,:)))/(max(cont_rating(i,:))-min(cont_rating(i,:)));
    norm_data(i,:) = norm_data_forOneTheme;
end

TT = [yesno_rating;norm_data];
TT_table=array2table(TT);
pathAndName = fullfile(resDir, 'normalized_featureRatings_part2.xlsx');
writetable(TT_table,pathAndName);

end