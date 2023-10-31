function Supp_Figure3_Residuals_Body_Mass_Sperm_Length
%%
load('DATA/All_selected_datasets.mat','table_selected_dataset'); 
idx_data = 8;
clutch_size_log = table_selected_dataset(idx_data).tableselected.Table_sperm_class.clutch_size_log;
testes_mass_log = table_selected_dataset(idx_data).tableselected.Table_sperm_class.testes_mass_log;
body_mass_log = table_selected_dataset(idx_data).tableselected.Table_sperm_class.body_mass_log;

% Plot the figure with both plots of sperm length and clutch size
allfig = figure; tiledlayout(1,2,'TileSpacing','compact');
nexttile;
index_datapoints = ((ismissing(clutch_size_log) | ismissing(body_mass_log))==0);
scatter(clutch_size_log(index_datapoints), body_mass_log(index_datapoints),5,'k','filled');
xlabel('clutch size (log)');ylabel('body mass (log)'); axis square;

nexttile;
index_datapoints = ((ismissing(testes_mass_log) | ismissing(body_mass_log))==0);
scatter(testes_mass_log(index_datapoints), body_mass_log(index_datapoints),5,'k','filled');
xlabel('testes mass (log)');ylabel('body mass (log)'); axis square;

% Uncomment the line below to save on the Drive
% mkdir(['Results/suppfigs']); exportgraphics(allfig, ['Results/suppfigs/fecundity_testesmass_bodymass.pdf'])
end