function createFeatureModel(T,nameThemes,nameVec)

[nThemes,nActions] = size(T);
figure;
cmap = gray(256);
cmap = flipud(cmap);
colormap(cmap); % Apply the custom colormap.
% imagesc(T); colorbar   % horizontal
% axis image;
% set(gca, 'xtick', 1:1:nActions, 'ytick', 1:1:nThemes);  
% set(gca, 'XAxisLocation', 'top', 'xticklabel', nameVec);
% set(gca, 'ytick', 1:1:nThemes, 'yticklabel', nameThemes);
imagesc(T'); colorbar   % vertical
axis image;
set(gca, 'xtick', 1:1:nThemes, 'ytick', 1:1:nActions)    
set(gca, 'XAxisLocation', 'top', 'xticklabel', nameThemes);
set(gca, 'ytick', 1:1:nActions, 'yticklabel', nameVec);
rotateXLabels(gca, 45);
set(gca, 'fontsize', 6);
set(gcf, 'Position', [20 20 1000 1200])


