function [h, clusterGroups, outperm, coords, stressVal] = makeDendrogram(DSM, varargin)

% Makes a dendrogram from a similarity matrix (or similarity vector if it
% has not yet been squareformed)

if ~isempty(varargin)
    Cfg = varargin{1};
else
    Cfg = [];
end

% Initialize defaults
if ~isfield(Cfg, 'distMethod'), Cfg.distMethod = 'average'; else end
if ~isfield(Cfg, 'labels'), Cfg.labels = []; else end
if ~isfield(Cfg, 'orientation'), Cfg.orientation = 'right'; else end
if ~isfield(Cfg, 'whichMax'), Cfg.whichMax = 'global'; else end
if ~isfield(Cfg, 'nDims'), Cfg.nDims = 2; else end
if ~isfield(Cfg, 'nIter'), Cfg.nIter = 100; else end


% Just squareform to get the number of items
DistMat = squareform(DSM);
nItems = length(DistMat);

% Get the tree for making a dendrogram
tree = linkage(DSM,Cfg.distMethod);

% Calculate the cophenetic distance
%[c,D] = cophenet(tree,DSM);

% Cacluclate silhouette
switch Cfg.whichMax
    case 'global'
        [si,~,c_max] = calculate_silhouette(DSM, tree, ceil(length(DistMat)/2), 1);
        clusterGroups = cluster(tree, 'maxclust', c_max);
        
    case {'first', 'second'}
        si = calculate_silhouette(DSM, tree, ceil(length(DistMat)/2), 1);
        
        % I'm appending a 0 to the front of the si vector so that the
        % findpeaks function will consider the first value of the 
        % non-padded si vector as a potential peak
        si_padded = [0, si];
        [pks,loc] = findpeaks(si_padded);
        switch Cfg.whichMax
            case 'first'
                c_firstmax = loc(1);
            case 'second'
                c_firstmax = loc(2);
        end
        clusterGroups = cluster(tree, 'maxclust', c_firstmax);
end

figure
[h,~,outperm]=dendrogram(tree, nItems, 'Orientation', Cfg.orientation);

set(gca, 'fontsize', 12);
set(h, 'linewidth', 2)

% Defines x- and y-axis labels
if ~isempty(Cfg.labels)
    switch Cfg.orientation
        case {'left', 'right'}
            set(gca, 'yticklabel', Cfg.labels(outperm));
            xlabel('Average Distance');
        case {'top','bottom'}
            set(gca, 'xticklabel', Cfg.labels(outperm));
            ylabel('Average Distance');
            rotateXLabels(gca,45);
    end
end

% Color the clusters appropriately
[ImageNum_and_color, colorPalette] = colorClusters(h, tree, clusterGroups, outperm);

% Perform a multidimensional scaling
[coords, stressVal] = re_mdscale_dissimMat(DSM, ImageNum_and_color, colorPalette, outperm, Cfg.nDims);

% For valence-based action organization (Figure S15)
% colorClusters_valenceBased(DSM, ImageNum_and_color, outperm)


