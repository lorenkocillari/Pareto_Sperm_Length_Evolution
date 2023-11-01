function DiscreteEnrichment(color_class, arch_class, ThreshHoldBH, DataPointsInd,EnMatDis,binSize,discAttrNames,disc_enrich_folder)
    %%
    [Numarchs, numDataPoints] = size(DataPointsInd);
    [~, numFeatures] = size(EnMatDis);
    numOfBins = round(1 / binSize);
    breakPoints = floor(linspace(0.5, numDataPoints + 0.5, numOfBins+1));
    numPointInBin = diff(breakPoints);
    breakPoints = breakPoints(2:end);
    pval    = zeros(Numarchs,numFeatures);
    mean_discrete_feature_binned  = cell(Numarchs,1);
    for arch = 1:Numarchs % On Each Archetype
       tempEnrich =  cumsum(EnMatDis(DataPointsInd(arch,:),:));
       binnedEnrichment = diff([zeros(1,numFeatures) ; tempEnrich(breakPoints,:) ]);
       pval(arch,:) = 1 - hygecdf(binnedEnrichment(1,:)-1,numDataPoints,tempEnrich(end,:),numPointInBin(1)); % calculate p-val by hypergeometric test for each feature % Pval of first bin Vs. all data 
       % pval(arch,:) = hygecdf(binnedEnrichment(1,:)-1,numDataPoints,tempEnrich(end,:),diff(breakPoints),'upper');  % This is a more precise solution, but works only in Matlab 2013
       mean_value_at_bin = bsxfun(@rdivide, binnedEnrichment, transpose(numPointInBin)); %%round(mean(numPointInBin)));
       mean_value_across_bins = tempEnrich(end,:)./numDataPoints;
       mean_discrete_feature_binned{arch} = bsxfun(@rdivide, mean_value_at_bin, mean_value_across_bins);
    end
%     %% FDR
%     FDRs  = mafdr(pval(:),'BHFDR',true);
%     isSignificantAfterFDR   = (FDRs <= ThreshHoldBH); 
    isSignificantAfterFDR   = (pval(:) <= ThreshHoldBH); 
    table =  [repmat((1:Numarchs)',numFeatures,1),... %arch number
              reshape(ones(Numarchs,1)*(1:numFeatures),Numarchs*numFeatures,1),... %feat ID CRUCIAL FOR DISCRETE FEATURES!!
              pval(:), isSignificantAfterFDR]; 
    featuresToDraw = unique( table( (table(:,4)> 0) ,2));
    numOfPlot       = ceil(length(featuresToDraw));
    for fig = 1:numOfPlot
        figure('Position', [300, 500, 750, 250],'Visible','on');axes('Units', 'pixels', 'Position', [60, 70, 150, 150]);hold on; axis square; 
        for ar = 1:Numarchs
           subplot(1,Numarchs,ar);hold on; title(sprintf('%s', discAttrNames{featuresToDraw(fig)}),'FontSize',5);
           ylabel('Feature density'); xlabel(['Bin distance ', newline,'from vertex ',char(arch_class),num2str(ar)],'FontSize',1);
           set(gca,'linewidth',1,'FontSize',10, 'FontWeight','bold');
           bins = linspace(0, 1, numOfBins);
           plot(bins, mean_discrete_feature_binned{ar}(:,featuresToDraw(fig)),'-o','Color',color_class{ar},'MarkerFaceColor',color_class{ar},'LineWidth',1);
           if pval(ar,featuresToDraw(fig)) <= 1E-3
                sig_seg = sigstar({[bins(1), bins(2)+0.01]},1E-3); set(sig_seg,'color',color_class{ar});
            elseif pval(ar,featuresToDraw(fig)) <= 1E-2
                sig_seg = sigstar({[bins(1), bins(2)+0.01]},1E-2); set(sig_seg,'color',color_class{ar});
            elseif pval(ar,featuresToDraw(fig)) <= 0.1
                sig_seg = sigstar({[bins(1), bins(2)+0.01]},5E-2); set(sig_seg,'color',color_class{ar});
           end
        end
        filename = [disc_enrich_folder, (discAttrNames{featuresToDraw(fig)}),'.eps']; set(gcf,'renderer','Painters'); print(filename, '-depsc', '-tiff', '-r300', '-painters')   
    end
end