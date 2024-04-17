function plot_randomized_SimplexSisal(DataPoints,NumArch, numIter, phylogenetic_class,thr)    
%%      Plot the convex hull @ Added 2022_08_16
    Nmembers = NumArch; % number of Archetypes
    for m = 1
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
    % % %         shuffInd = randperm(size(DataPoints,1)); % shuffle the data values of each axis
    % % %         SimplexRand1(:,i) = DataPoints(shuffInd,i);
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
        
        data_conv_plot = SimplexRand1(:,1:Nmembers-1);
        figure('Visible','off'); 
%         set(gcf,'Position',[00, 00, 600, 600]); hold on;    
        scatter(data_conv_plot(:,1),data_conv_plot(:,2), 4,'k','filled'); hold on; convhull_plot = plot(data_conv_plot(k_hull,1), data_conv_plot(k_hull,2)); 
        scatter(Arch3Rand(1,:)', Arch3Rand(2,:)', 20, 'b','filled'); hold on;  plot(Arch3Rand(1,[1,3])', Arch3Rand(2,[1,3])','b'); hold on;
        polytope_plot = plot(Arch3Rand(1,2:3)', Arch3Rand(2,2:3)','b'); hold on;plot(Arch3Rand(1,1:2)', Arch3Rand(2,1:2)','b'); hold on;
        tRatioRand                                                         =minRandArchVol(m)/VolConvRand(m);
        title(['t-ratio:',num2str(tRatioRand)]);
        legend([convhull_plot, polytope_plot],{['Convex hull Rand:', num2str(VolConvRand(m))],['Polytope(Sisal) Rand:', num2str(minRandArchVol(m))]},'Location','best');
        xlabel('Log10(Body mass)'); ylabel('Log10(Sperm length)');
        set(gca,'linewidth',1,'FontSize',10, 'FontWeight','bold'); hold on;
        mkdir([pwd,'/Figures/Figure 6/Rand_swibswap/'])
        filename = [pwd,'/Figures/Figure 6/Rand_swibswap/Pareto_Front_tratio_randomized_thr_',num2str(thr),'.pdf']; exportgraphics(gcf,filename,'ContentType','vector');    
        %%%%%%%%%%%%%%
    end
end