function [uniqueVectors] = plot_phyl_tree_thr(thr, tree)
%%
    n = 1347; 
    rand_col_mat = rand(n, 3);
    possibleColors = cell(n, 1);
    for i = 1:n
        possibleColors{i} = rand_col_mat(i, :);
    end
    % Plot the tree 
    H = plot(tree, 'Type','square','LeafLabels','false','Orientation', 'top','TerminalLabels','false'); 
    set(gcf,'Position',[00, 00, 300, 150]); hold on;
    ax = gca; 
    ax.XTick = []; 
    ax.YTick = []; 
%     ax.YLabel.String = 'Millions of years'; % Set the Y-axis label
    set(H.BranchDots, 'Marker', 'none'); % Remove markers from terminal nodes
    set(H.LeafDots, 'Marker', 'none'); % Remove markers from branch nodes    
       
    [uniqueVectors] = main_phyl_tree(tree, thr);    
    yPositionForLine = ax.YLim(1) + (ax.YLim(2) - ax.YLim(1)) * 0.99;  
    for i = 1:length(uniqueVectors)
        line([uniqueVectors{i}(1) uniqueVectors{i}(end)], [yPositionForLine, yPositionForLine], ...
            'Color', possibleColors{i}, 'LineWidth', 4); hold on;
    end
    yline(thr)
        % Uncomment the line below to save on the Drive
    filename = [pwd,'/Figures/Figure 5/phyl_tree_thr_',num2str(thr),'_million_years.pdf']; exportgraphics(gcf,filename,'ContentType','vector');      
end