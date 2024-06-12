function Figures_3_and_4_All_subgroups_Pareto_Fronts(analysis_type)
%% Plot the Pareto fronts for each selected subgroup
for idx_data = 1:7 % 1) Frogs; 2) Birds; 3) Ectotherm; 4) Endotherm; 5) Internal; 6) Mammalia; 7) Reptilia;
    % Load the data points and the position of the archetypes previously found with the function "findArchetypes.m"
    load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset'); 
    nametable = table_selected_dataset(idx_data).tableselected.nametable;
    load([pwd,'/Results/current_analysis/paretofront_',char(nametable),'_',char(analysis_type),'.mat'],'PvalueRatio','DataPoints_front','meanClstErrs', ...
        'NArchetypes','El1','El2','Coeff2d','namefolder');
    params_Pareto_analysis;    
    
    % Plot the Pareto fronts
    figure; set(gcf,'Position',[00, 00, 592, 440]); hold on;
    name_class = table_selected_dataset(idx_data).tableselected.name_class; arch_class = table_selected_dataset(idx_data).tableselected.arch_class;
    CLASS  = {'Amphibia','Aves','Mammalia','Reptilia'}; 
    color_class = {[175, 29, 29]/255,  [255, 194, 10]/255, [12, 123, 220]/255,[0,0,0]};
    vertex_color_class = {[175, 29, 29]/255,  [255, 194, 10]/255, [12, 123, 220]/255,[0,0,0]};
    plot([10^(meanClstErrs(1,1)),10^(meanClstErrs(2,1))],[10^(meanClstErrs(1,2)),10^(meanClstErrs(2,2))],'k-','LineWidth',1); hold on;
    plot([10^(meanClstErrs(1,1)),10^(meanClstErrs(3,1))],[10^(meanClstErrs(1,2)),10^(meanClstErrs(3,2))],'k-','LineWidth',1); hold on;
    plot([10^(meanClstErrs(2,1)),10^(meanClstErrs(3,1))],[10^(meanClstErrs(2,2)),10^(meanClstErrs(3,2))],'k-','LineWidth',1); hold on;
    r = 204/255; g = 119/255; b = 34/255; selectedColor = [r, g, b]; 
    newFontSize = 12;
    for arcCol  = 1:NArchetypes
        DATA_class = strcmp(table_selected_dataset(idx_data).tableselected.Table_sperm_class.class,CLASS{arcCol});
        DataPLOT  = DataPoints_front(DATA_class,:);
        scatter(10.^(DataPLOT(:,1)),10.^(DataPLOT(:,2)),10,color_class{arcCol},'o', 'filled',...
            'MarkerFaceAlpha',1,'MarkerEdgeColor',color_class{arcCol},'MarkerEdgeAlpha',1);hold on;
        if params_Pareto.maxRuns > 0 % Only show errors if we actually asked to compute them
            xc = meanClstErrs(arcCol,1);
            yc = meanClstErrs(arcCol,2);
            a = El1(arcCol);
            b = El2(arcCol);
            Q = Coeff2d{arcCol};
            [coords_ellipse] = ellipse(xc, yc, a, b, Q, vertex_color_class{arcCol});hold on;
        else
           scatter(10^(meanClstErrs(arcCol,1)),10^(meanClstErrs(arcCol,2)),140,vertex_color_class{arcCol},'filled');hold on;
        end
        patch(10.^(coords_ellipse(1,:)), 10.^(coords_ellipse(2,:)),selectedColor,'EdgeColor','none','FaceAlpha',0.25)
        text(10^(meanClstErrs(arcCol,1)),10^(meanClstErrs(arcCol,2)),['      ',char(arch_class),num2str(arcCol)],'FontSize',newFontSize);
    end
    DATA_class = strcmp(table_selected_dataset(idx_data).tableselected.Table_sperm_class.class,CLASS{arcCol+1});     
    DataPLOT = DataPoints_front(DATA_class,:); 
    scatter(10.^(DataPLOT(:,1)),10.^(DataPLOT(:,2)),10,color_class{arcCol+1},'o', 'filled','MarkerEdgeColor','k','MarkerEdgeAlpha',1);hold on;
    ax = gca;ax.FontSize = newFontSize; ax.FontName = 'Arial'; set(gca,'Xscale','Log','Yscale','Log','linewidth',1,'FontSize',newFontSize); box on;
    str = ['pvalue = ', num2str(round(PvalueRatio,3))]; text(0.98, 0.02, str, 'FontSize', newFontSize,'Units', 'normalized', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    switch idx_data 
        case 1
            xlim([1E-2 1E+4]); ylim([5 2E+3]);        
        case 2
            xlim([1E-0 1E+6]); ylim([5 2E+3]);        
        case 5
            xlim([1E-2 1E+10]); ylim([5 2E+3]);     
        case {4,6}
            xlim([1E-0 1E+10]); ylim([5 2E+3]);        
        case 7
            xlim([1E-2 1E+7]); ylim([5 2E+3]);        
    end
    % Uncomment the line below to save on the Drive
    mkdir([namefolder,name_class]);
    filename = [namefolder,name_class,' Pareto_Front_xy.pdf']; set(gcf,'renderer','Painters'); exportgraphics(gcf,filename,'ContentType','vector');
end
end