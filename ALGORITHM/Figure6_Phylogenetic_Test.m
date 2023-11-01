function Figure6_Phylogenetic_Test(analysis_type)
%% Test of triangularity for the Pareto front
load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset');
load([pwd,'/DATA/phylogenetic_class_individuals.mat'],'phylogenetic_class_individuals_selected_to_plot');

% Load the data points and the position of the archetypes previously found with the function "findArchetypes.m"
idx_data = 8;
nametable = table_selected_dataset(idx_data).tableselected.nametable;
name_class = table_selected_dataset(idx_data).tableselected.name_class; arch_class = table_selected_dataset(idx_data).tableselected.arch_class;
load([pwd,'/Results/current_analysis/paretofront_',char(nametable),'_',char(analysis_type),'.mat'],'PvalueRatio','DataPoints_front','meanClstErrs', ...
    'NArchetypes','El1','El2','Coeff2d','namefolder');
params_Pareto_analysis; % load the parameters for the Pareto analysis

figure; set(gcf,'Position',[00, 00, 592, 440]); hold on;
plot([10^(meanClstErrs(1,1)),10^(meanClstErrs(2,1))],[10^(meanClstErrs(1,2)),10^(meanClstErrs(2,2))],'k-','LineWidth',1); hold on;
plot([10^(meanClstErrs(1,1)),10^(meanClstErrs(3,1))],[10^(meanClstErrs(1,2)),10^(meanClstErrs(3,2))],'k-','LineWidth',1); hold on;
plot([10^(meanClstErrs(2,1)),10^(meanClstErrs(3,1))],[10^(meanClstErrs(2,2)),10^(meanClstErrs(3,2))],'k-','LineWidth',1); hold on;
CLASS  = {'Amphibia','Aves','Mammalia','Reptilia'}; 
color_class = {[221, 119, 70]/255,  [144, 155, 70]/255, [10, 135, 164]/255,[0,0,0]};vertex_color_class = {'r','g','b'};
for arcCol  = 1:NArchetypes
    DATA_class = strcmp(phylogenetic_class_individuals_selected_to_plot,CLASS{arcCol});
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
    text(10^(meanClstErrs(arcCol,1)),10^(meanClstErrs(arcCol,2)),['      ',char(arch_class),num2str(arcCol)],'FontSize',20);
end
DATA_class = strcmp(phylogenetic_class_individuals_selected_to_plot,CLASS{arcCol+1});    
DataPLOT = DataPoints_front(DATA_class,:); 
scatter(10.^(DataPLOT(:,1)),10.^(DataPLOT(:,2)),15,color_class{arcCol+1},'o', 'filled','MarkerEdgeColor','k','MarkerEdgeAlpha',1);hold on;
box on;xlabel(['Body Mass (g)']);ylabel(['Sperm Length (\mum)']); title([name_class, ' (pval = ', num2str(PvalueRatio),')']); hold on;
ax = gca; ax.LineWidth = 1; ax.XColor=[0.25 0.25 0.25];ax.YColor=[0.25 0.25 0.25];
xlim([1E-2 1E+8]); ylim([5 2E+3]); set(gca,'Xscale','Log','Yscale','Log','linewidth',1,'FontSize',15, 'FontWeight','bold'); hold on;

% Draw the background of the plot
r = 204/255; g = 119/255; b = 34/255; selectedColor = [r, g, b]; x = [1E-2, 1E+10, 1E+10, 1E-2]; y = [5, 5,2E+3, 2E+3]; 
patch(x, y, selectedColor, 'EdgeColor', 'none', 'FaceAlpha', 0.065, 'LineWidth', 1);    

% Uncomment the line below to save on the Drive
% filename = [namefolder,name_class,' Pareto_Front_xy_',char(analysis_type),'.pdf']; set(gcf,'renderer','Painters'); exportgraphics(gcf,filename,'ContentType','vector');
end