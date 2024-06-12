function [totalBranchLengths] = find_branch_lengths(numLeaves, num_internal_nodes, numTotalNodes, distances, pointers)
%% This code finds the total branch lengths of each internal node.
    totalBranchLengths = zeros(num_internal_nodes, 1);    
    % The first element is the root node which has length=0
    vec_set = [numTotalNodes, 0]; 
    while ~isempty(vec_set)
        nodeInfo = vec_set(end-1:end); % The last two elements represent the current node and its total branch length
        vec_set(end-1:end) = []; 
        node = nodeInfo(1);
        currentLength = nodeInfo(2);
        if node > numLeaves  % Check if the current node is an internal node
            internalNodeIndex = node - numLeaves;
            totalBranchLengths(internalNodeIndex) = currentLength;
            childNodes = pointers(internalNodeIndex, :);
            for i = 1:length(childNodes)
                child = childNodes(i);
                newLength = currentLength + distances(child);
                vec_set = [vec_set, child, newLength]; % Add child node and its branch length tp reiterate the loop until we reach the leave nodes
            end
        end
    end
end