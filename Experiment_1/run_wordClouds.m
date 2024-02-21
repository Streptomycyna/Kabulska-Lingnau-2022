function run_wordClouds
%%%%%%%%%%%%%%%%%%%%%%%
% Make word clouds 
% ZK 7.03.2022
%%%%%%%%%%%%%%%%%%%%%%%

% Go to 'Experiment_1/data', find 'Category labels - grouped.xlsx' , double click and load it as a string
% array
catLabl = Categorylabelsgrouped;

nameCategories = {'FoodRelatedAct','MorningRoutine', 'Communication','HandRelatedCommunication','Hobby',...
    'Interaction','HandRelatedAct','SportRelatedAct','Locomotion','HouseholdRelatedAct','AggressiveAct'};
catCount = 1;
maxLen = length(catLabl);

for i = 1:2:22
    strCounts = str2double(catLabl(:,i));
    catLen = min(find(isnan(strCounts)));
    if ~isempty(catLen)
        tbl = table(catLabl(1:(catLen-1),i+1), str2double(catLabl(1:(catLen-1),i)), 'VariableNames', {'Words', 'Counts'});
    else
        tbl = table(catLabl(1:maxLen,i+1), str2double(catLabl(1:maxLen,i)), 'VariableNames', {'Words', 'Counts'});
    end
    figure
    wordcloud(tbl, 'Words', 'Counts', 'Title', '');
    
    set(gcf, 'Units', 'Inches', 'Position', [0, 0, 16, 10], 'PaperUnits', 'Inches', 'PaperSize', [12,12])
    %set(gcf, 'Position', [10, 10, 900, 900])

    savefig(sprintf('wordCloudFigures/%s.fig',nameCategories{catCount}))
    saveas(gcf, sprintf('wordCloudFigures/%s.svg',nameCategories{catCount}))
    saveas(gcf, sprintf('wordCloudFigures/%s.jpg',nameCategories{catCount}))
    close all
    catCount = catCount+1;
    
end  



