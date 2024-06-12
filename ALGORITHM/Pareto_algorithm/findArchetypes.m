function [PvalueRatio] = findArchetypes(nametable, namefolder, DataPoints_selected, phylogenetic_class, analysis_type,name_class, thr)
%% Description of the function FindArchetypes
params_Pareto_analysis;
num_arch    = params_Pareto.num_arch;
algNum      = params_Pareto.algNum;
DataDim     = params_Pareto.dim;
numIter     = params_Pareto.numIter;
maxRuns     = params_Pareto.maxRuns;
DataPoints_front = DataPoints_selected;
NArchetypes   = num_arch;

% %% Reproduce Supp. Figure 1 - Explained variance as a function of the number of vertices.
% load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset'); 
% calculate_ESV_PCHA(DataPoints_front, DataDim,table_selected_dataset,namefolder);

%% Find the archetypes of the bounding simplex in d-dimensions
[DataPoints_front, ArchsMin, VolArchReal] = find_convexhull(DataPoints_front, NArchetypes, numIter, algNum);
if NArchetypes < 4
    DimFig     = 2;
else
    DimFig     = 3;
end
if maxRuns > 0
    % Calculate the pvalues
    [PvalueRatio] = pvalues_from_tratios(algNum, DataPoints_front, NArchetypes, DataDim, VolArchReal, maxRuns, numIter, ...
        phylogenetic_class, ArchsMin,namefolder,name_class,thr,analysis_type);    
    
    if strcmp(analysis_type,'all_species') == 1 || strcmp(analysis_type,'phylogenetic_test') == 1
        % Calculate errors in archetypes (by bootstrapping).
	    fprintf('Now calculating errors on the archetypes.\n');
	    switch algNum
	        case 1 %    algNum=1 :> Sisal (default)
	            ArchsErrors = CalculateSimplexArchErrorsSisal(DataPoints_front(:,1:NArchetypes),NArchetypes,maxRuns,numIter);
	        case 2 %    algNum=2 :> MVSA
	            ArchsErrors = CalculateSimplexArchErrorsMVSA(DataPoints_front(:,1:NArchetypes),NArchetypes,maxRuns,numIter);
	        case 5 %    algNum=5 :> PCHA
	            ArchsErrors = CalculateSimplexArchErrorsPCHA(DataPoints_front(:,1:min(NArchetypes-1,DataDim)),NArchetypes,maxRuns,numIter);
        end
	    [El1, El2, Coeff2d] = compute_archetype_error_clouds(ArchsMin,ArchsErrors, NArchetypes,DimFig);     
	    meanClstErrs       = ArchsMin';
    end
end
mkdir([pwd,'/Results/current_analysis/']);
save([pwd,'/Results/current_analysis/paretofront_',char(nametable),'_',char(analysis_type),'.mat']);
end