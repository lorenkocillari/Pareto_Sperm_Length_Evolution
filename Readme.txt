Package Contents: The package comprises two main folders:
1) ALGORITHM: This folder contains all the necessary customized code. Some codes have been adapted from the ParTI toolbox (https://www.weizmann.ac.il/mcb/UriAlon/download/ParTI).
2) Results: This folder contains the output results.
3) DATA: This folder contains the input files, including the main dataset “Pareto_sperm length_evolution_data_edited05.10.23.xslx”

These folders collectively provide all the resources needed to reproduce the results presented in the main text of the associated manuscript.

Main Code: The main script for the analyses is Main_Code_Pareto_Analyses.m. Within this script, you will find a few lines of code that have been commented out. This choice was made to allow users to directly reproduce the results of the manuscript without redoing the entire analyses from scratch. 
If you wish to perform the entire analysis from scratch, please uncomment the following lines in Main_Code_Pareto_Analyses.m: Lines 14, 15, and 34.

Outline of the Analysis Pipeline:

1.Select the parameters of the Pareto analyses as follows:
• params_Pareto.maxRuns = 1000
• params_Pareto.numIter = 50
• params_Pareto.algNum   = 1   (this corresponds to the Sisal algorithm)

2.Pre-process the Dataset:
• Run generate_datasets_from_the_main_dataset to prepare the dataset for analysis.

3.Find Significant Pareto Fronts:
• Execute test_of_triangularity(analysis_type) to identify significant Pareto fronts.




