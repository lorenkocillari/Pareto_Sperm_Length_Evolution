function minRandArchRatio=CalculateSimplexTratiosMVSA(DataPoints,NumArch,maxRuns,numIter)
%%
% Calculating P-values of triangles and tetrahedrons
dim=NumArch-1; % dimension
Nmembers=NumArch; % number of Archetypes
minRandArchVol=zeros(maxRuns,1);
minRandArchRatio=zeros(maxRuns,1);   
VolConvRand=zeros(1,maxRuns); % This will hold the volume of the convex hull
for m=1:maxRuns
    if mod(m,round(maxRuns/10)) == 0
        fprintf('%.0f%% done\n', 100*m/maxRuns);
    end
    SimplexRand1=zeros(size(DataPoints));
    % Shuffle the Sampled data -
    for i=1:size(DataPoints,2) % for each dimension
        shuffInd=randperm(size(DataPoints,1)); % shuffle the data values of each axis
        SimplexRand1(:,i)=DataPoints(shuffInd,i);
    end    
   % [~ , VolConvRand(m)]=convhulln(SimplexRand1(:,1:Nmembers-1));
    VolConvRand(m) = ConvexHull(SimplexRand1(:,1:Nmembers-1));
    VolArchRand=zeros(1,numIter);
    RandDataRatios=zeros(1,numIter);
    for k=1:numIter
        % MVSA algorithm
        [Arch3Rand,~, ~, ~] = mvsa(SimplexRand1',Nmembers,'VERBOSE',0);
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
