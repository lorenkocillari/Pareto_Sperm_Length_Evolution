function [ordering, distances]=sortDataByDistance(DataPoints,Archetypes)
% 1. Data points is the values of different traits (e.g. expression
% level of genes) - each sample is a row, each trait (gene) is a column 
% 2. Archetypes is a matrix with different archetypes in rows
% % fid = fopen(['distances-',TITULI,'Sperm_sorted.xlsx'],'a')

% % ALL_var = readtable('Data/e.coli/SPERETO/Pareto_ALL_species.xlsx');

%initializing 
distances = zeros(size(Archetypes,1),size(DataPoints,1));
ordering = zeros(size(Archetypes,1),size(DataPoints,1));

for arch = 1:size(Archetypes)
    
    archAtOrigin = bsxfun(@minus,DataPoints(:,[1,2]),Archetypes(arch,:));
    % archAtOrigin moves the archetype to the origin
    dist = sqrt(sum(archAtOrigin.^2,2));
    % dist is the Euclidian distance between the datapoints to
    % archetype(arch);
    [sortedDistances,pos] = sort(dist);
    % the distances woth the corresponding indexes
% %     sortedauc=ALL_var(pos,:);
% %     writetable(sortedauc, ['distances-',TITULI,'Sperm_sorted_Archetype ',num2str(arch),'.xlsx'])

    distances(arch,:) = sortedDistances';
    ordering(arch,:) = pos';
%    dlmwrite('neuropareto_pos.csv', pos,'-append');
end
% %     fclose(fid);