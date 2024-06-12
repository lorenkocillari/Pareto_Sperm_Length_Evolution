function  [PvalueRatio, centroid_clusters_thr] = phyl_robustness_clusters_Pareto(idx_data,nametable,namefolder,analysis_type)
%%
    load('Results/current_analysis/phy_tree_classification.mat','uniqueVectors','thr_ALL','leafNames',...
        'idx_in_leafNames','idx_in_all_species_names','table_selected_dataset','DataPoints'); 
    name_class = table_selected_dataset(idx_data).tableselected.name_class;
    
    centroid_clusters_thr = cell(1,length(uniqueVectors));
    PvalueRatio = cell(1,length(uniqueVectors));
    parfor thr = 4:length(uniqueVectors)     
        N_groups = length(uniqueVectors{thr});
        categories = arrayfun(@(i) strcat("Category", string(i)), 1:N_groups, 'UniformOutput', false);
        % Assign categories to elements in leafNames based on uniqueVectors
        leafNames_categories = repmat(" ", length(leafNames), 1);
        for i = 1:N_groups
            indices = uniqueVectors{thr}{i};
            leafNames_categories(indices) = categories{i};
        end
        phylogenetic_class = leafNames_categories(idx_in_leafNames);
        DataPoints_selected = DataPoints(idx_in_all_species_names, :);

        unique_classes = unique(phylogenetic_class);    
        centroid_clusters = zeros(N_groups,2);
        phylogenetic_class_centroids = repmat(" ", length(N_groups), 1);
        for i = 1:N_groups
            idx_datapoints_cluster = find(strcmp(phylogenetic_class,unique_classes(i)));
            DataPoints_selected_cluster = DataPoints_selected(idx_datapoints_cluster,:);
            centroid_clusters(i,:) = mean(DataPoints_selected_cluster,1);
            phylogenetic_class_centroids(i) = 'no_class';
        end
        phylogenetic_class_centroids = phylogenetic_class_centroids';
        centroid_clusters_thr{thr} = centroid_clusters;
        [PvalueRatio{thr}] = findArchetypes(nametable, namefolder, centroid_clusters, phylogenetic_class_centroids, analysis_type, name_class, thr_ALL(thr));
    end     
end