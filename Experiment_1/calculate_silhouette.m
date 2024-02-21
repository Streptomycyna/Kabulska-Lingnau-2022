function [s_idx, s_std_idx, clust_max] = calculate_silhouette(DSM, tree, maxClustNum, doPlot)
D_Mat = squareform(DSM);

clusterNums = 3:maxClustNum;   


nClusterIters = length(clusterNums);
s_idx = zeros(1,nClusterIters);
s_std_idx = zeros(1,nClusterIters);
s_sem_idx = zeros(1,nClusterIters);

if doPlot
    figure
    %pause(0.01)
end

for iIter = 1:nClusterIters
    
    t = cluster(tree, 'maxclust', clusterNums(iIter));
    unq_clusters = unique(t);
    nClusters = clusterNums(iIter);
    clusterIndices = cell(1, clusterNums(iIter));
    for iCluster = 1:nClusters
        clusterIndices{iCluster} = find(t==iCluster);
    end
    
    %     b = zeros(1,nClusters);
    %     a = zeros(1,nClusters);
    s = zeros(1,nClusters);
    nClusters = length(unq_clusters);
    
    for iCluster = 1:nClusters
        otherClusters = find(~ismember(unq_clusters,iCluster));
        nOtherClusters = length(otherClusters);
        
        clusterMembers = clusterIndices{iCluster};
        
        nClusterMembers = length(clusterMembers);
        dissim_wi = cell(1,nClusterMembers-1);
        dissim_bw = cell(1,nOtherClusters);
        bw = NaN(nClusterMembers,nOtherClusters);
        
        % As per Rousseeuw's definition, we define s(i) = 0 if this cluster
        % has only 1 member, so we can skip all the calculations for this
        % cluster
        if nClusterMembers ==1
            s(iCluster) = 0;
        else
            for iMember = 1:nClusterMembers
                % For a given cluster member, first calculate the average
                %   within-cluster dissimilarity
                ref = clusterMembers(iMember);
                
                %             if iMember < nClusterMembers
                %                 comparison = clusterMembers(iMember+1:end);
                %                 dissim_wi{iMember} = D_Mat(ref, comparison);
                %             end
                
                comparison = setdiff(clusterMembers,ref);
                dissim_wi{iMember} = D_Mat(ref, comparison);
                
                
                
                for iOtherCluster = 1:nOtherClusters
                    % Then calculate the between-cluster dissimilarity for all
                    % other clusters
                    currentComparisonCluster = otherClusters(iOtherCluster);
                    otherClusterMembers = clusterIndices{currentComparisonCluster};
                    dissim_bw{iMember, iOtherCluster} = D_Mat(ref, otherClusterMembers);
                    
                end
            end
            %dissim_bw{i} = D_Mat(refNode, nonClusterNodes);
            
            %wi = nanmean(cell2mat(dissim_wi));
            wi = cell2mat(dissim_wi');
            for i = 1:size(dissim_bw,2)
                clusterConnections = cell2mat(dissim_bw(:,i));
                bw(:,i) = nanmean(clusterConnections,2);
            end
            %allBw(iCluster,:) = bw;
            
            b_thisCluster = min(bw,[],2);
            a_thisCluster = nanmean(wi,2);
            s_thisCluster = (b_thisCluster - a_thisCluster)./(max(a_thisCluster,b_thisCluster));
            
            %         b(iCluster) = min(bw,[],2);
            %         a(iCluster) = wi;
            
            s(iCluster) = nanmean(s_thisCluster);
        end
    end
    
    s_idx(iIter) = nanmean(s);
    s_std_idx(iIter) = nanstd(s);
    s_sem_idx(iIter) = nanstd(s)./sqrt(length(s));
    
    %Initialize for first case
    if iIter == 1
        s_max = s_idx(iIter);
        clust_max = clusterNums(iIter);
        
        % Otherwise evaluate if next s-index is higher than previous for
        % dynamic plotting
    elseif s_idx(iIter) > s_max
        s_max = s_idx(iIter);
        clust_max = clusterNums(iIter);
    end
    
    if doPlot
        s_to_plot = s_idx;
        s_to_plot(s_to_plot==0)=NaN;
        plot(clusterNums, s_to_plot,'-o','linewidth', 2)
        hold on
        set(gca,'xtick', clusterNums(1):1:clusterNums(end), 'xticklabel', clusterNums(1):1:clusterNums(end));
        xlim([1, maxClustNum])
        %ylim([0 0.3])
        line([clust_max, clust_max],[0 s_max], 'linewidth', 3, 'color', 'r')
        line([2, clust_max],[s_max s_max], 'linewidth', 3, 'color', 'r')     
        xlabel('Number of Clusters', 'FontSize', 15)
        ylabel('Mean silhouette index','FontSize', 20)
        %title(sprintf('There are %g stable clusters', clust_max))
        box off
        hold off
        %pause(.01)
    end
    
end

%line([13, 13],[0 0.2138], 'linewidth', 3, 'color', 'r')
%line([2 13],[0.2138 0.2138], 'linewidth', 3, 'color', 'r')  