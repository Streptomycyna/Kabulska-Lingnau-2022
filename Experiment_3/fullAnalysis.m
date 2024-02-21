%%%%%%%%%
% Run all the analyses

%% Specify the path
resDir = '~/Experiment_3/data';

%% Preprocessing of the data
Analysis1_infoAboutActions(resDir)
Analysis2_featureRedundancyRemoval(resDir)
Analysis2_recodeLocationToBinary(resDir)
Analysis3_normalizationOfRatings(resDir)
Analysis4_meanOfRatings(resDir)
Analysis5_putTogether(resDir)
Analysis4_meanOfRatings_reduced(resDir)
Analysis5_putTogether_reduced(resDir)

%% Get theme/feature/action names
% Load feature names
%load('nameThemes');

% Load feature names
%load('nameFeatures_49') % 49 features (before feature reduction)
load('nameFeatures_44') % 44 features (after feature reduction)

% Get action names
load('nameActions.mat')

%% Analyses

% Load the data
% I took files 'MainResults_avg' (output from 'Analysis7_putTogether') and 'MainResults_avg_reduced' (output from 'Analysis7_putTogether_reduced')
% and put them together into 'Ready_data.xlsx': (1) Averaged_1 (for 49 features) and (2) Averaged_2 (for 44 features, after the reduction)
T = xlsread(fullfile(resDir,'Ready_data.xlsx'), 'Averaged_2');  %Averaged_1 - 49 features; Averaged_2 - 44 features

%% Feature model (Figure 2)
createFeatureModel(T,nameFeatures,nameActions)

%% Check the multicollinearity (Table S5)
X = T';
R0 = corrcoef(X);
vif = diag(inv(R0));

%% Correlation between each feature separately (Figure S8)
% Get the RDM and matching fdr-based RDM
correlationBetweenFeatures(T,nameFeatures,resDir)

%% Merge highly correlated ratings
% Merging is happening in the 6th step ('Analysis6_meanOfRatings_reduced.m')

%% Radar plots (Figure 3, Figure S10 and Figure S11)
% run 'radarPlots_Categories.m'
% run 'radarPlots_singleActions.m'

%% 'Quantitive' plots (Figure S12)
% run 'quantitativePlots.m'

%% Generate feature RDMs (Figure S13)
% run 'corrCatFeat_generateRDMs.m'

%% RSA toolbox (correlation between the category and feature RDMs)
%  run 'corrCatFeat_run.m'
%  run 'corrCatFeat_DoCorrPlot.m' (Figure 4a and Figure S14)
%  run 'corrCatFeat_DoWeightPlot.m' (Figure 4b)
