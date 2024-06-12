# Pareto_Sperm_Length_Evolution
This package includes both the input data files and the scripts required to reproduce the analyses.

**SYSTEM REQUIREMENTS**  
We tested the code in Matlab R2021a. We constructed the phylogenetic tree in R v4.3.2.

**INSTALLATION GUIDE**  
To get started, follow these steps:
1.	Download and extract all the files from the Github repository.
2.  Download from: https://figshare.com/articles/dataset/Dataset_Tetrapod_sperm_length_evolution_in_relation_to_body_mass_is_shaped_by_multiple_trade-offs_/26022289 the two datasets: 1) Pareto_sperm_length_evolution.csv and 2) tetrapods_phyl_tree.tre
3.  Create a DATA/ folder in the main directory and move the two files 1) Pareto_sperm_length_evolution.csv and 2) tetrapods_phyl_tree.tre in the DATA/ folder.
4.	Run the function “Main_Code_Pareto_Analyses.m” to reproduce the results of the manuscript.
5.	No installation is required.

**PACKAGE CONTENT**  
The package comprises two main folders:
1. ALGORITHM: This folder contains all the necessary customized code. Pareto optimality analyses were based on the ParTI toolbox (https://www.weizmann.ac.il/mcb/UriAlon/download/ParTI).  
2. Results: This folder contains the output results tha are necessary to reproduce the results of the paper.  
3. DATA: This folder must contain the two datasets (see the instructions above): 1) Pareto_sperm_length_evolution.csv and 2) tetrapods_phyl_tree.tre 
These folders collectively provide all the resources needed to reproduce the results presented in the main text of the associated manuscript.

**INSTRUCTIONS TO RUN THE SCRIPTS AND REPRODUCE THE RESULTS**  
The main script for the analyses is Main_Code_Pareto_Analyses.m contains in the first part the scripts necessary to directly reproduce the results of the manuscript without redoing the entire analyses from scratch. From line 56 on in the Main_Code_Pareto_Analyses.m script the user can redo the analyses from scratch.

**Outline of the Analysis Pipeline**
1.	Select the parameters of the Pareto analyses (for example): params_Pareto.maxRuns = 100, params_Pareto.numIter = 10, params_Pareto.algNum = 1   (this corresponds to the Sisal algorithm)  
4.	Pre-process the Dataset: Run “generate_datasets_from_the_main_dataset.m” to prepare the dataset for analysis.  
6.	Find Significant Pareto Fronts: Run “test_of_triangularity.m” to identify significant Pareto fronts.  
8.	Assess the phylogenetic dependencies: Run the “phylogenetic_tests_based_on_phylogenetic_tree.m” to classify, at a certain time point, the tree tips based on common ancestor nodes. This function also contains the code for testing phylogenetic dependencies for the subsampled Pareto fronts.  

**LICENSE**  
This project is covered under the MIT License.

**CITATION**  
For usage of the package and associated manuscript, please cite according to:




