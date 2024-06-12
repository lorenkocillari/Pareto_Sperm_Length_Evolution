function [PvalueRatio] = test_of_triangularity_allpairs(analysis_type)
%% This code computes the test of triangularity by comparing .....
load('Results/current_analysis/table_spereto_update.mat');
idx_data = 9;
nametable       = table_spereto(idx_data).tableselected.nametable;
namefolder      = table_spereto(idx_data).tableselected.namefolder;
name_class = table_spereto(idx_data).tableselected.name_class;
phylogenetic_class = table_spereto(idx_data).tableselected.Table_sperm_class.class;


%% Make the triangularity test for all features (NEED TO UPDATE WITH THE LAST DATASET)
all_features = {'body_mass_log','sperm_length_log','clutch_res_Pearson','genome_res_Pearson',...
    'metabolic_rate_W','MSMR','testes_res_Pearson'};
allpairs = nchoosek(all_features,2);
PvalueRatio = zeros(1,length(allpairs));
for i = 1:length(allpairs)
    i
    DataPoints_nan = [table_spereto(idx_data).tableselected.Table_sperm_class.(allpairs{i,1}) table_spereto(idx_data).tableselected.Table_sperm_class.(allpairs{i,2})];
    index_datapoints = ((ismissing(DataPoints_nan(:,1)) | ismissing(DataPoints_nan(:,2)))==0);
    DataPoints = [DataPoints_nan(index_datapoints,1) DataPoints_nan(index_datapoints,2)]; 
    phylogenetic_class_notNan = phylogenetic_class(index_datapoints);
    [PvalueRatio(i)] = findArchetypes(nametable, namefolder, DataPoints, phylogenetic_class_notNan, analysis_type,name_class);
end
save('Results/current_analysis/PvalueRatio_allpairs.mat','PvalueRatio');
% % % % %%
% % % % for i = [1,8,17]
% % % %     figure
% % % %     i
% % % %     DataPoints_nan = [table_spereto(idx_data).Table_sperm_class.(allpairs{i,1}) table_spereto(idx_data).Table_sperm_class.(allpairs{i,2})];
% % % %     index_datapoints = ((ismissing(DataPoints_nan(:,1)) | ismissing(DataPoints_nan(:,2)))==0);
% % % %     DataPoints = [DataPoints_nan(index_datapoints,1) DataPoints_nan(index_datapoints,2)]; 
% % % %     scatter(DataPoints(:,1),DataPoints(:,2)); hold on;
% % % %     length(DataPoints)
% % % % end
end