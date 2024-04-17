function [largestUniqueVectors] = findLargestUniqueVectors(vectors)
%%
    n = length(vectors); % Number of vectors
    isUnique = true(1, n); % Initialize all vectors as unique
    vectorLengths = cellfun(@length, vectors); % Calculate lengths of all vectors
    % Compare each vector with every other vector
    for i = 1:n
        for j = i+1:n
            if ~isempty(intersect(vectors{i}, vectors{j}))
                % If shared elements are found, compare lengths and mark the shorter one
                if vectorLengths(i) > vectorLengths(j)
                    isUnique(j) = false; % Vector j is not unique
                elseif vectorLengths(i) < vectorLengths(j)
                    isUnique(i) = false; % Vector i is not unique
                else
                    % If both vectors are of equal length and share elements, mark both as not unique
                    isUnique(i) = false;
                    isUnique(j) = false;
                end
            end
        end
    end
    % Extract the largest unique vectors
    largestUniqueVectors = vectors(isUnique);
end