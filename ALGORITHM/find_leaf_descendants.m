function [leaves] = find_leaf_descendants(nodeIdx, pointers, numLeaves)
%% This code finds all leave nodes that are descendants of each internal node
    vec_set = nodeIdx;
    leaves = [];
    while ~isempty(vec_set)
        currentNodeIdx = vec_set(end);
        vec_set(end) = [];
        if currentNodeIdx <= numLeaves
            leaves = [leaves, currentNodeIdx]; % If the node is a leaf, add it to leaves vector
        else
            childrenIdx = pointers(currentNodeIdx - numLeaves, :);   % If the node is not a leaf, add its children
            vec_set = [vec_set, childrenIdx];  
        end
    end
    leaves = sort(leaves);
end