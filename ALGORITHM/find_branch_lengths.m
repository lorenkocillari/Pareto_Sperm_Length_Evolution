function [totalBranchLengths] = find_branch_lengths(numLeaves, num_internal_nodes, numTotalNodes, distances, pointers)
%% This code finds the total branch lengths of each internal node.
    % Initialize output array for storing total branch lengths to each internal node
    totalBranchLengths = zeros(num_internal_nodes, 1);    
    % Initialize a stack for node indices and their current branch length
    stack = [numTotalNodes, 0]; % Start with the root node and length 0
    % Iterate until the stack is empty
    while ~isempty(stack)
        % Pop a node and its current branch length from the stack
        nodeInfo = stack(end-1:end); % The last two elements are the current node and its length
        stack(end-1:end) = []; % Remove these elements from the stack
        node = nodeInfo(1);
        currentLength = nodeInfo(2);
        if node > numLeaves  % Check if the current node is an internal node
            internalNodeIndex = node - numLeaves;
            totalBranchLengths(internalNodeIndex) = currentLength;
            % Get the child nodes for the internal node
            childNodes = pointers(internalNodeIndex, :);
            % Push the child nodes and their new branch lengths onto the stack
            for i = 1:length(childNodes)
                child = childNodes(i);
                newLength = currentLength + distances(child);
                stack = [stack, child, newLength]; % Append child node and its branch length
            end
        end
        % Leaves do not contribute to internal node distances
    end
end