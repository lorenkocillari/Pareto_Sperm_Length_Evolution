function test_of_triangularity_phylogenetic_class(analysis_type)
%% Test of triangularity for the Pareto front
load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset'); 
idx_data = 8;
nametable       = table_selected_dataset(idx_data).tableselected.nametable;
namefolder      = table_selected_dataset(idx_data).tableselected.namefolder;
DataPoints      = table_selected_dataset(idx_data).tableselected.DataPoints;
phylogenetic_class = table_selected_dataset(idx_data).tableselected.Table_sperm_class.class;
name_class = table_selected_dataset(idx_data).tableselected.name_class;
%%%%%%%%%%%%%% Choose only those classes that contain at least n_samples 
n_samples = 100;
all_classes = unique(phylogenetic_class);
occurrences_all_classes = groupcounts(phylogenetic_class); 
selected_phylogenetic_class = all_classes(find(occurrences_all_classes > n_samples));
min_number_samples = min(occurrences_all_classes(occurrences_all_classes > n_samples));
%%%%% Extract the same number of species for each of the selcted
%%%%% classes and store both the Datapoints and their phylogenetic class for further analyses
DataPoints_idx_selected = zeros(length(DataPoints), 1);
phylogenetic_class_idx_selected = zeros(length(DataPoints), 1);
for cl = 1:length(selected_phylogenetic_class)
    idx_class_species = find(strcmp(phylogenetic_class,selected_phylogenetic_class(cl)));
    shuffInd_class = randperm(length(idx_class_species));
    shuffInd_class_min = idx_class_species(shuffInd_class(1:min_number_samples));
    DataPoints_idx_selected(shuffInd_class_min) = 1;
    phylogenetic_class_idx_selected(shuffInd_class_min) = 1;
end
DataPoints_selected = DataPoints(logical(DataPoints_idx_selected), :);
phylogenetic_class_individuals_selected = phylogenetic_class(logical(phylogenetic_class_idx_selected));
phylogenetic_class_individuals_selected_to_plot = table_selected_dataset(idx_data).tableselected.Table_sperm_class.class(logical(phylogenetic_class_idx_selected));
%%%%%%%%%%%%%%%%%%%%
save([pwd,'/DATA/phylogenetic_class_individuals.mat'],'phylogenetic_class_individuals_selected','phylogenetic_class_individuals_selected_to_plot');
findArchetypes(nametable, namefolder, DataPoints_selected, phylogenetic_class_individuals_selected, analysis_type, name_class)