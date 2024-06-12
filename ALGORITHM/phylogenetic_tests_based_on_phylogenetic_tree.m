function phylogenetic_tests_based_on_phylogenetic_tree(analysis_type)
%% Classify species into groups based on the presence of common ancestors at the specified threshold epoch
    % Load the data needed for the analyses
    load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset'); 
    idx_data = 8;
    nametable       = table_selected_dataset(idx_data).tableselected.nametable;
    namefolder      = table_selected_dataset(idx_data).tableselected.namefolder;
    DataPoints      = table_selected_dataset(idx_data).tableselected.DataPoints;
    all_species_names = table_selected_dataset(idx_data).tableselected.Table_sperm_class.species;
    all_species_names_underscores = cellfun(@(x) strrep(x, ' ', '_'), all_species_names, 'UniformOutput', false);    
    
    % Read the phylogenetic tree from the .tre file produced before
    tree = phytreeread('DATA/tetrapods_phyl_tree.tre'); 
    leafNames = get(tree, 'LeafNames');
    thr_ALL = linspace(20,360,64); % This is the threshold for classification 
    uniqueVectors = cell(1,length(thr_ALL));
    parfor thr = 1:length(thr_ALL)
        % Classify species into groups based on the presence of common ancestors at the specified threshold epoch.
        uniqueVectors{thr} = main_phyl_tree(tree, thr_ALL(thr)); % thr is in million of years.
    end
    
    % Find common species considered in our main sperm dataset and the phylogenetic tree
    [common_species, idx_in_leafNames, idx_in_all_species_names] = intersect(leafNames, all_species_names_underscores,'rows');
    [unique_to_leafNames, ~] = setdiff(leafNames, all_species_names_underscores, 'rows');
    [unique_to_all_species_names_underscores, ~] = setdiff(all_species_names_underscores, leafNames, 'rows');

    % Write to file and save files
    writecell(unique_to_leafNames, 'Results/current_analysis/unique_to_phyl_tree.csv');
    writecell(unique_to_all_species_names_underscores, 'Results/current_analysis/unique_to_pareto_dataset.csv');
    writecell(common_species, 'Results/current_analysis/common_species.csv');
    save('Results/current_analysis/phy_tree_classification.mat','uniqueVectors','thr_ALL','leafNames',...
        'idx_in_leafNames','idx_in_all_species_names','table_selected_dataset','DataPoints','tree');
    
    %% Test of phylogenetic dependence for the entire Pareto front using the SibSwap test on different epochs.
    nIter = 100; % set to nIter = 100;
    PvalueRatio = cell(1,nIter);
    for iter = 1:nIter
        iter
        [PvalueRatio{iter}] = phyl_robustness_Pareto(idx_data,nametable,namefolder,analysis_type);
    end
    save('Results/current_analysis/PvalueRatio_ALL.mat','PvalueRatio')
    
    %% Test of phylogenetic dependence for the taxa at different epochs.
    nIter = 100; % set to nIter = 100;
    PvalueRatio_clusters = cell(1,nIter);
    centroid_clusters = cell(1,nIter);    
    for iter = 1:nIter
        iter
        [PvalueRatio_clusters{iter}, centroid_clusters{iter}] = phyl_robustness_clusters_Pareto(idx_data,nametable,namefolder,analysis_type);
    end
    save('Results/current_analysis/PvalueRatio_clusters_ALL.mat','PvalueRatio_clusters','centroid_clusters')
    
    %% Test of phylogenetic dependence for the subsampled Pareto fronts
    % With nIter = 30, choose the following parameters to run the code in ~10 hours
%     params_Pareto.maxRuns = 100; % how many bootstrapping iterations should be performed to estimate the errors on the archetypes
%     params_Pareto.numIter = 10; % the number of iterations for the algorithm to find a minimal bounding simplex
    load('Results/current_analysis/phy_tree_classification.mat','idx_in_all_species_names','DataPoints');
    perct_ALL = [5,10,15,20,30,40,50,60,70,80,90];    
    sample_size_ALL = round(length(idx_in_all_species_names)*(perct_ALL/100));
    nIter = 30; % set to nIter = 30;
    PvalueRatio_sample_size_iter = cell(1,nIter);
    for iter = 1:nIter
        iter
        PvalueRatio_sample_size = cell(1,length(sample_size_ALL)-1);
        parfor sample_size = 1:length(sample_size_ALL)-1
            idx_rand_sample_size = randperm(length(idx_in_all_species_names), sample_size_ALL(sample_size));
            [PvalueRatio_sample_size{sample_size}] = phyl_robustness_Pareto_subsampled(idx_rand_sample_size, idx_data,nametable,namefolder,analysis_type);
        end
        PvalueRatio_sample_size_iter{iter} = PvalueRatio_sample_size;
    end
    save('Results/current_analysis/PvalueRatio_sample_size_iter_ALL.mat','PvalueRatio_sample_size_iter','perct_ALL')
end