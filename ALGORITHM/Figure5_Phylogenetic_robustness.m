function Figure5_Phylogenetic_robustness
%% PANEL A - Plot the phylogenetic tree as a function of the milion of years.
    mkdir([pwd,'/Figures/Figure 6']);
    load('Results/current_analysis/phy_tree_classification.mat','tree');    
    % Plot the main phylogenetic tree (Panel A)
    H = plot(tree, 'Type','square','Orientation', 'top','LeafLabels','false','TerminalLabels','false'); % Plot the tree and capture the plot handle
%     H = plot(tree, 'Type','square','Orientation', 'top'); % Plot the tree and capture the plot handle
    set(gcf,'Position',[00, 00, 350, 500]); hold on;
    yline(100,'r')
    yline(285.7,'r')
    yline(333,'r')
    ax = gca; % Get the current axes
    ax.XTick = []; % Remove X tick marks
    ax.YAxisLocation = 'right';
    ax.YLabel.String = 'Millions of years'; % Set the Y-axis label
    set(H.BranchDots, 'Marker', 'none'); % Remove markers from terminal nodes
    set(H.LeafDots, 'Marker', 'none'); % Remove markers from branch nodes    
    
        % Extract information from the tree, including the node and branch info
    numLeaves = get(tree, 'NumLeaves');
    num_internal_nodes =  get(tree, 'NumBranches');
    numTotalNodes = numLeaves + num_internal_nodes; % Total number of nodes
    pointers = get(tree, 'Pointers'); % Parent to children mapping
    distances = get(tree, 'Distance');            
    % A function which computes the total branch lengths for each node
    totalBranchLengths = find_branch_lengths(numLeaves,num_internal_nodes,numTotalNodes,distances,pointers);
  
%         % Uncomment the line below to save on the Drive
%     filename = [pwd,'/Figures/Figure 6/phyl_tree_ALL.pdf']; exportgraphics(gcf,filename,'ContentType','vector');    
    
    %% PANEL B - Plot different phyl trees based on different thresholds ()
    load('Results/current_analysis/phy_tree_classification.mat','thr_ALL');
    tic;
    [uniqueVectors100] = plot_phyl_tree_thr(thr_ALL(16), tree);
    [uniqueVectors290] = plot_phyl_tree_thr(thr_ALL(51), tree);
    [uniqueVectors333] = plot_phyl_tree_thr(thr_ALL(59), tree);
    toc;
    
    %% Panel D -- Plot the pvals as a function of time 
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
    load('Results/current_analysis/PvalueRatio_ALL.mat','PvalueRatio')
    nThr = size(PvalueRatio{1},2);
    nIter = length(PvalueRatio);
    PvalueRatio_MAT = zeros(nIter, nThr);
    for iter = 1:nIter
        PvalueRatio_MAT(iter,:) = cell2mat(PvalueRatio{iter});
    end
    mean_pvals = mean(PvalueRatio_MAT,1);   
    std_pvals = std(PvalueRatio_MAT);   
    
    % Find the epoch when the pvalue is not significant anymore
%     signrank_thr = zeros(1,nThr);
    ttest_thr = zeros(1,nThr);
    for thr = 1:nThr
%         [signrank_thr(thr),~] = signrank(PvalueRatio_MAT(:,thr),0.05,'Tail','left');
        [~,ttest_thr(thr)] = ttest(PvalueRatio_MAT(:,thr),0.05,'Tail','left');
    end
%     allpvals_below_05_thr = find(signrank_thr < 0.05);
    allpvals_below_05_thr = find(ttest_thr < 0.05);
        
    tot_time = max(totalBranchLengths);
    thr_ALL = tot_time-thr_ALL;
    % Plot the figure
    figure('Visible','on'); set(gcf,'Position',[00, 00, 500, 250]); hold on;
    transparency_areas = 0.2;
    plot(thr_ALL, mean_pvals, 'k', 'LineWidth', 1.5); hold on;
    fill([thr_ALL fliplr(thr_ALL)],[mean_pvals+std_pvals fliplr(mean_pvals-std_pvals)], 'k','FaceAlpha',transparency_areas,'EdgeColor','none');hold on;    
%     plot(thr_ALL(52:end), mean_pvals_clusters, 'b', 'LineWidth', 1.5); hold on;
%     fill([thr_ALL(52:end) fliplr(thr_ALL(52:end))],[mean_pvals_clusters+std_pvals_clusters fliplr(mean_pvals_clusters-std_pvals_clusters)], 'b','FaceAlpha',transparency_areas,'EdgeColor','none');hold on;    
    ylabel('p-values'); xlabel('Mya');
    yline(0.05,'r-','LineWidth',1.25);
    xline(thr_ALL(allpvals_below_05_thr(end)),'b-.','LineWidth',1); hold on;
%     xline(thr_ALL(56));
    box on;
%     xlim([thr_ALL(1) 355]);
%     xlim([0 330]); 
    xlim([0 thr_ALL(4)]);
    set(gca, 'XDir', 'reverse');
    ylim([0 0.6]);

% Plot the tree and capture the plot handle
% filename = [pwd,'/Figures/Figure 6/pvals_phyl_dependence.pdf']; exportgraphics(gcf,filename,'ContentType','vector');  
end