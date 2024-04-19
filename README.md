# Pareto_Sperm_Length_Evolution
This package includes both the input data files and the scripts required to reproduce the analyses.

**SYSTEM REQUIREMENTS** 

We tested the code in Matlab R2021a. We constructed the phylogenetic tree in R v4.3.2.

**INSTALLATION GUIDE**

To get started, follow these steps:
1.	Download all the files into a single directory.
2.	Unzip all the zip files.
3.	Run the function “Main_Code_Pareto_Analyses.m” to reproduce the results of the manuscript.
4.	No installation is required.

**PACKAGE CONTENT**

The package comprises two main folders:
•	ALGORITHM: This folder contains all the necessary customized code. Pareto optimality analyses were based on the ParTI toolbox (https://www.weizmann.ac.il/mcb/UriAlon/download/ParTI). 
•	Results: This folder contains the output results.
•	DATA: This folder contains the input files, including the main dataset “Pareto_sperm length_evolution_data_edited05.10.23.xslx”
These folders collectively provide all the resources needed to reproduce the results presented in the main text of the associated manuscript.

**INSTRUCTIONS TO RUN THE SCRIPTS AND REPRODUCE THE RESULTS**

The main script for the analyses is Main_Code_Pareto_Analyses.m. Within this script, you will find a few lines of code that have been commented out. This choice was made to allow users to directly reproduce the results of the manuscript without redoing the entire analyses from scratch. 
If you wish to perform the entire analysis from scratch, please uncomment the following lines in Main_Code_Pareto_Analyses.m: Lines 14, 15, 36, 37, 44, 45, and 57.
Outline of the Analysis Pipeline:
1.	Select the parameters of the Pareto analyses (for example):
•	params_Pareto.maxRuns = 1000
•	params_Pareto.numIter = 50
•	params_Pareto.algNum   = 1   (this corresponds to the Sisal algorithm)
2.	Pre-process the Dataset:
•	Run “generate_datasets_from_the_main_dataset.m” to prepare the dataset for analysis.
3.	Find Significant Pareto Fronts:
•	Execute “test_of_triangularity.m” to identify significant Pareto fronts.
4.	Assess the phylogenetic dependencies:
•	Run the “phylogenetic_tests_based_on_phylogenetic_tree.m” to classify, at a certain time point, the tree tips based on common ancestor nodes. This function also contains the code for testing phylogenetic dependencies for the subsampled Pareto fronts.

**LICENSE**
This project is covered under the MIT License.

**CITATION**
For usage of the package and associated manuscript, please cite according to:




