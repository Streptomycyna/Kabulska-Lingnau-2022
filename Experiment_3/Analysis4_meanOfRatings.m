function Analysis4_meanOfRatings(resDir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the average of the ratings for each action and get ratings for each
% category

%% Part 1
T = xlsread(fullfile(resDir,'normalized_featureRatings_part1.xlsx'));
load(fullfile(resDir,'ratingsPerAction_part1'));

numOfCorr = ratingsPerAction;
nActions = 100;
numTotal = sum(numOfCorr)*nActions;

c = 1;
% packedActions = {}; % Use it if you want to compute t-tests for the quantitive plots
avg_list = [];

% AggressiveAct = [2,4,66,87];
% Communication =[8,69,88,91,98];
% FoodRelatedAct = [10,14,16,21,25,26,31,51,63,80,94];
% Gestures = [1,33,50,54,64,90,97,99];
% HandRelatedAct = [39,49,62];
% Hobby = [17,20,24,48,53,56,60,81,86,92,96];
% HouseholdRelatedAct = [9,11,13,15,18,19,28,29,32,41,55,67,68,93];
% Interaction = [36,38,43,57];
% Locomotion = [22,23];
% MorningRoutine = [5,6,74,77,85,95,100];
% SportRelatedAct = [3,7,12,27,30,34,35,37,40,42,44,45,46,47,52,58,59,61,65,70,71,72,73,75,76,78,82,83,84,89];
% 
% catAggressiveAct = [];
% catCommunication = [];
% catFoodRelatedAct = [];
% catGestures = [];
% catHandRelatedAct = [];
% catHobby = [];
% catHouseholdRelatedAct =[];
% catInteraction = [];
% catLocomotion = [];
% catMorningRoutine = [];
% catSportRelatedAct = [];



for i = 1:nActions
    d = c+(numOfCorr(i)-1);
    current_list = T(:,c:d);
    if (~isempty(isnan(current_list))==1)
        [r,c] = find(isnan(current_list));
        current_list(:,c)=[];
    end
%     if sum(ismember(AggressiveAct,i))
%         catAggressiveAct = [catAggressiveAct, current_list];
%     elseif  sum(ismember(Communication,i))
%         catCommunication = [catCommunication, current_list];
%     elseif  sum(ismember(FoodRelatedAct,i))
%         catFoodRelatedAct = [catFoodRelatedAct, current_list];
%     elseif  sum(ismember(Gestures,i))    
%         catGestures = [catGestures, current_list];
%     elseif  sum(ismember(HandRelatedAct,i))
%         catHandRelatedAct = [catHandRelatedAct, current_list];        
%     elseif  sum(ismember(Hobby,i))
%         catHobby = [catHobby, current_list];
%     elseif sum(ismember(HouseholdRelatedAct,i))
%         catHouseholdRelatedAct = [catHouseholdRelatedAct, current_list];        
%     elseif  sum(ismember(Interaction,i))
%         catInteraction = [catInteraction, current_list];
%     elseif  sum(ismember(Locomotion,i))
%         catLocomotion = [catLocomotion, current_list];   
%     elseif  sum(ismember(MorningRoutine,i))
%         catMorningRoutine = [catMorningRoutine, current_list];   
%     elseif  sum(ismember(SportRelatedAct,i))
%         catSportRelatedAct = [catSportRelatedAct, current_list];
%     else
%         %sprintf('Error! for action %d', i)
%     end
%     packedActions{1, i} = current_list;
    mean_currentList = mean(current_list,2);
    avg_list(:,i) = mean_currentList;
    c=d+1;
end

TT_table = array2table(avg_list);
pathAndName = fullfile(resDir,'averaged_featureRatings_part1.xlsx');
writetable(TT_table,pathAndName);

%% Part 2
clear T
clear ratingsPerAction
clear TT_table

T = xlsread(fullfile(resDir,'normalized_featureRatings_part2.xlsx'));
load(fullfile(resDir,'ratingsPerAction_part2'));

numOfCorr = ratingsPerAction;
numTotal = sum(numOfCorr)*nActions;

c = 1;
% packedActions = {}; % Use it if you want to compute t-tests for the quantitive plots
avg_list = [];

% catAggressiveAct = [];
% catCommunication = [];
% catFoodRelatedAct = [];
% catGestures = [];
% catHandRelatedAct = [];
% catHobby = [];
% catHouseholdRelatedAct =[];
% catInteraction = [];
% catLocomotion = [];
% catMorningRoutine = [];
% catSportRelatedAct = [];

for i = 1:nActions
    d = c+(numOfCorr(i)-1);
    current_list = T(:,c:d);
%     if sum(ismember(AggressiveAct,i))
%         catAggressiveAct = [catAggressiveAct, current_list];
%     elseif  sum(ismember(Communication,i))
%         catCommunication = [catCommunication, current_list];
%     elseif  sum(ismember(FoodRelatedAct,i))
%         catFoodRelatedAct = [catFoodRelatedAct, current_list];
%     elseif  sum(ismember(Gestures,i))    
%         catGestures = [catGestures, current_list];
%     elseif  sum(ismember(HandRelatedAct,i))
%         catHandRelatedAct = [catHandRelatedAct, current_list];        
%     elseif  sum(ismember(Hobby,i))
%         catHobby = [catHobby, current_list];
%     elseif sum(ismember(HouseholdRelatedAct,i))
%         catHouseholdRelatedAct = [catHouseholdRelatedAct, current_list];        
%     elseif  sum(ismember(Interaction,i))
%         catInteraction = [catInteraction, current_list];
%     elseif  sum(ismember(Locomotion,i))
%         catLocomotion = [catLocomotion, current_list];   
%     elseif  sum(ismember(MorningRoutine,i))
%         catMorningRoutine = [catMorningRoutine, current_list];   
%     elseif  sum(ismember(SportRelatedAct,i))
%         catSportRelatedAct = [catSportRelatedAct, current_list];
%     else
%         %sprintf('Error! for action %d', i)
%     end
%     packedActions{1, i} = current_list;
    mean_currentList = mean(current_list,2);
    avg_list(:,i) = mean_currentList;
    c=d+1;
end

TT_table = array2table(avg_list);
pathAndName = fullfile(resDir,'averaged_featureRatings_part2.xlsx');
writetable(TT_table,pathAndName);

end
