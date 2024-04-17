function Figure2_Tetrapods_Pareto_Front(analysis_type)
%% This code plots the Pareto fronts and the feature densities.
load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset'); 
idx_data = 8; % idx_data = 8 is associated to the Tetrapods dataset        

% Load the data points and the position of the archetypes previously found with the function "findArchetypes.m"
nametable = table_selected_dataset(idx_data).tableselected.nametable;
load([pwd,'/Results/current_analysis/paretofront_',char(nametable),'_',char(analysis_type),'.mat'],'PvalueRatio','DataPoints_front','meanClstErrs', ...
    'NArchetypes','El1','El2','Coeff2d','namefolder');
params_Pareto_analysis; % load the parameters for the Pareto analysis

% Plot the Pareto fronts
figure; set(gcf,'Position',[00, 00, 592, 440]); hold on;
arch_class = table_selected_dataset(idx_data).tableselected.arch_class;
CLASS  = {'Amphibia','Aves','Mammalia','Reptilia'}; % The species in the Pareto front will be colored based on which class are associated
color_class = {[221, 119, 70]/255,  [144, 155, 70]/255, [10, 135, 164]/255,[0,0,0]};vertex_color_class = {'r','g','b'};
plot([10^(meanClstErrs(1,1)),10^(meanClstErrs(2,1))],[10^(meanClstErrs(1,2)),10^(meanClstErrs(2,2))],'k-','LineWidth',1); hold on;
plot([10^(meanClstErrs(1,1)),10^(meanClstErrs(3,1))],[10^(meanClstErrs(1,2)),10^(meanClstErrs(3,2))],'k-','LineWidth',1); hold on;
plot([10^(meanClstErrs(2,1)),10^(meanClstErrs(3,1))],[10^(meanClstErrs(2,2)),10^(meanClstErrs(3,2))],'k-','LineWidth',1); hold on;
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
    patch(10.^(coords_ellipse(1,:)), 10.^(coords_ellipse(2,:)),vertex_color_class{arcCol},'EdgeColor',vertex_color_class{arcCol},'FaceAlpha',0.6)
    text(10^(meanClstErrs(arcCol,1)),10^(meanClstErrs(arcCol,2)),['      ',char(arch_class),num2str(arcCol)],'FontSize',12);
end
DATA_class = strcmp(table_selected_dataset(idx_data).tableselected.Table_sperm_class.class,CLASS{arcCol+1});    
DataPLOT = DataPoints_front(DATA_class,:); 
scatter(10.^(DataPLOT(:,1)),10.^(DataPLOT(:,2)),10,color_class{arcCol+1},'o', 'filled','MarkerEdgeColor','k','MarkerEdgeAlpha',1);hold on;
ax = gca;ax.FontSize = 12; ax.FontName = 'Arial'; set(gca,'Xscale','Log','Yscale','Log','linewidth',1,'FontSize',12); hold on;
xlabel(['Body Mass (g)']);ylabel(['Sperm Length (\mum)']); box on;
str = ['pvalue = ', num2str(round(PvalueRatio,3))]; text(0.98, 0.02, str, 'FontSize', 12,'Units', 'normalized', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
xlim([1E-2 1E+10]); ylim([10 1E+3]);

% Draw the background of the plot
r = 204/255; g = 119/255; b = 34/255; selectedColor = [r, g, b]; x = [1E-2, 1E+10, 1E+10, 1E-2]; y = [10, 10, 1E+3, 1E+3];
patch(x, y, selectedColor, 'EdgeColor', 'none', 'FaceAlpha', 0.065, 'LineWidth', 1);   

% Save the plots
name_class = table_selected_dataset(idx_data).tableselected.name_class; 
% Uncomment the line below to save on the Drive
% filename = [namefolder,name_class,' Pareto_Front_xy.pdf']; set(gcf,'renderer','Painters'); exportgraphics(gcf,filename,'ContentType','vector');
end