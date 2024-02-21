%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load data
pathDir = '~/Experiment_1/';
pathToData = fullfile(pathDir, 'data/');
listOfData = dir([pathToData '*_workspace.mat']);
nSub = length(listOfData);
load(fullfile(pathDir, 'progs/nameVec.mat'));
nActions = length(nameVec);

for i = 1 : nSub
    thisName = [pathToData listOfData(i).name];
    thisDat = load(thisName);
    dat(:,i) = thisDat.estimate_dissimMat_ltv_MA;
    thisDat = [];
end

%% Get the RDM
meanDatB = mean(dat,2);
X = squareform(meanDatB);
meanDatB = (meanDatB');
Y = mdscale(squareform(meanDatB),2);  % for 2D

%% Make a dendrogram and get the silhouette figure
% Defaults that the user might want to change
Cfg.distMethod = 'average';
Cfg.orientation='right';
Cfg.whichMax = 'global'; %Can be 'first', 'second', 'global'
Cfg.nDims = 2;
Cfg.nIter = 100;
Cfg.labels = nameVec';

DSM = meanDatB; 
[~, clusterGroups, outPerm, coords, stressVal] = makeDendrogram(DSM, Cfg);  


%% Show the RDM
figure
imagesc(X(fliplr(outPerm),fliplr(outPerm)));
colorbar
set(gca, 'xtick', [1:1:length(nameVec)], 'ytick', [1:1:length(nameVec)]);
set(gca, 'fontsize', 8);
set(gca, 'xticklabel', nameVec(fliplr(outPerm)), 'yticklabel', []);
rotateXLabels(gca, 45);
axis image;


%% Find which actions belong to these clusters
nActions = max(clusterGroups);
for iAct = 1:nActions
    theseAct = find(clusterGroups == iAct);
    allActions{iAct} = nameVec(theseAct);
end


%% Save
save('MDS_results','dat');

%% Generate word clouds (manually for now)
% run_wordClouds

