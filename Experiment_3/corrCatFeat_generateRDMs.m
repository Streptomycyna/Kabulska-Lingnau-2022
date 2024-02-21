%%%%%%%%%%%%%%
% Get RDMs for matrices used in the nonNeativLeastSq
% Figure S13

resDir = '~/Experiment_3/data';

outputDir = fullfile(resDir, '/corrCatFeat/RDMs');
dat = xlsread(fullfile(resDir,'Ready_data.xlsx'), 'Averaged_2');
[nFeatures nActions] = size(dat);

if ~exist(outputDir)
    mkdir(outputDir)
end
%% Single-feature RDMs

for i = 1:nFeatures
    thisModel = pdist(dat(i,:)');
    figure
    imagesc(squareform(thisModel))
    cmap = gray(256)
    colormap(cmap);%colorbar % Apply the custom colormap.
    set(gca,'YTickLabel', []);
    set(gca,'XTickLabel', []);
    set(gcf, 'Units', 'pixels', 'Position', [0, 0, 1000, 1000])
    %saveas(gcf,fullfile(outputDir, sprintf('/singleFeatureModel_feat%d',i)))
    saveas(gcf,fullfile(outputDir, sprintf('/singleFeatureModel_feat%d.jpg',i)))
    %saveas(gcf,fullfile(outputDir, sprintf('/singleFeatureModel_feat%d.svg',i)))
    close all
end

% Cropping the images automatically
for i = 1:nFeatures
    myMatrix = imread(fullfile(outputDir,sprintf('/singleFeatureModel_feat%d.jpg', i)));
    I2 = imcrop(myMatrix,[270, 150, 1620, 1620]);  % First two digits takes the position of the left top corner, then the next two 
                            % gives information how many voxels should be
                            % left [horizontal, vertical]
    %imshow(I2)
    %J = imresize(I2,0.1);
    % imwrite(I2,sprintf('averaged_Euclidean_norm_ss%d_cropped.jpg',i)); % for the loop
    imwrite(I2,fullfile(outputDir,sprintf('/singleFeatureModel_feat%d.jpg', i)));
end


%% Create the Multi-feature RDMs
rawRDM = pdist(dat');
rawRDM = (rawRDM-min(rawRDM))/(max(rawRDM)-min(rawRDM));

figure
imagesc(squareform(rawRDM))
cmap = gray(256)
colormap(cmap);
set(gca,'YTickLabel', []);
set(gca,'XTickLabel', []);
set(gcf, 'Units', 'pixels', 'Position', [0, 0, 1000, 1000])
%saveas(gcf,fullfile(outputDir,'/multidimFeatureModel'))
saveas(gcf,fullfile(outputDir,'/multidimFeatureModel.jpg'))
saveas(gcf,fullfile(outputDir,'/multidimFeatureModel.svg'))

close all

% Cropping 
myMatrix = imread(fullfile(outputDir,'/multidimFeatureModel.jpg'));
I2 = imcrop(myMatrix,[270, 150, 1620, 1620]);  
imwrite(I2,fullfile(outputDir,'/multidimFeatureModel.jpg'));


%% Create theme RDMs
theme1 = 1:5; % body parts
theme2 = 6:10; % object-directedness
theme3 = 11:14; % trajectory
theme4 = 15:24; % type of limb movement
theme5 = 25:29; % posture
theme6 = 30:31; % location
themes = {theme1, theme2, theme3, theme4, theme5, theme6};
for i = 1:length(themes)
    thisModel = pdist(dat(themes{i},:)');
    %thisModel = pdist(dat(themes{i},:)', 'squaredeuclidean');
    thisModel = (thisModel-min(thisModel))/(max(thisModel)-min(thisModel));
    figure
    imagesc(squareform(thisModel));
    cmap = gray(256)
    colormap(cmap);%colorbar % Apply the custom colormap.
    set(gca,'YTickLabel', []);
    set(gca,'XTickLabel', []);
    set(gcf, 'Units', 'pixels', 'Position', [0, 0, 1000, 1000])
    saveas(gcf,fullfile(outputDir, sprintf('/themeModel_theme%d',i)))
    saveas(gcf,fullfile(outputDir, sprintf('/themeModel_theme%d.jpg',i)))
    saveas(gcf,fullfile(outputDir, sprintf('/themeModel_theme%d.svg',i)))
    close all
end
% Cropping
for i = 1:length(themes)
    myMatrix = imread(fullfile(outputDir,sprintf('/themeModel_theme%d.jpg', i)));
    I2 = imcrop(myMatrix,[270, 150, 1620, 1620]);  
    imwrite(I2,fullfile(outputDir,sprintf('/themeModel_theme%d.jpg', i)));
end

%% Weighted multi-feature RDM
load(fullfile(resDir,'corrCatFeat/bootstrap_output_full_results'));
load(fullfile(resDir,'corrCatFeat/bootstrap_output_weights'));

% singFeatModels = mean(full_results.singFeatRDMs,2);
% rawModels = mean(full_results.rawRDMs,2);
% weightRawModels = mean(full_results.weightRawRDMs,2);
% themeModels = mean(full_results.singThemeRDMs,2);
% y = [singFeatModels' rawModels weightRawModels themeModels'];
% thisInd = ~isnan(y);
weights_avg = mean(full_weights,2);
%weights_avg(thisInd(1:44)==0)=0;
for i = 1:length(weights_avg)
    dat_new(i,:) = dat(i,:)*weights_avg(i);
end
weightRawRDM = pdist(dat_new');
%weightRawRDM=weightRawRDM/max(weightRawRDM);
weightRawRDM = (weightRawRDM-min(weightRawRDM))/(max(weightRawRDM)-min(weightRawRDM));
figure
imagesc(squareform(weightRawRDM'));
cmap = gray(256)
colormap(cmap);
set(gca,'YTickLabel', []);
set(gca,'XTickLabel', []);
set(gcf, 'Units', 'pixels', 'Position', [0, 0, 1000, 1000])
saveas(gcf,fullfile(outputDir,'/weightedMultidimFeatureModel'))
saveas(gcf,fullfile(outputDir,'/weightedMultidimFeatureModel.jpg'))
saveas(gcf,fullfile(outputDir,'/weightedMultidimFeatureModel.svg'))
close all

% Cropping
myMatrix = imread(fullfile(outputDir,'weightedMultidimFeatureModel.jpg'));
I2 = imcrop(myMatrix,[270, 150, 1620, 1620]);
imwrite(I2,fullfile(outputDir,'weightedMultidimFeatureModel.jpg'));



