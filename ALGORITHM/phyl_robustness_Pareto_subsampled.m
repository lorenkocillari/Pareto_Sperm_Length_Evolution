function [PvalueRatio] = phyl_robustness_Pareto_subsampled(idx_rand_sample_size, idx_data,nametable,namefolder,analysis_type)
%%
    load('Results/current_analysis/phy_tree_classification.mat','uniqueVectors','thr_ALL','leafNames',...
        'idx_in_leafNames','idx_in_all_species_names','table_selected_dataset','DataPoints');
    PvalueRatio = cell(1,length(thr_ALL));
    parfor thr = 1:length(thr_ALL)        
        % Generate category names based on the number of unique groups
        % For example: 'Category1', 'Category2', ...
        categories = arrayfun(@(i) strcat("Category", string(i)), 1:length(uniqueVectors{thr}), 'UniformOutput', false);

        % Assign categories to elements in leafNames based on uniqueVectors
        leafNames_categories = repmat(" ", length(leafNames), 1);
        for i = 1:length(uniqueVectors{thr})
            indices = uniqueVectors{thr}{i};
            leafNames_categories(indices) = categories{i};
        end
        phylogenetic_class = leafNames_categories(idx_in_leafNames);
        name_class = table_selected_dataset(idx_data).tableselected.name_class;
        DataPoints_selected = DataPoints(idx_in_all_species_names, :);

        phylogenetic_class = phylogenetic_class(idx_rand_sample_size);
        DataPoints_selected = DataPoints_selected(idx_rand_sample_size,:);
        [PvalueRatio{thr}] = findArchetypes(nametable, namefolder, DataPoints_selected, phylogenetic_class, analysis_type, name_class, thr_ALL(thr));
    end
end