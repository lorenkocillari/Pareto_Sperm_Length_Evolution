function [uniqueVectors] = main_phyl_tree(tree, thr)
%% Code to classify species based on common ancestors    
    % Extract information from the tree, including the node and branch info
    numLeaves = get(tree, 'NumLeaves');
    num_internal_nodes =  get(tree, 'NumBranches');
    numTotalNodes = numLeaves + num_internal_nodes; % Total number of nodes
    pointers = get(tree, 'Pointers'); % Parent to children mapping
    distances = get(tree, 'Distance');
    
    % Function which finds all leave nodes that are descendants of each internal node
    leafDescendants = cell(num_internal_nodes, 1);
    for nodeIdx = numLeaves+1:numTotalNodes % Iterate over internal nodes
        leafDescendants{nodeIdx-numLeaves} = find_leaf_descendants(nodeIdx, pointers, numLeaves);
    end
            
    % A function which computes the total branch lengths for each node
    totalBranchLengths = find_branch_lengths(numLeaves,num_internal_nodes,numTotalNodes,distances,pointers);
    nodes_after_thr = find(totalBranchLengths > thr); % Identify internal nodes that come before the threshold
    
    % Identify the groups of leaves that are descendants of the internal nodes.
    % Pick up the largest groups
    uniqueVectors = findLargestUniqueVectors(leafDescendants(nodes_after_thr));  
    % Find ungrouped nodes
    ungroupedNodes = setdiff(linspace(1,numLeaves,numLeaves),[uniqueVectors{:}]);
    % Add each ungrouped item as a new group
    for i = 1:length(ungroupedNodes)
        uniqueVectors{end+1} = ungroupedNodes(i);
    end
    
% % % % % %     %%
% % % % % %     plot(tree, 'Type','square','Orientation', 'top'); % Plot the tree and capture the plot handle
% % % % % %     % Consider the following random colors to double-check visually that the classification is correct
% % % % % %     n = numLeaves; 
% % % % % %     rand_col_mat = rand(n, 3);
% % % % % %     possibleColors = cell(n, 1);
% % % % % %     for i = 1:n
% % % % % %         possibleColors{i} = rand_col_mat(i, :);
% % % % % %     end    
% % % % % %     % Find all text objects (which should include the leaf names)
% % % % % %     texts = findall(gca, 'Type', 'Text');
% % % % % %     % Color the text of the randomly selected leaf names in green
% % % % % %     for i = 1:length(uniqueVectors)
% % % % % %         set(texts(   1+numLeaves - uniqueVectors{i})', 'Color', possibleColors{i}); % Green color
% % % % % %     end
end

%{
% % Consider the following random colors to double-check visually that the classification is correct
%     n = numLeaves; 
%     rand_col_mat = rand(n, 3);
%     possibleColors = cell(n, 1);
%     for i = 1:n
%         possibleColors{i} = rand_col_mat(i, :);
%     end    
%     % Find all text objects (which should include the leaf names)
%     texts = findall(gca, 'Type', 'Text');
%     % Color the text of the randomly selected leaf names in green
%     for i = 1:length(uniqueVectors)
%         set(texts(   1+numLeaves - uniqueVectors{i})', 'Color', possibleColors{i}); % Green color
%     end
%}