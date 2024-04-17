function [Table_data_res] = compute_residuals(Table_data)
%% This code allows to compute the residuals of Testes Mass and Clutch Litter size.
    % Testes residuals
    header_residual_TM = {'testes_res_Pearson'};
    y = log10(Table_data.testes_mass);
    x = log10(Table_data.body_mass);
    mdl = fitlm(x,y);
    Res_testes = mdl.Residuals.Pearson;

    % Litter residuals
    header_residual_clutch = {'clutch_res_Pearson'};
    y = log10(Table_data.clutch_size);
    x = log10(Table_data.body_mass);
    mdl = fitlm(x,y);
    Res_clutch = mdl.Residuals.Pearson;

    
    % Clutch log10, zscore, log10_zscore
    header_clutch_log10 = {'clutch_log10'};
    header_clutch_zscore = {'clutch_zscore'};
    header_clutch_log10_zscore = {'clutch_log10_zscore'};
    y = log10(Table_data.clutch_size);
    x = log10(Table_data.body_mass);
    clutch_log10 = y;
    % Compute z-scores, ignoring NaNs
    clutch_selected_class = Table_data.clutch_size;
    meanValue = nanmean(clutch_selected_class);
    stdValue = nanstd(clutch_selected_class);
    clutch_zscore = (clutch_selected_class - meanValue) ./ stdValue;
    % Compute the z-scores of log10 clutches, ignoring NaNs
    clutch_log10_selected_class = y;
    meanValue = nanmean(clutch_log10_selected_class);
    stdValue = nanstd(clutch_log10_selected_class);
    clutch_log10_zscore  = (clutch_log10_selected_class - meanValue) ./ stdValue;

    
    
    % Append the residuals to the main Table
    table_testes_res = array2table(Res_testes);
    table_testes_res.Properties.VariableNames = header_residual_TM;
    table_litter_res = array2table(Res_clutch);
    table_litter_res.Properties.VariableNames = header_residual_clutch;
    table_clutch_log10 = array2table(clutch_log10);
    table_clutch_log10.Properties.VariableNames = header_clutch_log10;
    table_clutch_zscore = array2table(clutch_zscore);
    table_clutch_zscore.Properties.VariableNames = header_clutch_zscore;
    table_clutch_log10_zscore = array2table(clutch_log10_zscore);
    table_clutch_log10_zscore.Properties.VariableNames = header_clutch_log10_zscore;
    
    % Output    
    Table_data = [Table_data, table_testes_res,table_litter_res, table_clutch_log10,...
        table_clutch_zscore, table_clutch_log10_zscore];
    Table_data_res = Table_data;
end