function minRandArchRatio=CalculateSimplexTratiosSisal(DataPoints,NumArch,maxRuns,numIter, phylogenetic_class)
%% Calculating P-values of triangles and tetrahedrons
    Nmembers = NumArch; % number of Archetypes
    minRandArchVol=zeros(maxRuns,1);
    minRandArchRatio=zeros(maxRuns,1);   
    VolConvRand=zeros(1,maxRuns); % This will hold the volume of the convex hull
    parfor m=1:maxRuns    
        % Correct for the Phylogenetic influence on P-values -- Shuffle the Sampled data 
        all_classes = unique(phylogenetic_class);
        SimplexRand1 = zeros(size(DataPoints));
        for i = 1:size(DataPoints,2) % for each dimension    
            for class_idx = 1:length(all_classes)
                idx_class_species = find(strcmp(phylogenetic_class,all_classes{class_idx}));
                shuffInd_class = randperm(length(idx_class_species));
                idx_class_species_rand = idx_class_species(shuffInd_class);
                SimplexRand1(idx_class_species, i) = DataPoints(idx_class_species_rand,i);        
            end
        end
       % [~ , VolConvRand(m)]=convhulln(SimplexRand1(:,1:Nmembers-1));
        [k_hull, VolConvRand(m)] = ConvexHull(SimplexRand1(:,1:Nmembers-1));

        VolArchRand=zeros(1,numIter);
        RandDataRatios=zeros(1,numIter);
        for k=1:numIter
            % Sisal algorithm
            [Arch3Rand,~, ~, ~] = sisal(SimplexRand1',Nmembers,'VERBOSE',0);
            % Calculating the volume of the randomized simplex
            if ~isnan(Arch3Rand)
                ArchRandRed=bsxfun(@minus,Arch3Rand,Arch3Rand(:,Nmembers));
                VolArchRand(k)=abs(det(ArchRandRed(1:end-1,1:end-1))/factorial(Nmembers-1));
                RandDataRatios(k)=VolArchRand(k)./VolConvRand(m);
            else
                VolArchRand(k)= NaN;
                RandDataRatios(k)=NaN;
            end
        end
        minRandArchVol(m)=min(VolArchRand);
        minRandArchRatio(m)=min(RandDataRatios);    
    end
end
