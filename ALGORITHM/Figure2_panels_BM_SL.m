%% PDF of body mass and sperm length in tetrapods
load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset'); 
idx_data = 8; nametable = table_selected_dataset(idx_data).tableselected.nametable;
load([pwd,'/Results/current_analysis/paretofront_',char(nametable),'_',char(analysis_type),'.mat']);
CLASS  = {'Amphibia','Aves','Mammalia','Reptilia'}; 
color_class = {[175, 29, 29]/255,  [255, 194, 10]/255, [12, 123, 220]/255,[0,0,0]};
r = 204/255; g = 119/255; b = 34/255; selectedColor = [r, g, b];
n_bins_PDF = 25;

% PDF of Body Mass
figure; set(gcf,'Position',[00, 00, 575, 150]); hold on;
for arcCol  = 1:NArchetypes+1
    DATA_class = strcmp(table_selected_dataset(idx_data).tableselected.Table_sperm_class.class,CLASS{arcCol});
    DataPLOT  = DataPoints_front(DATA_class,:);
    BM = DataPLOT(:,1);
    hist_BM = histogram(BM, n_bins_PDF, 'Normalization','count', 'FaceColor', 'none', 'EdgeColor', 'none');
    handleOfHistogramFigure = ancestor(hist_BM, 'figure');hold on;
    handleOfHistogramFigure.Visible  = 'off';
    figure(handleOfHistogramFigure);
    hist_BM_x = hist_BM.BinEdges(1:end) + hist_BM.BinWidth/2;
    hist_BM_y = [0, hist_BM.Values(2:end), 0];
    plot(hist_BM_x, hist_BM_y, 'Color',color_class{arcCol},'LineWidth', 2); hold on;
end
x = [-2, 10, 10, -2]; y = [0, 0, 80, 80];
patch(x, y, selectedColor, 'EdgeColor', 'none', 'FaceAlpha', 0.065, 'LineWidth', 1);   
ylabel('Counts'); xlim([-2, 10]); xticklabels({''}); ylim([0 80]);yticks([0 40 80]);
set(gca,'linewidth',1,'FontSize',15, 'FontWeight','bold'); hold on;
% Uncomment the line below to save on the Drive
filename = [namefolder,name_class,' Pareto_Front_xy_panel_pdf_BM.pdf']; set(gcf,'renderer','Painters'); exportgraphics(gcf,filename,'ContentType','vector');

% PDF of Sperm Length
figure; set(gcf,'Position',[00, 00, 150, 450]); hold on;
for arcCol  = 1:NArchetypes+1
    DATA_class = strcmp(table_selected_dataset(idx_data).tableselected.Table_sperm_class.class,CLASS{arcCol});
    DataPLOT  = DataPoints_front(DATA_class,:);
    SL = DataPLOT(:,2);
    hist_SL = histogram(SL, n_bins_PDF, 'Normalization','count', 'FaceColor', 'none', 'EdgeColor', 'none');
    handleOfHistogramFigure = ancestor(hist_SL, 'figure');hold on;
    handleOfHistogramFigure.Visible  = 'off';
    figure(handleOfHistogramFigure);

    hist_SL_y = hist_SL.BinEdges(1:end) + hist_SL.BinWidth/2;  % <-- Notice the change here
    hist_SL_x = [0, hist_SL.Values(2:end), 0];  % <-- And here
    plot(hist_SL_x, hist_SL_y, 'Color',color_class{arcCol},'LineWidth', 2); hold on;
end
y = [1, 3, 3, 1]; x = [0, 0, 80, 80];
patch(x, y, selectedColor, 'EdgeColor', 'none', 'FaceAlpha', 0.065, 'LineWidth', 1);  
xlabel('Counts'); ylim([1, 3]); yticklabels({''}); xlim([0 80]); xticks([0 40 80]);
set(gca,'linewidth',1,'FontSize',15, 'FontWeight','bold'); hold on;
% Uncomment the line below to save on the Drive
filename = [namefolder,name_class,' Pareto_Front_xy_panel_pdf_SL.pdf']; set(gcf,'renderer','Painters'); exportgraphics(gcf,filename,'ContentType','vector');