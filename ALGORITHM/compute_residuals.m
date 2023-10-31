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

    % Append the residuals to the main Table
    table_testes_res = array2table(Res_testes);
    table_testes_res.Properties.VariableNames = header_residual_TM;
    table_litter_res = array2table(Res_clutch);
    table_litter_res.Properties.VariableNames = header_residual_clutch;
    
    % Output    
    Table_data = [Table_data, table_testes_res,table_litter_res];
    Table_data_res = Table_data;
end