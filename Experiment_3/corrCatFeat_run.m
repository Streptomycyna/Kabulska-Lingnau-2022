function corrCatFeat_run
% Figure 4a and Figure S14 (Correlation between the category- and feature RDMs)

%% Wrapper for fitting models with multiple components using bootstrapped 
% cross-validated reweighting.
% based on script from katherine.storrs@gmail.com

% First specify the path to do rsa toolbox (Nili et al., 2014)
rsa_toolbox_dir = '/Users/zuzakabulska/Documents/Toolboxes/rsatoolbox-develop';
addpath(genpath(rsa_toolbox_dir));

%% Set these to appropriate paths:
resDir = '~/Experiment_3/data';

output = fullfile(resDir, 'corrCatFeat');
if ~exist(output)
    mkdir(output)
end

nboots = 1000; % should be 1000
nCV = 50;
%% load data and set options...
load(fullfile(resDir,'MDS_results.mat')); % MDS results for 20 participants, saved as 'dat' (reference RDM)
meanDat = dat;
for s = 1:size(meanDat,2)
    this_subj = meanDat(:,s);
    this_subj = (this_subj - min(this_subj))/(max(this_subj) - min(this_subj));
    this_subj = squareform(this_subj);
    this_subj(logical(eye(size(this_subj,1)))) = NaN;
    refRDMs(:,:,s) = this_subj;
end

% options used by FUNC_bootstrap_wrapper
highlevel_options.boot_options.nboots = nboots; 
highlevel_options.boot_options.boot_conds = false; 
highlevel_options.boot_options.boot_subjs = false; 

% options used by FUNC_reweighting_wrapper
highlevel_options.rw_options.nTestSubjects = 5;
highlevel_options.rw_options.nTestImages = 10;
highlevel_options.rw_options.nCVs = nCV; % number of crossvalidation loops within each bootstrap sample (stabilises estimate)


%% Loading up sets of RDMs and adding them to the cell array `model_RDMs`

% Single-feature RDMs
dat = xlsread(fullfile(resDir,'Ready_data.xlsx'), 'Averaged_2');
[nFeatures nActions] = size(dat);
for i = 1:nFeatures
    thisModel = pdist(dat(i,:)');
    thisModel = (thisModel - min(thisModel))/(max(thisModel) - min(thisModel));
    singFeatRDMs(i).RDM = squareform(thisModel);
end

% Multi-feature RDM
rawRDM = pdist(dat');
rawRDM = (rawRDM - min(rawRDM))/(max(rawRDM) - min(rawRDM));

% Theme RDMs
clear thisModel
theme1 = 1:5; % body parts
theme2 = 6:10; % object-directedness
theme3 = 11:14; % trajecotry
theme4 = 15:24; % type of limb movement
theme5 = 25:29; % posture
theme6 = 30:31; % location

themes = {theme1, theme2, theme3, theme4, theme5, theme6};
for i = 1:length(themes)
    thisModel = pdist(dat(themes{i},:)');
    thisModel = (thisModel - min(thisModel))/(max(thisModel) - min(thisModel)); 
    singThemeRDMs(i).RDM = squareform(thisModel);
end

% put these into a nested struct
layer_struct.singFeatRDMs.RDM = singFeatRDMs;
layer_struct.singFeatRDMs.name = 'single feature models';
layer_struct.rawRDM.RDM = squareform(rawRDM);
layer_struct.rawRDM.name = 'raw multidimensional feature model';
layer_struct.singThemeRDMs.RDM = singThemeRDMs;
layer_struct.singThemeRDMs.name = 'single theme models';

model_RDMs = layer_struct; % add to whole-model cell array

%% analyse
[full_results, ceiling_results, full_weights] = FUNC_bootstrap_wrapper(refRDMs, model_RDMs, highlevel_options);

% save bootstrap distributions
save(fullfile(output,'bootstrap_output_full_results'), 'full_results');
save(fullfile(output,'bootstrap_output_weights'), 'full_weights');
save(fullfile(output,'bootstrap_output_ceilings'), 'ceiling_results');

end
