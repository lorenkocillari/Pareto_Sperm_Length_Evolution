function [DataPCA,PvalueRatio]=findpvalue(DataPoints,algNum,dim,numIter,maxRuns)

% Initialize the parameters
if nargin<2
    algNum=1;
    dim=10;
    DimFig=3;
else if nargin<3
        dim=10;
        DimFig=3;
    else if nargin<4
            DimFig=3;
        end
    end
end


%% Do PCA on the data
%fprintf('Starting to perform PCA, for big data on slow computers this may take a while...\n');
if exist('princomp') == 0
    error('This package requires the princomp() function from the Matlab Statistical Toolbox. Please install the Matlab Statistical Toolbox or provide an implementation of the princomp() function.');
end
[coefs1,scores1,variances] = pca(DataPoints);

DataPCA=scores1;

%DataPCA=DataPoints;
NArchetypes=3;
%% Find the archetypes of the bounding simplex in d-dimensions
DataDim=size(DataPCA,2);
DataDim=DataDim;
%We need to figure out how to generalize volumes to non-simplical polytopes
%before we allow running PCHA with NArchetypes>DataDim+1
%if (algNum~=5)
    if (NArchetypes>DataDim+1) %meaning NumArchetypes>dim+1
        fprintf('Warning! Number of Archetypes (%d) exceeds data dimensions (%d) + 1\nWe reset to %d archetypes.\n', ...
            NArchetypes, DataDim, DataDim+1);
        NArchetypes = DataDim+1;
        %return;
    end
    if (NArchetypes>DataDim) %meaning NumArchetypes=dim+1
        DataPCA=[DataPCA, ones(size(DataPCA,1),1)]; %embedding the data in a D+1 space
    end
%end

[ArchsMin,VolArchReal]=findMinSimplex(numIter,DataPCA,algNum,NArchetypes);
%Now we'll re-order archetypes according to their coordinate on the first
%PC. This should help achieve some reproducibility from ParTI run to ParTI
%run.
[~,ArchsOrder] = sort(ArchsMin(1,:));
ArchsMin = ArchsMin(:,ArchsOrder);
%disp('finished finding the archetypes');

if NArchetypes < 4
    DimFig = 2;
else
    DimFig = 3;
end

Xeltot=cell(1,NArchetypes);
Yeltot=cell(1,NArchetypes);
Zeltot=cell(1,NArchetypes);

if maxRuns > 0
	%% Calculate the p-value from t-ratios

	% calculate the volume of the convex hull of the real dataNArchetypes-1
	ConHullVol = ConvexHull(DataPCA(:,1:min(NArchetypes-1,DataDim)));
    ConHullVol;
	%[~ , ConHullVol]=convhulln(DataPCA(:,1:NArchetypes-1));

	% calculate the t-ratio for the real data
	tRatioReal=VolArchReal/ConHullVol;
    tRatioReal;
	% run a function that gets the data and outputs the bootstraped shuffled data t-ratios
	% when high number of points exists, Sisal is recommended. If number of
	% points is relatively low, SDVMM is recommended.
%	fprintf('Now computing t-ratios.\n');
	switch algNum
	    case 1 %    algNum=1 :> Sisal (default)
            tRatioRand = CalculateSimplexTratiosSisal(DataPCA(:,1:NArchetypes),NArchetypes,maxRuns,numIter);
%            tRatioRand = CalculateSimplexTratiosSisal(DataPCA(:,1:min(NArchetypes-1,DataDim)),NArchetypes,maxRuns,numIter);
            tRatioRand;
	    case 2 %    algNum=2 :> MVSA
	        tRatioRand = CalculateSimplexTratiosMVSA(DataPCA(:,1:NArchetypes),NArchetypes,maxRuns,numIter);
	    case 3 %    algNum=3 :> MVES
	        tRatioRand = CalculateSimplexTratiosMVES(DataPCA(:,1:NArchetypes-1),NArchetypes,maxRuns,numIter);
	    case 4 %    algNum=4 :> SDVMM
	        tRatioRand = CalculateSimplexTratiosSDVMM(DataPCA(:,1:NArchetypes-1),NArchetypes,maxRuns,numIter);
	    case 5 %    algNum=5 :> PCHA
	        tRatioRand = CalculateSimplexTratiosPCHA(DataPCA(:,1:min(NArchetypes-1,DataDim)),NArchetypes,maxRuns,numIter);
	end

	if algNum<4 %for first three methods the t-ratio is larger than 1, and you want the minimal one
	    PvalueRatio=sum(tRatioRand<tRatioReal)/maxRuns;
	else %for last two methods (SDVMM, PCHA) t-ratio is smaller than 1, and you want the maximal one
	    PvalueRatio=sum(tRatioRand>tRatioReal)/maxRuns;
	end

	fprintf('The significance of %d archetypes has p-value of: %2.5f \n',NArchetypes,PvalueRatio);

%%coppia=[i,j]
% Remove the embbed ones before we return the PCA projected data
end
DataPCA = DataPCA(:,1:size(scores1,2));

