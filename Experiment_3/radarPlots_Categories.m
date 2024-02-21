%% Make radar plots directly from the ratings
% Figure 3, Figure S10
resDir = '~/Experiment_3/data';

nActions=100;
outputDir = fullfile(resDir, '/RadialPlots/');
if ~exist(outputDir)
    mkdir(outputDir);
end

nameCategories = {'AggressiveAct', 'Communication', 'FoodRelatedAct','Gestures','HandRelatedAct','Hobby',...
    'HouseholdRelatedAct', 'Interaction', 'Locomotion', 'MorningRoutine', 'SportRelatedAct'};
load('nameFeatures_44');

AggressiveAct = [2,4,66,87];
Communication =[8,69,88,91,98];
FoodRelatedAct = [10,14,16,21,25,26,31,51,63,80,94];
Gestures = [1,33,50,54,64,90,97,99];
HandRelatedAct = [39,49,62];
Hobby = [17,20,24,48,53,56,60,81,86,92,96];
HouseholdRelatedAct = [9,11,13,15,18,19,28,29,32,41,55,67,68,93];
Interaction = [36,38,43,57];
Locomotion = [22,23];
MorningRoutine = [5,6,74,77,85,95,100];
SportRelatedAct = [3,7,12,27,30,34,35,37,40,42,44,45,46,47,52,58,59,61,65,70,71,72,73,75,76,78,82,83,84,89];

actionsInCat = {AggressiveAct, Communication, FoodRelatedAct, Gestures, HandRelatedAct, Hobby,...
    HouseholdRelatedAct, Interaction, Locomotion, MorningRoutine, SportRelatedAct};

% Part 1
T = xlsread(fullfile(resDir,'normalized_featureRatings_part1_reduced.xlsx'));
load(fullfile(resDir,'ratingsPerAction_part1'));

catAggressiveAct_part1 = [];
catCommunication_part1 = [];
catFoodRelatedAct_part1 = [];
catGestures_part1 = []; 
catHandRelatedAct_part1 = [];
catHobby_part1 = [];
catHouseholdRelatedAct_part1 =[];
catInteraction_part1 = [];
catLocomotion_part1 = [];
catMorningRoutine_part1 = [];
catSportRelatedAct_part1 = [];

c=1;
numOfCorr = ratingsPerAction;
numTotal = sum(numOfCorr)*nActions;
for i = 1:nActions
    d = c+(numOfCorr(i)-1);
    current_list = T(:,c:d);
    if (~isempty(isnan(current_list))==1)
        [r,c] = find(isnan(current_list));
        current_list(:,c)=[];
    end
    if sum(ismember(AggressiveAct,i))
        catAggressiveAct_part1 = [catAggressiveAct_part1, current_list];
    elseif  sum(ismember(Communication,i))
        catCommunication_part1 = [catCommunication_part1, current_list];
    elseif  sum(ismember(FoodRelatedAct,i))
        catFoodRelatedAct_part1 = [catFoodRelatedAct_part1, current_list];
    elseif  sum(ismember(Gestures,i))
        catGestures_part1 = [catGestures_part1, current_list];
    elseif  sum(ismember(HandRelatedAct,i))
        catHandRelatedAct_part1 = [catHandRelatedAct_part1, current_list];        
    elseif  sum(ismember(Hobby,i))
        catHobby_part1 = [catHobby_part1, current_list];
    elseif sum(ismember(HouseholdRelatedAct,i))
        catHouseholdRelatedAct_part1 = [catHouseholdRelatedAct_part1, current_list];        
    elseif  sum(ismember(Interaction,i))
        catInteraction_part1 = [catInteraction_part1, current_list];
    elseif  sum(ismember(Locomotion,i))
        catLocomotion_part1 = [catLocomotion_part1, current_list];   
    elseif  sum(ismember(MorningRoutine,i))
        catMorningRoutine_part1 = [catMorningRoutine_part1, current_list];   
    elseif  sum(ismember(SportRelatedAct,i))
        catSportRelatedAct_part1 = [catSportRelatedAct_part1, current_list];
    else
        %sprintf('Error! for action %d', i)
    end
    %mean_currentList = mean(current_list,2);
    %avg_list_part2(:,i) = mean_currentList;
    c=d+1;
end
packedRatings_part1 = {catAggressiveAct_part1,catCommunication_part1,catFoodRelatedAct_part1,catGestures_part1,catHandRelatedAct_part1,...
    catHobby_part1,catHouseholdRelatedAct_part1,catInteraction_part1,...
    catLocomotion_part1,catMorningRoutine_part1,catSportRelatedAct_part1};

% Part 2
T = xlsread(fullfile(resDir,'normalized_featureRatings_part2.xlsx'));
load(fullfile(resDir,'ratingsPerAction_part2'));

catAggressiveAct_part2 = [];
catCommunication_part2 = [];
catFoodRelatedAct_part2 = [];
catGestures_part2 = [];
catHandRelatedAct_part2 = [];
catHobby_part2 = [];
catHouseholdRelatedAct_part2 =[];
catInteraction_part2 = [];
catLocomotion_part2 = [];
catMorningRoutine_part2 = [];
catSportRelatedAct_part2 = [];

c=1;
numOfCorr = ratingsPerAction;
numTotal = sum(numOfCorr)*nActions;
for i = 1:nActions
    d = c+(numOfCorr(i)-1);
    current_list = T(:,c:d);
    if (~isempty(isnan(current_list))==1)
        [r,c] = find(isnan(current_list));
        current_list(:,c)=[];
    end
    if sum(ismember(AggressiveAct,i))
        catAggressiveAct_part2 = [catAggressiveAct_part2, current_list];
    elseif  sum(ismember(Communication,i))
        catCommunication_part2 = [catCommunication_part2, current_list];
    elseif  sum(ismember(FoodRelatedAct,i))
        catFoodRelatedAct_part2 = [catFoodRelatedAct_part2, current_list];
    elseif  sum(ismember(Gestures,i))
        catGestures_part2 = [catGestures_part2, current_list];       
    elseif  sum(ismember(HandRelatedAct,i))
        catHandRelatedAct_part2 = [catHandRelatedAct_part2, current_list];      
    elseif  sum(ismember(Hobby,i))
        catHobby_part2 = [catHobby_part2, current_list];
    elseif sum(ismember(HouseholdRelatedAct,i))
        catHouseholdRelatedAct_part2 = [catHouseholdRelatedAct_part2, current_list];        
    elseif  sum(ismember(Interaction,i))
        catInteraction_part2 = [catInteraction_part2, current_list];
    elseif  sum(ismember(Locomotion,i))
        catLocomotion_part2 = [catLocomotion_part2, current_list];   
    elseif  sum(ismember(MorningRoutine,i))
        catMorningRoutine_part2 = [catMorningRoutine_part2, current_list];   
    elseif  sum(ismember(SportRelatedAct,i))
        catSportRelatedAct_part2 = [catSportRelatedAct_part2, current_list];
    else
        %sprintf('Error! for action %d', i)
    end
    %mean_currentList = mean(current_list,2);
    %avg_list_part2(:,i) = mean_currentList;
    c=d+1;
end
packedRatings_part2 = {catAggressiveAct_part2,catCommunication_part2,catFoodRelatedAct_part2,catGestures_part2,catHandRelatedAct_part2,...
    catHobby_part2,catHouseholdRelatedAct_part2,catInteraction_part2,...
    catLocomotion_part2,catMorningRoutine_part2,catSportRelatedAct_part2};

% With CI 95%
for z = 1:length(nameCategories)
    singleCat_part1 = (mean(packedRatings_part1{z},2)');
    SEM_part1 = std(packedRatings_part1{z}')/sqrt(length(packedRatings_part1{z}'));
    ts = tinv([0.05  0.95],length(packedRatings_part1{z}')-1);
    for thisFeat = 1:length(singleCat_part1)
        CI_part1(:,thisFeat) = singleCat_part1(thisFeat) + ts*SEM_part1(1,thisFeat); 
    end
    singleCatSEM_part1 = [singleCat_part1; CI_part1(1,:); CI_part1(2,:)];
    singleCat_part2 = (mean(packedRatings_part2{z},2)');
    SEM_part2 = std(packedRatings_part2{z}')/sqrt(length(packedRatings_part2{z}'));
    ts = tinv([0.05  0.95],length(packedRatings_part2{z}')-1);
    for thisFeat = 1:length(singleCat_part2)
        CI_part2(:,thisFeat) = singleCat_part2(thisFeat) + ts*SEM_part2(1,thisFeat); 
    end
    singleCatSEM_part2 = [singleCat_part2; CI_part2(1,:); CI_part2(2,:)];
    singleCatSEM = [singleCatSEM_part1(:,1:29),singleCatSEM_part2(:,4:5),singleCatSEM_part1(:,30),singleCatSEM_part2(:,1:3),singleCatSEM_part1(:,31:36),singleCatSEM_part2(:,6:8)];
    figure
    runRadarPlot(singleCatSEM,nameFeatures)
    sprintf('%s',nameCategories{z})
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 12, 12], 'PaperUnits', 'Inches', 'PaperSize', [12,12])
    %set(gcf, 'Position', [10, 10, 900, 900])

    savefig(fullfile(outputDir, sprintf('%s_radialPlot.fig',nameCategories{z})))
    saveas(gcf, fullfile(outputDir, sprintf('%s_radialPlot.svg',nameCategories{z})))
    saveas(gcf, fullfile(outputDir, sprintf('%s_radialPlot.jpg',nameCategories{z})))
    close all
end

% % With SEM
% for z = 1:length(nameCategories)
%     singleCat_part1 = (mean(packedRatings_part1{z},2)');
%     
%     SEM_part1 = std(packedRatings_part1{z}')/sqrt(length(packedRatings_part1{z}'));
%     catSEMBelow_part1 = singleCat_part1 - SEM_part1;
%     catSEMAbove_part1 = SEM_part1+singleCat_part1;
%     singleCatSEM_part1 = [singleCat_part1; catSEMBelow_part1; catSEMAbove_part1];
%     singleCat_part2 = (mean(packedRatings_part2{z},2)');
%     SEM_part2 = std(packedRatings_part2{z}')/sqrt(length(packedRatings_part2{z}'));
%     catSEMBelow_part2 = singleCat_part2 - SEM_part2;
%     catSEMAbove_part2 = SEM_part2+singleCat_part2;
%     singleCatSEM_part2 = [singleCat_part2; catSEMBelow_part2; catSEMAbove_part2];
%     singleCatSEM = [singleCatSEM_part1(:,1:29),singleCatSEM_part2(:,4:5),singleCatSEM_part1(:,30),singleCatSEM_part2(:,1:3),singleCatSEM_part1(:,31:36),singleCatSEM_part2(:,6:8)];
%     figure
%     runRadarPlot(singleCatSEM,nameFeatures)
%     sprintf('%s',nameCategories{z})
%     savefig(fullfile(outputDir, sprintf('%s_radialPlot.fig',nameCategories{z})))
%     saveas(gcf, fullfile(outputDir, sprintf('%s_radialPlot.svg',nameCategories{z})))
%     close all
% end



