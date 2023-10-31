function [El1, El2, Coeff2d] = compute_archetype_error_clouds(ArchsMin, ArchsErrors, NArchetypes,DimFig)
%% create the error clouds per archetype cluster the archtypes to clouds
	ArchsErrorsMat                                                  = cell2mat(ArchsErrors)';
	switch NArchetypes
	    case 1
	        clusteredArchsErrorInd                              = ones(size(ArchsErrorsMat,1),1);
	    case 2
	        clusteredArchsErrorInd                               = (ArchsErrorsMat > 0) + 1;
	    otherwise
	        clusteredArchsErrorInd                               = kmeans(ArchsErrorsMat,NArchetypes,'distance','cosine','replicates',10);        
    end
	meanClstErrs                                                      = zeros(NArchetypes,NArchetypes-1);
	if NArchetypes                                                    < 3
	    meanClstErrs(:,2)                                           = zeros(size(meanClstErrs,1),1);
	    if NArchetypes                                              < 2
	        meanClstErrs(:,1)                                       = zeros(size(meanClstErrs,1),1);
	    end
    end
    archReordering                                                  = zeros(1,NArchetypes);
    for l                                                                       = 1:NArchetypes
        clusteredArchsError                                         = ArchsErrorsMat(clusteredArchsErrorInd==l,:);
	    if NArchetypes                                              < 3
	        clusteredArchsError(l,2)                            = 0;
	        if NArchetypes                                          < 2
	            clusteredArchsError(l,1)                        = 0;
	        end
	    end
   	    meanClstErrs(l,:)                                           = mean(clusteredArchsError);
        repArchCoord                                                = repmat(meanClstErrs(l,:), NArchetypes, 1);
        [~,archReordering(l)]                                       = min(sum((repArchCoord - ArchsMin').^2,2));
    end
    if length(unique(archReordering))                       < NArchetypes
        archReordering                                              = 1:NArchetypes;
        disp('Warning: could not align archetypes. Archetype order is random and will change if you rerun ParTI again.');
    end
    %[~,archReordering]=sort(archReordering);
    %[archReordering(clusteredArchsErrorInd)',clusteredArchsErrorInd]
    clusteredArchsErrorIndAligned                          = archReordering(clusteredArchsErrorInd)';
	El1                                                                     = zeros(1,NArchetypes);
	El2                                                                     = zeros(1,NArchetypes);
	phi                                                                     = zeros(1,NArchetypes);
	Coeff2d                                                             = cell(1,NArchetypes);
	RotEllipsoidArch                                                = cell(1,NArchetypes);
	for l                                                                   = 1:NArchetypes
        clusteredArchsError                                     = ArchsErrorsMat(clusteredArchsErrorIndAligned==l,:);
	    if NArchetypes                                              < 3
	        clusteredArchsError(l,2)                            = 0;
	        if NArchetypes                                          < 2
	            clusteredArchsError(l,1)                        = 0;
	        end
	    end
   	    meanClstErrs(l,:)                                           = mean(clusteredArchsError);
	    % remove the mean of each column - move the errors to zero
	    clstArchErrMeanless                                     = bsxfun(@minus,clusteredArchsError(:,1:DimFig),meanClstErrs(l,1:DimFig));
	    % calculating the axes of the principal components
	    [Coeff2d{l},~,loadings2d]                             = pca(clstArchErrMeanless(:,1:2));
	    El1(l)                                                              = loadings2d(1)^(1/2);
	    El2(l)                                                              = loadings2d(2)^(1/2);
	    if DimFig                                                        >= 3
	        [Coeff,~,loadings]                                      = pca(clstArchErrMeanless);
	        % generate the ellipsoid
	        [Xel,Yel,Zel]                                               = ellipsoid(0,0,0,loadings(1)^(1/2),loadings(2)^(1/2),loadings(3)^(1/2),25);
	        % move the ellipsoid to the archtype location and rotate the ellipsoid
	        % to its principal axes
	        RotEllipsoidArch{l}                                     = arrayfun(@(x,y,z) Coeff*[x,y,z]',Xel,Yel,Zel,'uniformoutput',0);
	        RotEllipMat                                                 = cell2mat(RotEllipsoidArch{l});
	        Xeltot{l}                                                   = meanClstErrs(l,1)+RotEllipMat(1:3:end,:);
	        Yeltot{l}                                                   = meanClstErrs(l,2)+RotEllipMat(2:3:end,:);
	        Zeltot{l}                                                   = meanClstErrs(l,3)+RotEllipMat(3:3:end,:);
	    end
    end
	ArchsErrors                                                         = cell(1,NArchetypes);
	%vol = abs(det(bsxfun(@minus,meanClstErrs(1:end-1,:),meanClstErrs(end,:)))/factorial(NArchetypes-1));
	for l                                                                   = 1:NArchetypes
	    clusteredArchsError                                         = ArchsErrorsMat(clusteredArchsErrorIndAligned==l,:);
	    if NArchetypes                                              < 3
	        clusteredArchsError(l,2)                            = 0;
	        if NArchetypes                                           < 2
	            clusteredArchsError(l,1)                         = 0;
	        end
	    end
	     %[~,~,loadingsArc]=pca(clusteredArchsError);
	     %volarc = exp(mean(log(loadingsArc)));
	     ArchsErrors{l}                                             = cov(clusteredArchsError); %volarc / power(vol,1/(NArchetypes-1));
    end
	disp('finished finding the archetypes error distribution');
end