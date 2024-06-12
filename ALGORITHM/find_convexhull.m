function [DataPoints_front, ArchsMin, VolArchReal] = find_convexhull(DataPoints_front, NArchetypes, numIter, algNum)
    %%
    DataDim  = size(DataPoints_front,2);
    if algNum ~=5
        if NArchetypes > DataDim+1 %meaning NumArchetypes>dim+1
            fprintf('Warning! Number of Archetypes (%d) exceeds data dimensions (%d) + 1\nWe reset to %d archetypes.\n', NArchetypes, DataDim, DataDim+1);
            NArchetypes = DataDim+1;
            return;
        end
        if (NArchetypes > DataDim) %meaning NumArchetypes=dim+1
            DataPoints_front = [DataPoints_front, ones(size(DataPoints_front,1),1)]; %embedding the data in a D+1 space
        end
    end
    [ArchsMin,VolArchReal] = findMinSimplex(numIter,DataPoints_front,algNum,NArchetypes);
    [~,ArchsOrder] = sort(ArchsMin(1,:));
    ArchsMin = ArchsMin(:,ArchsOrder);
end