function Figure6_sampling_bias(analysis_type)
    %% Figure 6   
    % PANEL A - Sampling bias at the class level 
    load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset');
    load([pwd,'/Results/current_analysis/phylogenetic_class_individuals.mat'],'phylogenetic_class_individuals_selected_to_plot');

    % Load the data points and the position of the archetypes previously found with the function "findArchetypes.m"
    idx_data = 8;
    nametable = table_selected_dataset(idx_data).tableselected.nametable;
    name_class = table_selected_dataset(idx_data).tableselected.name_class; arch_class = table_selected_dataset(idx_data).tableselected.arch_class;
    load([pwd,'/Results/current_analysis/paretofront_',char(nametable),'_',char(analysis_type),'.mat'],'PvalueRatio','DataPoints_front','meanClstErrs', ...
        'NArchetypes','El1','El2','Coeff2d','namefolder');
    params_Pareto_analysis; % load the parameters for the Pareto analysis

    figure; set(gcf,'Position',[00, 00, 592, 440]); hold on;
    plot([10^(meanClstErrs(1,1)),10^(meanClstErrs(2,1))],[10^(meanClstErrs(1,2)),10^(meanClstErrs(2,2))],'k-','LineWidth',1); hold on;
    plot([10^(meanClstErrs(1,1)),10^(meanClstErrs(3,1))],[10^(meanClstErrs(1,2)),10^(meanClstErrs(3,2))],'k-','LineWidth',1); hold on;
    plot([10^(meanClstErrs(2,1)),10^(meanClstErrs(3,1))],[10^(meanClstErrs(2,2)),10^(meanClstErrs(3,2))],'k-','LineWidth',1); hold on;
    CLASS  = {'Amphibia','Aves','Mammalia','Reptilia'}; 
    color_class = {[175, 29, 29]/255,  [255, 194, 10]/255, [12, 123, 220]/255,[0,0,0]};
    vertex_color_class = {[175, 29, 29]/255,  [255, 194, 10]/255, [12, 123, 220]/255,[0,0,0]};    
    for arcCol  = 1:NArchetypes
        DATA_class = strcmp(phylogenetic_class_individuals_selected_to_plot,CLASS{arcCol});
        DataPLOT  = DataPoints_front(DATA_class,:);
        scatter(10.^(DataPLOT(:,1)),10.^(DataPLOT(:,2)),10,color_class{arcCol},'o', 'filled',...
            'MarkerFaceAlpha',1,'MarkerEdgeColor',color_class{arcCol},'MarkerEdgeAlpha',1);hold on;
        if params_Pareto.maxRuns > 0 % Only show errors if we actually asked to compute them
            xc = meanClstErrs(arcCol,1);
            yc = meanClstErrs(arcCol,2);
            a = El1(arcCol);
            b = El2(arcCol);
            Q = Coeff2d{arcCol};
            [coords_ellipse] = ellipse(xc, yc, a, b, Q, vertex_color_class{arcCol});hold on;
        else
           scatter(10^(meanClstErrs(arcCol,1)),10^(meanClstErrs(arcCol,2)),140,vertex_color_class{arcCol},'filled');hold on;
        end
        patch(10.^(coords_ellipse(1,:)), 10.^(coords_ellipse(2,:)),vertex_color_class{arcCol},'EdgeColor',vertex_color_class{arcCol},'FaceAlpha',0.6)
        text(10^(meanClstErrs(arcCol,1)),10^(meanClstErrs(arcCol,2)),['      ',char(arch_class),num2str(arcCol)],'FontSize',20);
    end
    DATA_class = strcmp(phylogenetic_class_individuals_selected_to_plot,CLASS{arcCol+1});    
    DataPLOT = DataPoints_front(DATA_class,:); 
    scatter(10.^(DataPLOT(:,1)),10.^(DataPLOT(:,2)),15,color_class{arcCol+1},'o', 'filled','MarkerEdgeColor','k','MarkerEdgeAlpha',1);hold on;
    box on;xlabel(['Body Mass (g)']);ylabel(['Sperm Length (\mum)']); title([name_class, ' (pval = ', num2str(PvalueRatio),')']); hold on;
    ax = gca; ax.LineWidth = 1; ax.XColor=[0.25 0.25 0.25];ax.YColor=[0.25 0.25 0.25];
    xlim([1E-2 1E+8]); ylim([5 2E+3]); set(gca,'Xscale','Log','Yscale','Log','linewidth',1,'FontSize',15, 'FontWeight','bold'); hold on;

    % Draw the background of the plot
    r = 204/255; g = 119/255; b = 34/255; selectedColor = [r, g, b]; x = [1E-2, 1E+10, 1E+10, 1E-2]; y = [5, 5,2E+3, 2E+3]; 
    patch(x, y, selectedColor, 'EdgeColor', 'none', 'FaceAlpha', 0.065, 'LineWidth', 1);    

    % Uncomment the line below to save on the Drive
    filename = [namefolder,name_class,' Pareto_Front_xy_',char(analysis_type),'.pdf']; set(gcf,'renderer','Painters'); exportgraphics(gcf,filename,'ContentType','vector');
    
    %% PANEL B - sampling bias in general
    load('Results/current_analysis/phy_tree_classification.mat','tree');        
    % Extract information from the tree, including the node and branch info
    numLeaves = get(tree, 'NumLeaves');
    num_internal_nodes =  get(tree, 'NumBranches');
    numTotalNodes = numLeaves + num_internal_nodes;
    pointers = get(tree, 'Pointers'); % Parent to children mapping
    distances = get(tree, 'Distance');            
    % A function which computes the total branch lengths for each node
    totalBranchLengths = find_branch_lengths(numLeaves,num_internal_nodes,numTotalNodes,distances,pointers);

    load('Results/current_analysis/phy_tree_classification.mat','thr_ALL');
    load('Results/current_analysis/PvalueRatio_sample_size_iter_ALL.mat','PvalueRatio_sample_size_iter','perct_ALL')
    nIter = length(PvalueRatio_sample_size_iter);
    sample_size_ALL = length(PvalueRatio_sample_size_iter{1});
    nThr = length(PvalueRatio_sample_size_iter{1}{1});
    PvalueRatio_MAT = zeros(sample_size_ALL, nThr, nIter);
    for iter = 1:nIter
        PvalueRatio_MAT(:,:,iter) = cell2mat(vertcat(PvalueRatio_sample_size_iter{iter}{:}));
    end 
    meanPvalueRatio_MAT = mean(PvalueRatio_MAT,3);
    stdPvalueRatio_MAT = std(PvalueRatio_MAT, 0, 3)/sqrt(nIter);
    
    % Plot the results
    figure; set(gcf,'Position',[00, 00, 500, 250]); hold on;
    transparency_areas = 0.1;
    colors = jet(sample_size_ALL); 
    plotObjects = gobjects(sample_size_ALL, 1); 
    tot_time = max(totalBranchLengths);
    thr_ALL = tot_time-thr_ALL;
    for i = 1:sample_size_ALL
        p = plot(thr_ALL, meanPvalueRatio_MAT(i,:), 'Color', colors(i,:), 'LineWidth', 1); hold on;
        plotObjects(i) = p; 
        fill([thr_ALL fliplr(thr_ALL)],[meanPvalueRatio_MAT(i,:)+stdPvalueRatio_MAT(i,:) fliplr(meanPvalueRatio_MAT(i,:)-stdPvalueRatio_MAT(i,:))], colors(i,:),'FaceAlpha',transparency_areas,'EdgeColor','none');hold on;        
    end
    ylabel('p-values'); xlabel('Mya');
    yline(0.05,'k-.','LineWidth',1.5);
    box on;
    percentageLabels = arrayfun(@(x) [num2str(x) '%'], perct_ALL(1:end-1), 'UniformOutput', false);
    legend(plotObjects, percentageLabels, 'Location', 'EastOutside');
    xlim([0 330]); set(gca, 'XDir', 'reverse');
    % Uncomment the line below to save on the Drive
    mkdir([pwd,'/Figures/Figure 6/']);
    filename = [pwd,'/Figures/Figure 6/pvals_phyl_dependence_sample_size.pdf']; exportgraphics(gcf,filename,'ContentType','vector');  
end