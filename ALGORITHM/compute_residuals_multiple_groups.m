function [Table_data_res] = compute_residuals_multiple_groups(Table_data)
%%
header_residual_TM = {'testes_res_Pearson'};
header_residual_clutch = {'clutch_res_Pearson'};
header_clutch_log10 = {'clutch_log10'};
header_clutch_zscore = {'clutch_zscore'};
header_clutch_log10_zscore = {'clutch_log10_zscore'};
header_residual_genome = {'genome_res_Pearson'};

all_classes = unique(Table_data.class);
Res_testes_matrix = zeros(length(Table_data.class),1);
Res_clutch_matrix = zeros(length(Table_data.class),1);
clutch_log10 = zeros(length(Table_data.class),1);
clutch_zscore = zeros(length(Table_data.class),1);
clutch_log10_zscore = zeros(length(Table_data.class),1);
Res_genome_matrix = zeros(length(Table_data.class),1);

for class = 1:length(all_classes)
    vec_class = strcmp(Table_data.class',all_classes{class});
    idx_vec_class = find(vec_class);

    % Testes residuals
    y = log10(Table_data.testes_mass);
    x = log10(Table_data.body_mass);
    mdl = fitlm(x(vec_class), y(vec_class));
    Res_testes = mdl.Residuals.Pearson;
    Res_testes_matrix(idx_vec_class',:) = Res_testes;
    
    % Litter residuals
    y = log10(Table_data.clutch_size);
    x = log10(Table_data.body_mass);
    mdl = fitlm(x(vec_class),y(vec_class));
    Res_clutch = mdl.Residuals.Pearson;
    Res_clutch_matrix(idx_vec_class',:) = Res_clutch;

    % Clutch log10, zscore, log10_zscore
    y = log10(Table_data.clutch_size);
    x = log10(Table_data.body_mass);
    clutch_log10(idx_vec_class',:) = y(vec_class);
    % Compute z-scores, ignoring NaNs
    clutch_selected_class = Table_data.clutch_size(vec_class);
    meanValue = nanmean(clutch_selected_class);
    stdValue = nanstd(clutch_selected_class);
    clutch_zscore(idx_vec_class',:) = (clutch_selected_class - meanValue) ./ stdValue;
    % Compute the z-scores of log10 clutches, ignoring NaNs
    clutch_log10_selected_class = y(vec_class);
    meanValue = nanmean(clutch_log10_selected_class);
    stdValue = nanstd(clutch_log10_selected_class);
    clutch_log10_zscore(idx_vec_class',:)  = (clutch_log10_selected_class - meanValue) ./ stdValue;

    % Genome residuals
    y = log10(Table_data.genome_size);
    x = log10(Table_data.body_mass);
    mdl = fitlm(x(vec_class),y(vec_class));
    Res_genome = mdl.Residuals.Pearson;
    Res_genome_matrix(idx_vec_class',:) = Res_genome;
end

% Append the residuals to the main Table
table_testes_res = array2table(Res_testes_matrix);
table_testes_res.Properties.VariableNames = header_residual_TM;
table_litter_res = array2table(Res_clutch_matrix);
table_litter_res.Properties.VariableNames = header_residual_clutch;
table_clutch_log10 = array2table(clutch_log10);
table_clutch_log10.Properties.VariableNames = header_clutch_log10;
table_clutch_zscore = array2table(clutch_zscore);
table_clutch_zscore.Properties.VariableNames = header_clutch_zscore;
table_clutch_log10_zscore = array2table(clutch_log10_zscore);
table_clutch_log10_zscore.Properties.VariableNames = header_clutch_log10_zscore;
table_genome_res = array2table(Res_genome_matrix);
table_genome_res.Properties.VariableNames = header_residual_genome;    

% Output
Table_data = [Table_data, table_testes_res,table_litter_res, table_genome_res, table_clutch_log10,...
    table_clutch_zscore, table_clutch_log10_zscore];
Table_data_res = Table_data;
end
