function ContinuousEnrichment(color_class, arch_class, thr_pval, DataPointsInd,EnMatCont, binSize, contAttrNames, cont_enrich_folder)
%%
    [Numarchs, numDataPoints] = size(DataPointsInd);
    [~, numFeatures] = size(EnMatCont);
    numOfBins  = round(1 / binSize);
    breakPoints = floor(linspace(0.5, numDataPoints + 0.5, numOfBins+1));
    numPointInBin = diff(breakPoints);
    N  = numPointInBin(1);
    breakPoints  = breakPoints(2:end);
    pval  = zeros(Numarchs,numFeatures);
    SEM = cell(1, Numarchs);
    continuous_feature_binned = cell(1, Numarchs);
    for arch = 1:Numarchs 
       tempEnrich =  EnMatCont(DataPointsInd(arch,:),:); 
       Binned = mat2cell(tempEnrich,numPointInBin, numFeatures); 
       continuous_feature_binned{arch} = cell2mat(cellfun(@(x)mean(x),Binned,'UniformOutput',0));
       SD  = cellfun(@(x)std(x),Binned,'UniformOutput',0);
       SEM{arch} = bsxfun(@rdivide, cell2mat(SD), sqrt(N));
       tempEnrich =  EnMatCont(DataPointsInd(arch,:),:);
       bin =  tempEnrich(1:(numPointInBin(1)),:);
       rest = tempEnrich((numPointInBin(1)+1):numDataPoints,:);
       [~, pval(arch,:)] = ttest2(bin, rest,'tail','both');  % Two sample t-test between the first bin and the rest of data    
    end
    if sum(pval(:) <= thr_pval) > 0
        bins = linspace(0, 1, numOfBins);
        figure('Position', [300, 10, 750, 250],'Visible','on'); axes('Units', 'pixels', 'Position', [60, 70, 150, 150]);hold on; axis square;
        for ar  = 1:Numarchs
            subplot(1,Numarchs,ar);hold on; ylabel('Feature density'); xlabel(['Bin distance ',newline,'from vertex ',char(arch_class),num2str(ar)],'FontSize',1);
            title_feature  =   sprintf('%s',contAttrNames{1}); expression = '_'; replace = ' '; new_title_feature = regexprep(title_feature,expression,replace);
            title(new_title_feature,'FontSize',5); set(gca,'linewidth',1,'FontSize',10, 'FontWeight','bold'); 
            shadedErrorBar(bins, continuous_feature_binned{ar},SEM{ar},{'-o','color', color_class{ar},'markerfacecolor',color_class{ar}},1);
            plot(bins, continuous_feature_binned{ar},'Color',color_class{ar},'LineWidth',1);
            if pval(ar) <= 1E-3             
                sig_seg = sigstar({[bins(1), bins(2)+0.01]},1E-3); set(sig_seg,'color',color_class{ar});
            elseif pval(ar) <= 1E-2
                sig_seg = sigstar({[bins(1), bins(2)+0.01]},1E-2); set(sig_seg,'color',color_class{ar});
            elseif pval(ar) <= 0.05
                sig_seg = sigstar({[bins(1), bins(2)+0.01]},5E-2); set(sig_seg,'color',color_class{ar}); 
            end             
        end
        % Uncomment the line below to save on the Drive
        mkdir(cont_enrich_folder);
        filename = [cont_enrich_folder, num2str(contAttrNames{1}),'.pdf']; set(gcf,'renderer','Painters'); exportgraphics(gcf,filename,'ContentType','vector');
    end
end