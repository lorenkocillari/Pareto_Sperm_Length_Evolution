function Supp_Figure3_Residuals_Body_Mass_Sperm_Length
%%
load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset'); 
idx_data = 8;
clutch_size_log = table_selected_dataset(idx_data).tableselected.Table_sperm_class.clutch_size_log;
clutch_zscore = table_selected_dataset(idx_data).tableselected.Table_sperm_class.clutch_zscore;
clutch_log10_zscore = table_selected_dataset(idx_data).tableselected.Table_sperm_class.clutch_log10_zscore;
testes_mass_log = table_selected_dataset(idx_data).tableselected.Table_sperm_class.testes_mass_log;
body_mass_log = table_selected_dataset(idx_data).tableselected.Table_sperm_class.body_mass_log;


Table_sperm = readtable([pwd,'/DATA/Pareto_sperm length_evolution_data_edited05.10.23.xlsx']); % Read the main dataset from the .xlsx file  
Table_data   = Table_sperm;
all_classes = unique(Table_data.class);
idx_vec_class = cell(1,length(all_classes));
for class = 1:length(all_classes)
    vec_class = strcmp(Table_data.class',all_classes{class});
    idx_vec_class{class} = find(vec_class);
end

% Plot the figure with both plots of sperm length and clutch size
allfig = figure; tiledlayout(1,2,'TileSpacing','compact');
nexttile;
color_class = {[221, 119, 70]/255,  [144, 155, 70]/255, [10, 135, 164]/255,[0,0,0]};
index_datapoints = ((ismissing(clutch_size_log) | ismissing(body_mass_log))==0);
for class = 1:length(all_classes)
    index_datapoints_class = intersect(find(index_datapoints),idx_vec_class{class});
    x = body_mass_log(index_datapoints_class);
    y = clutch_size_log(index_datapoints_class);
    % Linear regression
    p = polyfit(x, y, 1); % p contains coefficients of the linear fit (slope and intercept)
    % Create a range of x values for plotting the fit line
    x_fit = linspace(min(x), max(x), 100);
    % Calculate the corresponding y values for the fit line
    y_fit = polyval(p, x_fit);    
    scatter(x, y,10, color_class{class},'filled'); hold on;
    plot(x_fit, y_fit, 'Color', color_class{class},'LineWidth',2); % Plot the fit line
end
ylabel('clutch size (log)');xlabel('body mass (log)'); axis square;

nexttile;
index_datapoints = ((ismissing(testes_mass_log) | ismissing(body_mass_log))==0);
for class = 1:length(all_classes)
    index_datapoints_class = intersect(find(index_datapoints),idx_vec_class{class});
    x = body_mass_log(index_datapoints_class);
    y = testes_mass_log(index_datapoints_class);
    % Linear regression
    p = polyfit(x, y, 1); % p contains coefficients of the linear fit (slope and intercept)
    % Create a range of x values for plotting the fit line
    x_fit = linspace(min(x), max(x), 100);
    % Calculate the corresponding y values for the fit line
    y_fit = polyval(p, x_fit);    
    scatter(x, y,10, color_class{class},'filled'); hold on;
    plot(x_fit, y_fit, 'Color', color_class{class},'LineWidth',2); % Plot the fit line
end
ylabel('testes mass (log)');xlabel('body mass (log)'); axis square;

% Plot several regression for the clutch size 
allfig = figure; tiledlayout(1,2,'TileSpacing','compact');
nexttile;
index_datapoints = ((ismissing(clutch_zscore) | ismissing(body_mass_log))==0);
for class = 1:length(all_classes)
    index_datapoints_class = intersect(find(index_datapoints),idx_vec_class{class});
    x = body_mass_log(index_datapoints_class);
    y = clutch_zscore(index_datapoints_class);
    % Linear regression
    p = polyfit(x, y, 1); % p contains coefficients of the linear fit (slope and intercept)
    % Create a range of x values for plotting the fit line
    x_fit = linspace(min(x), max(x), 100);
    % Calculate the corresponding y values for the fit line
    y_fit = polyval(p, x_fit);    
    scatter(x, y,10, color_class{class},'filled'); hold on;
    plot(x_fit, y_fit, 'Color', color_class{class},'LineWidth',2); % Plot the fit line    
end
ylabel('clutch zscore');xlabel('body mass (log)'); axis square;

% Plot several regression for the clutch size 
nexttile;
index_datapoints = ((ismissing(clutch_log10_zscore) | ismissing(body_mass_log))==0);
for class = 1:length(all_classes)
    index_datapoints_class = intersect(find(index_datapoints),idx_vec_class{class});
    x = body_mass_log(index_datapoints_class);
    y = clutch_log10_zscore(index_datapoints_class);
    % Linear regression
    p = polyfit(x, y, 1); % p contains coefficients of the linear fit (slope and intercept)
    % Create a range of x values for plotting the fit line
    x_fit = linspace(min(x), max(x), 100);
    % Calculate the corresponding y values for the fit line
    y_fit = polyval(p, x_fit);    
    scatter(x, y,10, color_class{class},'filled'); hold on;
    plot(x_fit, y_fit, 'Color', color_class{class},'LineWidth',2); % Plot the fit line    
end
ylabel('clutch_log10_zscore');xlabel('body mass (log)'); axis square;

% Uncomment the line below to save on the Drive
% mkdir(['Results/suppfigs']); exportgraphics(allfig, ['Results/suppfigs/fecundity_testesmass_bodymass.pdf'])
end