function [uniqueVectors] = main_phyl_tree(tree, thr)
%% Code to classify species based on common ancestors    
    % Extract information from the tree, including the node and branch info
    numLeaves = get(tree, 'NumLeaves');
    num_internal_nodes =  get(tree, 'NumBranches');
    numTotalNodes = numLeaves + num_internal_nodes; % Total number of nodes
    pointers = get(tree, 'Pointers'); % Extract tge parent to children mapping
    distances = get(tree, 'Distance'); %  Extract the distances between nodes
    
    % Function which finds all leave nodes that are descendants of each internal node
    leafDescendants = cell(num_internal_nodes, 1);
    for nodeIdx = numLeaves+1:numTotalNodes % numLeaves+1:numTotalNodes represent the internal nodes
        leafDescendants{nodeIdx-numLeaves} = find_leaf_descendants(nodeIdx, pointers, numLeaves);
    end
            
    % A function which computes the total branch lengths for each node
    totalBranchLengths = find_branch_lengths(numLeaves,num_internal_nodes,numTotalNodes,distances,pointers);
    nodes_after_thr = find(totalBranchLengths > thr); % Identify internal nodes that come before the threshold
    
    % Identify the groups of leaves that are descendants of the internal nodes.
    % Pick up the largest groups
    uniqueVectors = findLargestUniqueVectors(leafDescendants(nodes_after_thr));  
    % Find ungrouped leaves
    ungroupedNodes = setdiff(linspace(1,numLeaves,numLeaves),[uniqueVectors{:}]);
    % Add each ungrouped leaves as separate groups
    for i = 1:length(ungroupedNodes)
        uniqueVectors{end+1} = ungroupedNodes(i);
    end
    
end