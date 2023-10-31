function [pval] = pvalues_DiscreteEnrichment(DataPointsInd,EnMatDis,binSize)
    %%
    [Numarchs, numDataPoints] = size(DataPointsInd);
    [~, numFeatures] = size(EnMatDis);
    numOfBins = round(1 / binSize);
    breakPoints = floor(linspace(0.5, numDataPoints + 0.5, numOfBins+1));
    numPointInBin = diff(breakPoints);
    breakPoints = breakPoints(2:end);
    pval    = zeros(Numarchs,numFeatures);
    for arch = 1:Numarchs % On Each Archetype
       tempEnrich =  cumsum(EnMatDis(DataPointsInd(arch,:),:));
       binnedEnrichment = diff([zeros(1,numFeatures) ; tempEnrich(breakPoints,:) ]);
       pval(arch,:) = 1 - hygecdf(binnedEnrichment(1,:)-1,numDataPoints,tempEnrich(end,:),numPointInBin(1)); % calculate p-val by hypergeometric test for each feature % Pval of first bin Vs. all data 
    end
end