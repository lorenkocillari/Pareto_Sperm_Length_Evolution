function test_of_triangularity_phylogenetic_order(analysis_type)
%% Test of triangularity for the Pareto front
load('DATA/All_selected_datasets.mat','table_selected_dataset'); 
idx_data = 8; % idx_data = 8 is associated to the Tetrapods dataset        
nametable           = table_selected_dataset(idx_data).tableselected.nametable;
namefolder          = table_selected_dataset(idx_data).tableselected.namefolder;
DataPoints          = table_selected_dataset(idx_data).tableselected.DataPoints;
phylogenetic_order  = table_selected_dataset(idx_data).tableselected.Table_sperm_class.order;
name_class          = table_selected_dataset(idx_data).tableselected.name_class;
%%%%%%%%%%%%%% Choose only those orders that contain at least n_samples 
n_samples = 30;
all_classes = unique(phylogenetic_order);
occurrences_all_orders = groupcounts(phylogenetic_order); 
selected_phylogenetic_order = all_classes(find(occurrences_all_orders > n_samples));
min_number_samples = min(occurrences_all_orders(occurrences_all_orders > n_samples));
%%%%% Extract the same number of species for each of the selcted
%%%%% classes and store both the Datapoints and their phylogenetic class for further analyses
DataPoints_idx_selected = zeros(length(DataPoints), 1);
phylogenetic_order_idx_selected = zeros(length(DataPoints), 1);
for cl = 1:length(selected_phylogenetic_order)
    idx_order_species = find(strcmp(phylogenetic_order,selected_phylogenetic_order(cl)));
    shuffInd_order = randperm(length(idx_order_species));
    shuffInd_order_min = idx_order_species(shuffInd_order(1:min_number_samples));
    DataPoints_idx_selected(shuffInd_order_min) = 1;
    phylogenetic_order_idx_selected(shuffInd_order_min) = 1;
end
DataPoints_selected = DataPoints(logical(DataPoints_idx_selected), :);
phylogenetic_order_individuals_selected = phylogenetic_order(logical(phylogenetic_order_idx_selected));
phylogenetic_order_individuals_selected_to_plot = table_selected_dataset(idx_data).tableselected.Table_sperm_class.class(logical(phylogenetic_order_idx_selected));
%%%%%%%%%%%%%%%%%%%%
save(['DATA/phylogenetic_class_individuals.mat'],'phylogenetic_order_individuals_selected','phylogenetic_order_individuals_selected_to_plot');
findArchetypes(nametable, namefolder, DataPoints_selected, phylogenetic_order_individuals_selected, analysis_type,name_class)
end