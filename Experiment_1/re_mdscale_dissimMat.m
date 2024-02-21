function [coords,stressVal] = re_mdscale_dissimMat(DSM, lookupTable, colorPalette, leafOrder, nDims)

if nDims > 3 || nDims < 2
    error('Only 2 or 3 dimensions are currently supported for multdimensional scaling');
end

[coords,stressVal] = mdscale(squareform(DSM), nDims);

clusterGroup = lookupTable(:,2);

x_vals = coords(leafOrder,1);
y_vals = coords(leafOrder,2);
if nDims == 3
    z_vals = coords(leafOrder,3);
end

nPoints = length(clusterGroup);

%%% 27.01.2022 ZK
contOneClust = find(hist(clusterGroup,unique(clusterGroup))==1);
for iClust = 1:length(contOneClust)
    thisClust = contOneClust(iClust);
    colorPalette(thisClust,:) = [0.5 0.5 0.5];
end

figure
for i = 1:nPoints
    
    switch nDims
        case 2
            scatter(x_vals(i),y_vals(i), 200, colorPalette(clusterGroup(i),:), 'filled') 

        case 3
            scatter3(x_vals(i),y_vals(i), z_vals(i), 48, colorPalette(clusterGroup(i),:), 'filled')
    end
            hold on
end
set(gca,'xtick',[], 'ytick', [])
xlabel('Dimension 1')
ylabel('Dimension 2')

