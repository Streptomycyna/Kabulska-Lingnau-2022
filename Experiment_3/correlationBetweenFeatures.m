function correlationBetweenFeatures(T,nameThemes,resDir)

% Get the RDM
TT = T';
[r,p] = corrcoef(TT); % Pearson's correlation between features
figure;
imagesc(r); colorbar
caxis([-1 1])
set(gca, 'xtick', [1:1:length(nameThemes)], 'ytick', [1:1:length(nameThemes)]);
set(gca, 'fontsize', 10);
set(gca, 'xticklabel', nameThemes, 'yticklabel', nameThemes);
rotateXLabels(gca, 45);
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 15, 15], 'PaperUnits', 'Inches', 'PaperSize', [20,20])
nFeat = length(r);
%savefig(fullfile(resDir, sprintf('Correlation_betweenFeatures_%d.fig', nFeat)))
saveas(gcf,fullfile(resDir, sprintf('Correlation_betweenFeatures_%d.svg', nFeat)))
saveas(gcf,fullfile(resDir, sprintf('Correlation_betweenFeatures_%d.jpg', nFeat)))

% comupute FDR
d = logical(eye(size(p)));
pp = p;
pp(d) = 0;
p_vec = squareform(pp,'tovector');
fdr = mafdr(p_vec,'BHFDR', true);
p_fdr = squareform(fdr);
p_fdr_map = p_fdr<0.05;
figure; 
imagesc(p_fdr_map)
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 15, 15], 'PaperUnits', 'Inches', 'PaperSize', [20,20])
%savefig(fullfile(resDir, sprintf('Correlation_betweenFeatures_%d_pval_fdr.fig', nFeat)))
saveas(gcf,fullfile(resDir, sprintf('Correlation_betweenFeatures_%d_pval_fdr.svg', nFeat)))
saveas(gcf,fullfile(resDir, sprintf('Correlation_betweenFeatures_%d_pval_fdr.jpg', nFeat)))

close all



