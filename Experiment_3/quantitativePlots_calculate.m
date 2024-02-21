function quantitativePlots_calculate(catOne, catTwo, type,resDir,correctionMethod)
%% Preapre dataset for flat plots
% It goes to Results/quantitativePlots. Then run 'quantitativePlots_visualize'

catToCompare = type;
nActions = 100;
nameCategories = {'AggressiveAct', 'Communication', 'FoodRelatedAct','Gestures','HandRelatedAct','Hobby',...
    'HouseholdRelatedAct', 'Interaction', 'Locomotion', 'MorningRoutine', 'SportRelatedAct'};

load('nameFeatures_44');
outputDir = fullfile(resDir, '/QuantitativePlots/');
if ~exist(outputDir)
    mkdir(outputDir)
end
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
packedRatings_part1 = {catAggressiveAct_part1,catCommunication_part1,catFoodRelatedAct_part1,catGestures_part1, catHandRelatedAct_part1,...
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
packedRatings_part2 = {catAggressiveAct_part2,catCommunication_part2,catFoodRelatedAct_part2,catGestures_part2, catHandRelatedAct_part2,...
    catHobby_part2,catHouseholdRelatedAct_part2,catInteraction_part2,...
    catLocomotion_part2,catMorningRoutine_part2,catSportRelatedAct_part2};

switch catToCompare
    case 'twoCategories'
        sprintf('Categories you are comparing are %s and %s', nameCategories{catOne}, nameCategories{catTwo})
        
        catOne_avg_part1 = (mean(packedRatings_part1{catOne},2)');
        catOne_avg_part2 = (mean(packedRatings_part2{catOne},2)');
        catTwo_avg_part1 = (mean(packedRatings_part1{catTwo},2)');
        catTwo_avg_part2 = (mean(packedRatings_part2{catTwo},2)');
        
        % For part 1
        pp=[];
        statsStat=[];
        nFeatures = length(catOne_avg_part1);
        for i = 1:nFeatures
            catOne_this = packedRatings_part1{catOne}(i,:);
            catTwo_this = packedRatings_part1{catTwo}(i,:);
            [h,p,ci,stats]=ttest2(catOne_this,catTwo_this);
            pp = [pp,p];
            statsStat = [statsStat, stats.tstat];
        end
        FDR_pp = mafdr(pp,'BHFDR',true);
        this_signif = find(FDR_pp<0.001);
        signif_1 = zeros(nFeatures,1);
        signif_1(this_signif)=1;
        % For part 2
        pp=[];
        statsStat=[];
        nFeatures = length(catOne_avg_part2);
        for i = 1:nFeatures
            catOne_this = packedRatings_part2{catOne}(i,:);
            catTwo_this = packedRatings_part2{catTwo}(i,:);
            [h,p,ci,stats]=ttest2(catOne_this,catTwo_this);
            pp = [pp,p];
            statsStat = [statsStat, stats.tstat];
        end
        FDR_pp = mafdr(pp,'BHFDR',true);
        this_signif = find(FDR_pp<0.001);
        signif_2 = zeros(nFeatures,1);
        signif_2(this_signif)=1;
        forQuantPlot_part1 = [catOne_avg_part1;catTwo_avg_part1;signif_1'];
        forQuantPlot_part2 = [catOne_avg_part2;catTwo_avg_part2;signif_2'];
        forQuantPlot_full = [forQuantPlot_part1(:,1:29),forQuantPlot_part2(:,4:5),forQuantPlot_part1(:,30),forQuantPlot_part2(:,1:3),forQuantPlot_part1(:,31:36),forQuantPlot_part2(:,6:8)];
        forQuantPlot=forQuantPlot_full';
        nameQuantPlot = sprintf('quantPlot_%s-%s',nameCategories{catOne}, nameCategories{catTwo});
        save(fullfile(outputDir,nameQuantPlot),'forQuantPlot')
        
        
        
     case 'categoryVsRest_zscores'
        sprintf('Categories you are comparing are %s and the rest', nameCategories{catOne})
        
        catOne_part1 = packedRatings_part1{catOne};
        catOne_part2 = packedRatings_part2{catOne};
        packed_rest_part1_tmp = packedRatings_part1;
        packed_rest_part1_tmp(catOne)=[];
        packed_rest_part2_tmp = packedRatings_part2;
        packed_rest_part2_tmp(catOne)=[];       
        packed_rest_part1 = horzcat(packed_rest_part1_tmp{:});
        packed_rest_part2 = horzcat(packed_rest_part2_tmp{:});
        catTwo_avg_part1 = (mean(packed_rest_part1,2)');
        catTwo_avg_part2 = (mean(packed_rest_part2,2)');
        
        for iVal = 1:size(catOne_part1,1)
            zval_part1(iVal,1) = ztest2(catOne_part1(iVal,:),packed_rest_part1(iVal,:));
        end
        
        for iVal = 1:size(catOne_part2,1)
            zval_part2(iVal,1) = ztest2(catOne_part2(iVal,:),packed_rest_part2(iVal,:));
        end
        
        forQuantPlot = [zval_part1(1:29);zval_part2(4:5);zval_part1(30);zval_part2(1:3);zval_part1(31:36);zval_part2(6:8)];
        p_two = normcdf(forQuantPlot);
        p_val = 0.05;  
        switch correctionMethod
            case 'Bonferroni'
                new_pval = 0.05/44;
                this_signif = find(p_two<new_pval);
                this_signif2 = find(p_two>(1-new_pval));
            case 'FDR'
                FDR_pp = mafdr(p_two,'BHFDR',true); 
                this_signif = find(FDR_pp<p_val);
                p_two_side2 = abs(1-p_two);
                FDR_pp_side2 = mafdr(p_two_side2,'BHFDR',true);
                this_signif2 = find(FDR_pp_side2<p_val);
        end
        nFeatures = length(p_two);
        signif = zeros(nFeatures,1);
        signif(this_signif)=1;
        signif(this_signif2)=1;
        forQuantPlot_full = [forQuantPlot,signif];
        forQuantPlot = forQuantPlot_full;
        nameQuantPlot = sprintf('quantPlot_%s-otherCategories_zscore_%s',nameCategories{catOne},correctionMethod); %%%
        save(fullfile(outputDir,nameQuantPlot),'forQuantPlot')   
    
    case 'categoryVsRest_WelchTest'
        sprintf('Categories you are comparing are %s and the rest', nameCategories{catOne})
        
        catOne_part1 = packedRatings_part1{catOne};
        catOne_part2 = packedRatings_part2{catOne};
        packed_rest_part1_tmp = packedRatings_part1;
        packed_rest_part1_tmp(catOne)=[];
        packed_rest_part2_tmp = packedRatings_part2;
        packed_rest_part2_tmp(catOne)=[];       
        packed_rest_part1 = horzcat(packed_rest_part1_tmp{:});
        packed_rest_part2 = horzcat(packed_rest_part2_tmp{:});
        catTwo_avg_part1 = (mean(packed_rest_part1,2)');
        catTwo_avg_part2 = (mean(packed_rest_part2,2)');
        pp1=[];
        statsStat1=[];
        for iVal = 1:size(catOne_part1,1)
            [h,p,ci,stats]=ttest2(catOne_part1(iVal,:),packed_rest_part1(iVal,:));
            pp1 = [pp1,p];
            statsStat1 = [statsStat1, stats.tstat];
        end
        
        pp2=[];
        statsStat2=[];       
        for iVal = 1:size(catOne_part2,1)
            [h,p,ci,stats]=ttest2(catOne_part2(iVal,:),packed_rest_part2(iVal,:));
            pp2 = [pp2,p];
            statsStat2 = [statsStat2, stats.tstat];
        end
        forQuantPlot = [statsStat1(1:29),statsStat2(4:5),statsStat1(30),statsStat2(1:3),statsStat1(31:36),statsStat2(6:8)];
        
        pp = [pp1(1:29),pp2(4:5),pp1(30),pp2(1:3),pp1(31:36),pp2(6:8)];
        p_val = 0.05;  
        
        FDR_pp = mafdr(pp,'BHFDR',true);
        this_signif = find(FDR_pp<p_val);
        p_two_side2 = abs(1-pp);
        FDR_pp_side2 = mafdr(p_two_side2,'BHFDR',true);
        this_signif2 = find(FDR_pp_side2<p_val);

        nFeatures = length(pp);
        signif = zeros(1,nFeatures);
        signif(this_signif)=1;
        signif(this_signif2)=1;
        forQuantPlot_full = [forQuantPlot',signif'];
        forQuantPlot = forQuantPlot_full;
        nameQuantPlot = sprintf('quantPlot_%s-otherCategories_WelchTest_%s',nameCategories{catOne},correctionMethod); %%%
        save(fullfile(outputDir,nameQuantPlot),'forQuantPlot')       
        
        
    case 'categoryVsRest_mean'
        sprintf('Categories you are comparing are %s and the rest', nameCategories{catOne})
        catOne_avg_part1 = (mean(packedRatings_part1{catOne},2)');
        catOne_avg_part2 = (mean(packedRatings_part2{catOne},2)');
        packed_rest_part1_tmp = packedRatings_part1;
        packed_rest_part1_tmp(catOne)=[];
        packed_rest_part2_tmp = packedRatings_part2;
        packed_rest_part2_tmp(catOne)=[];       
        packed_rest_part1 = horzcat(packed_rest_part1_tmp{:});
        packed_rest_part2 = horzcat(packed_rest_part2_tmp{:});
        catTwo_avg_part1 = (mean(packed_rest_part1,2)');
        catTwo_avg_part2 = (mean(packed_rest_part2,2)');
        
        % For part 1
        pp=[];
        statsStat=[];
        nFeatures = length(catOne_avg_part1);
        for i = 1:nFeatures
            catOne_this = packedRatings_part1{catOne}(i,:);
            catTwo_this = packed_rest_part1(i,:);
            [h,p,ci,stats]=ttest2(catOne_this,catTwo_this);
            pp = [pp,p];
            statsStat = [statsStat, stats.tstat];
        end
        FDR_pp = mafdr(pp,'BHFDR',true);
        this_signif = find(FDR_pp<0.001);
        signif_1 = zeros(nFeatures,1);
        signif_1(this_signif)=1;

        % For part 2
        pp=[];
        statsStat=[];
        nFeatures = length(catOne_avg_part2);
        for i = 1:nFeatures
            catOne_this = packedRatings_part2{catOne}(i,:);
            catTwo_this = packed_rest_part2(i,:);
            [h,p,ci,stats]=ttest2(catOne_this,catTwo_this);
            pp = [pp,p];
            statsStat = [statsStat, stats.tstat];
        end
        FDR_pp = mafdr(pp,'BHFDR',true);
        this_signif = find(FDR_pp<0.001);
        signif_2 = zeros(nFeatures,1);
        signif_2(this_signif)=1;
        forQuantPlot_part1 = [catOne_avg_part1;catTwo_avg_part1;signif_1'];
        forQuantPlot_part2 = [catOne_avg_part2;catTwo_avg_part2;signif_2'];
        forQuantPlot_full = [forQuantPlot_part1(:,1:29),forQuantPlot_part2(:,4:5),forQuantPlot_part1(:,30),forQuantPlot_part2(:,1:3),forQuantPlot_part1(:,31:36),forQuantPlot_part2(:,6:8)];
        forQuantPlot=forQuantPlot_full';
        nameQuantPlot = sprintf('quantPlot_%s-otherCategories',nameCategories{catOne});
        save(fullfile(outputDir,nameQuantPlot),'forQuantPlot')

end
        
end       
        