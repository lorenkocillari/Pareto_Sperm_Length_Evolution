function [leaves] = find_leaf_descendants(nodeIdx, pointers, numLeaves)
%% This code finds all leave nodes that are descendants of each internal node
    % Initialize the stack with the initial node index
    stack = nodeIdx;
    % Initialize an empty array to hold the leaves
    leaves = [];
    % Loop until the stack is empty
    while ~isempty(stack)
        % Pop an element from the stack
        currentNodeIdx = stack(end);
        stack(end) = [];
        if currentNodeIdx <= numLeaves
            % If the node is a leaf, add it to the leaves array
            leaves = [leaves, currentNodeIdx];
        else
            % If the node is not a leaf, add its children to the stack
            childrenIdx = pointers(currentNodeIdx - numLeaves, :);
            stack = [stack, childrenIdx];  % Add children to the stack
        end
    end
    % Since we are collecting leaves from the stack, they may not be in order.
    % If necessary, sort the leaves array
    leaves = sort(leaves);
end