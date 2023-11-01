function [PvalueRatio] = pvalues_from_tratios(algNum, DataPoints_front, NArchetypes, DataDim, VolArchReal, maxRuns, numIter, phylogenetic_class, ArchsMin,namefolder,name_class)
%%  Calculate the p-value from t-ratios
	% calculate the volume of the convex hull of the real dataNArchetypes-1
	[k, ConHullVol]  = ConvexHull(DataPoints_front(:,1:min(NArchetypes-1,DataDim)));
    
    % Plot the convex hull 
  	tRatioReal  = VolArchReal/ConHullVol;
    data_conv_plot = DataPoints_front(:,1:min(NArchetypes-1,DataDim));
    figure; scatter(data_conv_plot(:,1),data_conv_plot(:,2), 4,'k','filled'); hold on; convhull_plot = plot(data_conv_plot(k,1), data_conv_plot(k,2)); 
    scatter(ArchsMin(1,:)', ArchsMin(2,:)', 20, 'b','filled'); hold on;  plot(ArchsMin(1,[1,3])', ArchsMin(2,[1,3])','b'); hold on;
    polytope_plot = plot(ArchsMin(1,2:3)', ArchsMin(2,2:3)','b'); hold on;plot(ArchsMin(1,1:2)', ArchsMin(2,1:2)','b'); hold on;
    title(['t-ratio:',num2str(tRatioReal)]);
    legend([convhull_plot, polytope_plot],{['Convex hull:', num2str(ConHullVol)],['Polytope(Sisal):', num2str(VolArchReal)]});
    xlabel('Log10(Body mass)'); ylabel('Log10(Sperm length)');
    set(gca,'linewidth',1,'FontSize',10, 'FontWeight','bold'); hold on;
%   Uncomment the line below to save on the Drive
%   filename = [namefolder,name_class,' Pareto_Front_tratio.pdf']; set(gcf,'renderer','Painters'); exportgraphics(gcf,filename,'ContentType','vector');
    
    fileID = fopen('t-ratios(Sisal).txt','a');
	tRatioReal = VolArchReal/ConHullVol;	% calculate the t-ratio for the real data
    fprintf(fileID,'%12s %12s\n', tRatioReal); fclose(fileID);
	fprintf('Now computing t-ratios.\n');
	switch algNum
	    case 1 %    algNum=1 :> Sisal (default)
	        tRatioRand = CalculateSimplexTratiosSisal(DataPoints_front(:,1:NArchetypes),NArchetypes,maxRuns,numIter, phylogenetic_class);
%             tRatioRand
	    case 2 %    algNum=2 :> MVSA
	        tRatioRand = CalculateSimplexTratiosMVSA(DataPoints_front(:,1:NArchetypes),NArchetypes,maxRuns,numIter);
	    case 5 %    algNum=5 :> PCHA
	        tRatioRand = CalculateSimplexTratiosPCHA(DataPoints_front(:,1:min(NArchetypes-1,DataDim)),NArchetypes,maxRuns,numIter);
    end
	if algNum < 4 %for first three methods the t-ratio is larger than 1, and you want the minimal one
	    PvalueRatio = sum(tRatioRand<=tRatioReal)/maxRuns;
	else %for last two methods (SDVMM, PCHA) t-ratio is smaller than 1, and you want the maximal one
	    PvalueRatio = sum(tRatioRand>tRatioReal)/maxRuns;
    end
	fprintf('The significance of %d archetypes has p-value of: %2.5f \n',NArchetypes,PvalueRatio);
end