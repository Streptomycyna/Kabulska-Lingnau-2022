%% Make radar plots directly from the ratings. FOR SINGLE ACTIONS
% Figure S11
resDir = '~/Experiment_3/data';

nActions = 100;
outputDir = fullfile(resDir, '/RadialPlots/singleActions');
if ~exist(outputDir)
    mkdir(outputDir);
end

%Get action names
load('nameActions.mat');
load('nameFeatures_44.mat');

% Part 1
T = xlsread(fullfile(resDir,'normalized_featureRatings_part1_reduced.xlsx'));
load(fullfile(resDir,'ratingsPerAction_part1'));

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
    mean_currentList = mean(current_list,2);
    avg_list_part1(:,i) = mean_currentList;
    c=d+1;
end

% Part 2
T = xlsread(fullfile(resDir,'normalized_featureRatings_part2.xlsx'));
load(fullfile(resDir,'ratingsPerAction_part2'));

c=1;
numOfCorr = ratingsPerAction;
numTotal = sum(numOfCorr)*nActions;
for i = 1:nActions
    d = c+(numOfCorr(i)-1);
    current_list = T(:,c:d);
    mean_currentList = mean(current_list,2);
    avg_list_part2(:,i) = mean_currentList;
    c=d+1;
end

for z = 31:nActions
    singleAct = [avg_list_part1(1:29,z);avg_list_part2(4:5,z);avg_list_part1(30,z);avg_list_part2(1:3,z);avg_list_part1(31:36,z);avg_list_part2(6:8,z)];
    runRadarPlot_singleActions(singleAct');
    %set(gcf, 'Units', 'Inches', 'Position', [0, 0, 12, 12], 'PaperUnits', 'Inches', 'PaperSize', [12,12])

    savefig(fullfile(outputDir, sprintf('%s_radialPlot.fig',nameActions{z})))
    saveas(gcf, fullfile(outputDir, sprintf('%s_radialPlot.svg',nameActions{z})))
    saveas(gcf, fullfile(outputDir, sprintf('%s_radialPlot.png',nameActions{z})))
    close all
end

for z = 1:nActions
    myMatrix = imread(fullfile(outputDir, sprintf('%s_radialPlot.png', nameActions{z}))); 
    %imshow(myMatrix);
    %h = impixelinfo();
    %axis on;
    I2 = imcrop(myMatrix,[236, 50, 732, 736]);  % First two digits takes the position of the left top corner, then the next two 
                            % gives information how many voxels should be
                            % left [horizontal, vertical]
    %imshow(I2)
    %J = imresize(I2,0.1);
    % imwrite(I2,sprintf('averaged_Euclidean_norm_ss%d_cropped.jpg',i)); % for the loop
    imwrite(I2,fullfile(outputDir, sprintf('%s_radialPlot.png', nameActions{z})));
end


%% To create an example
z=30;
singleAct = [avg_list_part1(1:29,z);avg_list_part2(4:5,z);avg_list_part1(30,z);avg_list_part2(1:3,z);avg_list_part1(31:36,z);avg_list_part2(6:8,z)];
singleAct=singleAct(randperm(length(singleAct)));
runRadarPlot_singleActions(singleAct',nameFeatures)
savefig(fullfile(outputDir, '1_EXAMPLE_radialPlot.fig'))
saveas(gcf, fullfile(outputDir,'1_EXAMPLE_radialPlot.png'));
%saveas(gcf, fullfile(outputDir,'1_EXAMPLE_radialPlot.svg'));
close all
