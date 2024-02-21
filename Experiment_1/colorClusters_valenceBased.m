function colorClusters_valenceBased(DSM, lookupTable, leafOrder)

nDims = 2;
[coords,stressVal] = mdscale(squareform(DSM), nDims);

clusterGroup = lookupTable(:,2);

x_vals = coords(leafOrder,1);
y_vals = coords(leafOrder,2);
if nDims == 3
    z_vals = coords(leafOrder,3);
end
[leafOrder_sort, I_leafOrd] = sort(leafOrder);
x_val_sorted = x_vals(I_leafOrd);
y_val_sorted = y_vals(I_leafOrd);


nPoints = length(clusterGroup);

featDir = '~/Experiment_3/'; % For 20 SUB

T = xlsread(fullfile(featDir,'data/Ready_data.xlsx'), 'Averaged_2');  % 44 features
load(fullfile(featDir,'progs/NameFeatures_44'));  % nameFeatures
load(fullfile(featDir,'progs/nameActions'));  % nameActions

% Only for valence
T_val = T(44,:);
weightNorm = (T_val-min(T_val))./range(T_val); %normalized 0:1
% choose the colormap (eg, jet) and number of levels (eg, 100)
nLevels = length(unique(weightNorm));
[unique_weightNorm, ia, ic] = unique(weightNorm);
cmat = gray(nLevels);
figure
for i = 1:nPoints
    %thisAction = find(lookupTable(:,1)==i);
    idx_point = ic(i);
    % assign color
    this_cmat = cmat(idx_point,:);
    
    scatter(x_val_sorted(i),y_val_sorted(i), 200, this_cmat, 'filled')
    text(x_val_sorted(i),y_val_sorted(i), nameActions{i})
    colorbar
    hold on
end
savefig('featBased_2Dplot_Valence.fig')
saveas(gcf,'featBased_2Dplot_Valence.jpg')



% % Bilateral
% bilateral_weightNorm = round(weightNorm);
% nLevels = 2;
% %[unique_weightNorm, ia, ic] = unique(weightNorm);
% cmat = autumn(nLevels);
% 
% figure
% for i = 1:nPoints
%     if bilateral_weightNorm(i)==0
%         this_cmat = cmat(1,:);
%     elseif bilateral_weightNorm(i)==1
%         this_cmat = cmat(2,:);
%     end
%     
%     scatter(x_val_sorted(i),y_val_sorted(i), 200, this_cmat, 'filled')
%     text(x_val_sorted(i),y_val_sorted(i), nameActions{i})
%     hold on
% end
% savefig('featBased_2Dplot_Bilateral_Valence.fig')
% saveas(gcf,'featBased_2Dplot_Bilateral_Valence.jpg')

% % For all the features
% for iFeat = 1:size(T,1)
%     T_val = T(iFeat,:);
%     weightNorm = (T_val-min(T_val))./range(T_val); %normalized 0:1
%     nLevels = length(unique(weightNorm));
%     [unique_weightNorm, ia, ic] = unique(weightNorm);
%     cmat = autumn(nLevels);
%     
%     figure
%     for i = 1:nPoints
%         %thisAction = find(lookupTable(:,1)==i);
%         idx_point = ic(i);
%         % assign color
%         this_cmat = cmat(idx_point,:);
%         
%         scatter(x_val_sorted(i),y_val_sorted(i), 200, this_cmat, 'filled')
%         text(x_val_sorted(i),y_val_sorted(i), nameActions{i})
%         hold on
%     end
%     set(gcf, 'Units', 'Inches', 'Position', [0, 0, 16, 16], 'PaperUnits', 'Inches', 'PaperSize', [16,16])
%     colormap(autumn(256));
%     colorbar;
%     thisName = nameFeatures{iFeat};
%     thisName(thisName == ' ') = [];
%     
%     savefig(sprintf('featBased_2Dplot_%d_%s.fig',iFeat,thisName))
%     saveas(gcf, sprintf('featBased_2Dplot_%d_%s.jpg',iFeat,thisName))
%     
%     close
%     
%     % Bilateral
%     bilateral_weightNorm = round(weightNorm);
%     nLevels = 2;
%     %[unique_weightNorm, ia, ic] = unique(weightNorm);
%     cmat = autumn(nLevels);
%     
%     figure
%     for i = 1:nPoints
%         if bilateral_weightNorm(i)==0
%             this_cmat = cmat(1,:);
%         elseif bilateral_weightNorm(i)==1
%             this_cmat = cmat(2,:);
%         end
%         
%         scatter(x_val_sorted(i),y_val_sorted(i), 200, this_cmat, 'filled')
%         text(x_val_sorted(i),y_val_sorted(i), nameActions{i})
%         hold on
%     end
%     set(gcf, 'Units', 'Inches', 'Position', [0, 0, 16, 16], 'PaperUnits', 'Inches', 'PaperSize', [16,16])
%     
%     colorbar 
%     
%     savefig(sprintf('featBased_2Dplot_Bilateral_%d_%s.fig',iFeat,thisName))
%     saveas(gcf,sprintf('featBased_2Dplot_Bilateral_%d_%s.jpg',iFeat,thisName))
%     
%     close
% 
% end




