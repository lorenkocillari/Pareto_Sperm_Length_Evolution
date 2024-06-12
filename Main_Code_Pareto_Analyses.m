%%% This is the main code to reproduce the results of the manuscript: 
% Koçillari, L. et al. "Sperm length evolution in relation to body mass is shaped by multiple trade-offs in tetrapods." bioRxiv (2023): 2023-09. 
 
% Author of this code: Loren Koçillari (lorenkocillari@gmail.com) 
% Last update: 12  June  2024

%%%%%%%%%
% Download first the two datasets: 1) Pareto_sperm_length_evolution.csv and
% 2) tetrapods_phyl_tree.tre from: 
% https://figshare.com/articles/dataset/Dataset_Tetrapod_sperm_length_evolution_in_relation_to_body_mass_is_shaped_by_multiple_trade-offs_/26022289

% Put the two files within the DATA/ folder.
%%%%%%%%%

%% To reproduce the results of the paper follow the following pipeline

% Select the parameters of the Pareto analyses and generate the datasets to analyze.
clear all; close all; addpath(genpath([pwd,'/ALGORITHM/'])); % Add the path of the folder containing the rest of the code

% We define here the parameters of the Pareto analyses.
params_Pareto_analysis; 

% We load the main dataset that can be downloaded from:
% We then generate the datasets to analyze for each group of species. We also compute the residuals for the features of Testes mass and Clutch size
generate_datasets_from_the_main_dataset; 

% PLOT THE RESULTS OF THE PAPER
% Reproduce Figure 2A - Plot the Pareto front for all species (tetrapods)
analysis_type = 'all_species';
Figure2_Tetrapods_Pareto_Front(analysis_type);
Figure2_panels_BM_SL;

% Reproduce Figure 2B - Plot the feature densities for all species (tetrapods)
Figure2_Tetrapods_Feature_Densities; 

% Reproduce Figures 3 and 4 
%  Plot the Pareto fronts for subgroups of species
analysis_type = 'all_species';
Figures_3_and_4_All_subgroups_Pareto_Fronts(analysis_type);
%  Plot the feature densities for subgroups of species
Figures_3_and_4_All_Subgroups_Feature_Densities;

% Reproduce Figure 5   
Figure5_Phylogenetic_robustness;

% Reproduce Figure 6  
analysis_type = 'phylogenetic_test';
Figure6_sampling_bias(analysis_type);

% Reproduce Supplementary Figure 3 - Plot fecundity vs BM and teste mass vs BM
Supp_Figure3_Residuals_Body_Mass_Sperm_Length;  

% Reproduce Supplementary Figure 5 - Plot results on taxa
Supp_Figure5_taxa_analysis;

%% In order to do all the data analyses of the paper follow the following steps and then go back above to plot the results
% Pareto analyses on the whole dataset and in each subgroup of species
% % To identify significant Pareto fronts we computed the p-values based on the test of triangularity (t-ratio test, see Hart et al. 2015).
% % This code generates also Supp.Figure 1 and Supp.Figure 2.
analysis_type = 'all_species';
test_of_triangularity(analysis_type);                    

% We assessed the phylogenetic impact on the significance of the triangular Pareto front
analysis_type = 'phylogenetic_test_based_on_phylogenetic_tree';
phylogenetic_tests_based_on_phylogenetic_tree(analysis_type);

% We tested for the significance of triangularity in the triangle after retaining the same number of species for each of the four classes (mammals, aves, amphibians, reptiles) 
analysis_type = 'phylogenetic_test';
test_of_triangularity_phylogenetic_class(analysis_type);