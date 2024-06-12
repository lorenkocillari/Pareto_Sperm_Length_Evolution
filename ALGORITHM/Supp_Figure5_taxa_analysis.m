function Supp_Figure5_taxa_analysis
    %% PANEL A - Plot the number of groups
    mkdir([pwd,'/Figures/Figure S5/']);
    load('Results/current_analysis/PvalueRatio_ALL.mat','PvalueRatio')
    nThr = size(PvalueRatio{1},2);
    nIter = length(PvalueRatio);
    PvalueRatio_MAT = zeros(nIter, nThr);
    for iter = 1:nIter
        PvalueRatio_MAT(iter,:) = cell2mat(PvalueRatio{iter});
    end 
    % Find the epoch when the pvalue is not significant anymore
    ttest_thr = zeros(1,nThr);
    for thr = 1:nThr
        [~,ttest_thr(thr)] = ttest(PvalueRatio_MAT(:,thr),0.05,'Tail','left');
    end
    allpvals_below_05_thr = find(ttest_thr < 0.05);
    
    load('Results/current_analysis/phy_tree_classification.mat','tree','thr_ALL');        
    % Extract information from the tree, including the node and branch info
    numLeaves = get(tree, 'NumLeaves');
    num_internal_nodes =  get(tree, 'NumBranches');
    numTotalNodes = numLeaves + num_internal_nodes; % Total number of nodes
    pointers = get(tree, 'Pointers'); % Parent to children mapping
    distances = get(tree, 'Distance');            
    % A function which computes the total branch lengths for each node
    totalBranchLengths = find_branch_lengths(numLeaves,num_internal_nodes,numTotalNodes,distances,pointers);
    
    tot_time = max(totalBranchLengths);
    thr_ALL = tot_time-thr_ALL;
    
    load('Results/current_analysis/phy_tree_classification.mat','uniqueVectors');    
    n_groups = zeros(1,length(uniqueVectors));
    for i = 1:length(uniqueVectors)
       n_groups(i) = length(uniqueVectors{i});
    end
    figure('Visible','on'); set(gcf,'Position',[00, 00, 500, 250]); hold on; 
    plot(thr_ALL, n_groups,'k','LineWidth',1.25); 
    box on;
    xline(thr_ALL(allpvals_below_05_thr(end)),'b--'); hold on;
    xlim([0 thr_ALL(4)]);
    set(gca, 'XDir', 'reverse');
    
    ylabel('Number of taxa'); xlabel('Mya');
        % Uncomment the line below to save on the Drive
    filename = [pwd,'/Figures/Figure S5/n_groups_evolutionary_time.pdf']; exportgraphics(gcf,filename,'ContentType','vector');  
    
    %% PANEL B - Plot the marginal distributions
    load('Results/current_analysis/PvalueRatio_clusters_ALL.mat','centroid_clusters');
    load('Results/current_analysis/phy_tree_classification.mat','DataPoints');    
    figure('Visible','on'); set(gcf,'Position',[00, 00, 250, 500]); hold on; 
    subplot(2,1,1); hold on;
    title('Species dataset');
    plot(histcounts(DataPoints(:,1),10,'Normalization','probability')); hold on;
    plot(histcounts(DataPoints(:,2),10,'Normalization','probability')); hold on;
    legend('SL','BM')
    subplot(2,1,2); hold on;
    title('Taxa');
    iter= 61;
    plot(histcounts(centroid_clusters{1}{iter}(:,1),10,'Normalization','probability')); hold on;
    plot(histcounts(centroid_clusters{1}{iter}(:,2),10,'Normalization','probability')); hold on;
        % Uncomment the line below to save on the Drive
    filename = [pwd,'/Figures/Figure S5/marginal_distributions_clusters.pdf']; exportgraphics(gcf,filename,'ContentType','vector');  
    
    %% PANEL C    
    % Test for triangularity on the small clusters for pval>0.05
    load('Results/current_analysis/phy_tree_classification.mat','tree');        
    % Extract information from the tree, including the node and branch info
    numLeaves = get(tree, 'NumLeaves');
    num_internal_nodes =  get(tree, 'NumBranches');
    numTotalNodes = numLeaves + num_internal_nodes; % Total number of nodes
    pointers = get(tree, 'Pointers'); % Parent to children mapping
    distances = get(tree, 'Distance');            
    % A function which computes the total branch lengths for each node
    totalBranchLengths = find_branch_lengths(numLeaves,num_internal_nodes,numTotalNodes,distances,pointers);
    
    load('Results/current_analysis/phy_tree_classification.mat','thr_ALL');
    load('Results/current_analysis/PvalueRatio_clusters_ALL.mat','PvalueRatio_clusters')
    nThr = length(cell2mat(PvalueRatio_clusters{1}));
    nIter = length(PvalueRatio_clusters);
    PvalueRatio_clusters_MAT = zeros(nIter, nThr);
    for iter = 1:nIter
        PvalueRatio_clusters_MAT(iter,:) = cell2mat(PvalueRatio_clusters{iter});
    end
    mean_pvals_clusters = mean(PvalueRatio_clusters_MAT,1);   
    std_pvals_clusters = std(PvalueRatio_clusters_MAT); 
    
    tot_time = max(totalBranchLengths);
    thr_ALL = tot_time-thr_ALL;
    
    figure('Visible','on'); set(gcf,'Position',[00, 00, 500, 250]); hold on;
    transparency_areas = 0.2;
    plot(thr_ALL(4:end), mean_pvals_clusters, 'k', 'LineWidth', 1.5); hold on;
    fill([thr_ALL(4:end) fliplr(thr_ALL(4:end))],[mean_pvals_clusters+std_pvals_clusters fliplr(mean_pvals_clusters-std_pvals_clusters)], 'k','FaceAlpha',transparency_areas,'EdgeColor','none');hold on;    
    ylabel('p-values'); xlabel('Mya');
    yline(0.05,'r-','LineWidth',1.25);
    xline(thr_ALL(allpvals_below_05_thr(end)),'b-.','LineWidth',1); hold on;
    box on;
    xlim([0 thr_ALL(4)]);
    set(gca, 'XDir', 'reverse');
    ylim([0 1]);
        % Uncomment the line below to save on the Drive
    filename = [pwd,'/Figures/Figure S5/pvals_phyl_dependence_clusters.pdf']; exportgraphics(gcf,filename,'ContentType','vector');  
    
end