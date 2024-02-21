function quantitativePlots_visualize(catOne, catTwo, type,resDir,correctionMethod)

catToCompare = type;
nActions=100;
nameCategories = {'AggressiveAct', 'Communication', 'FoodRelatedAct','Gestures', 'HandRelatedAct','Hobby',...
    'HouseholdRelatedAct', 'Interaction', 'Locomotion', 'MorningRoutine', 'SportRelatedAct'};
load('nameFeatures_44');
outputDir = fullfile(resDir, '/QuantitativePlots/');

% Load the data
switch catToCompare
    case 'twoCategories'
        nameQuantPlot = sprintf('quantPlot_%s-%s_zscore',nameCategories{catOne}, nameCategories{catTwo});
        sprintf('Categories you are comparing are %s and %s', nameCategories{catOne}, nameCategories{catTwo})
        catTwo_name = nameCategories{catTwo};
        load(fullfile(outputDir,nameQuantPlot))
        catOne_name = nameCategories{catOne};
        T=forQuantPlot;
        
    case 'categoryVsRest_zscores'
         nameQuantPlot = sprintf('quantPlot_%s-otherCategories_zscore_%s',nameCategories{catOne},correctionMethod);
         sprintf('Categories you are comparing are %s and the rest', nameCategories{catOne})
         catTwo_name = 'Other categories';
         load(fullfile(outputDir,nameQuantPlot))
         catOne_name = nameCategories{catOne};
         T=forQuantPlot;
    case 'categoryVsRest_WelchTest'
        nameQuantPlot = sprintf('quantPlot_%s-otherCategories_WelchTest_%s',nameCategories{catOne},correctionMethod);
        sprintf('Categories you are comparing are %s and the rest', nameCategories{catOne})
        catTwo_name = 'Other categories';
        load(fullfile(outputDir,nameQuantPlot))
        catOne_name = nameCategories{catOne};
        T=forQuantPlot;
end      

catOne = T(:,1);
figure
h1=stem(catOne, 'Marker', 'o',...
    'Color', [0.5 0.5 0.5],...
    'LineWidth',2,...
    'MarkerSize',6)
hold on

ylab = ylabel('z-score', 'fontsize', 40);
%ylab = ylabel('Welch''s t test', 'fontsize', 40); %% ZK 16.03.2022

ylim([-50 21]);  % z-score:[-50 21]; Welch's test: [-15 20]
pos1 = ylab.Position;
pos2=pos1;
pos2(2) = -6;
%pos2(1) = pos1(1) - 0.5;
set(ylab, 'Position',pos2)
%lgd = legend(sprintf('%s', catOne_name), sprintf('%s', catTwo_name))
%lgd.FontSize = 8;
set(gca, 'xtick', [1:1:length(nameFeatures)]) %, 'ytick', [0:0.1:1.2]);
set(gca, 'fontsize', 27);
set(gca, 'xticklabel', nameFeatures) %, 'yticklabel') , [0:0.1:1.2]);
rotateXLabels(gca, 45);

box off

xlbl=xticklabels;  % bold
idx = find(T(:,2));
for j=1:length(idx)
    featName = string(nameFeatures(idx(j)));
    xlbl(idx(j))= {sprintf('\\bf{%s}',featName)};
end
xticklabels(xlbl); % bold

% In case I want to keep significant ones red
hold on
catOne_bold = NaN(length(catOne),1);
catOne_bold(idx) = catOne(idx);
h2=stem(catOne_bold, 'Marker', 'o',...
    'Color', 'k',...
    'LineWidth',2,...
    'MarkerSize',6)


set(h1, 'markerfacecolor', get(h1, 'color'),'Markersize', 12);
set(h2, 'markerfacecolor', get(h2, 'color'),'Markersize', 12);
%set(h3, 'markerfacecolor', get(h3, 'color'));
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 30, 12], 'PaperUnits', 'Inches', 'PaperSize', [20,12])

%savefig(gcf,fullfile(outputDir,sprintf('%s.fig',nameQuantPlot)))
%saveas(gcf,fullfile(outputDir, sprintf('%s.eps',nameQuantPlot)),'epsc')
saveas(gcf,fullfile(outputDir, sprintf('%s.svg',nameQuantPlot)))
saveas(gcf,fullfile(outputDir, sprintf('%s.jpg',nameQuantPlot)))

close all

end