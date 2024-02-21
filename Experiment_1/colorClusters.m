function [ImageNum_and_color, colorPalette] = colorClusters(figHandle, tree, clusters, outPerm)
obj = figHandle;

%colorPalette = jet(max(clusters));
% c_max = max(clusters);
% colorPalette=linspecer(c_max);
colorPalette=getColorPalette;

leafOrderLookup = [outPerm',clusters(outPerm)];
maxLeaf = max(outPerm);
newClusters = maxLeaf+1:max(tree(:,2));
newClusters(end+1) = NaN;
counter = 0;
for i = 1:maxLeaf-1
    counter = counter + 1;
    % Goes from lowest to highest, same order that we will color
    theseLeaves = tree(counter,1:2);

    if all(theseLeaves <= maxLeaf)
        firstLeaf = find(leafOrderLookup(:,1)==theseLeaves(1));
        secondLeaf = find(leafOrderLookup(:,1)==theseLeaves(2));
        
        
        if leafOrderLookup(firstLeaf,2) == leafOrderLookup(secondLeaf,2)
            thisCol = colorPalette(leafOrderLookup(firstLeaf,2),:);
        else
            thisCol = [0 0 0];
        end
    elseif xor(theseLeaves(1) <= maxLeaf, theseLeaves(2) <= maxLeaf)
        
        originalLeaf = min(theseLeaves);
        higherCluster = max(theseLeaves);
        originalCluster = find(leafOrderLookup(:,1)==originalLeaf);
        
        ClusterBelow = find(newClusters==higherCluster);
        FirstColorBelow = get(obj(ClusterBelow),'Color');

        if colorPalette(leafOrderLookup(originalCluster,2),:) == FirstColorBelow
            thisCol = colorPalette(leafOrderLookup(originalCluster,2),:);
        else
            thisCol = [0 0 0];
        end
       
    else
        FirstLeafBelow = find(newClusters==theseLeaves(1));
        SecondLeafBelow = find(newClusters==theseLeaves(2));
        
        FirstColorBelow = get(obj(FirstLeafBelow),'Color');
        SecondColorBelow = get(obj(SecondLeafBelow),'Color');
        
        if FirstColorBelow == SecondColorBelow
            thisCol = FirstColorBelow;
        else
            thisCol = [0, 0, 0];
        end
    end
    set(obj(i),'Color', thisCol);
end

ImageNum_and_color = leafOrderLookup(leafOrderLookup(:,1)<=maxLeaf,:);
