function [table_selected_dataset] = add_residuals_to_datasets(idx_data, Table_data, name_dataset, color_class,arch_class)
%% We added the residuals to each dataset
    if idx_data == 8
        disp('compute_residuals_multiple_groups')
        [Table_data_res] = compute_residuals_multiple_groups(Table_data); 
    else
        disp('compute_residuals')            
        [Table_data_res] = compute_residuals(Table_data);
    end    
    Table_sperm_class  = Table_data_res;
    table_selected_dataset.pos_BM   = find(strcmp(Table_sperm_class.Properties.VariableNames, 'body_mass_log'));
    table_selected_dataset.pos_SL   = find(strcmp(Table_sperm_class.Properties.VariableNames, 'sperm_length_log'));
    x = table2array(Table_sperm_class(:,table_selected_dataset.pos_BM));
    y = table2array(Table_sperm_class(:,table_selected_dataset.pos_SL));
    table_selected_dataset.DataPoints  = [x,y];
    table_selected_dataset.Table_sperm_class = Table_sperm_class(~any(ismissing(Table_sperm_class(:,[table_selected_dataset.pos_BM, table_selected_dataset.pos_SL])),2),:);
    table_selected_dataset.colorscatter      = color_class;
    table_selected_dataset.name_class        = name_dataset;
    table_selected_dataset.nametable         = name_dataset;
    table_selected_dataset.arch_class        = arch_class;
    table_selected_dataset.namefolder        = [pwd,'/Results/current_analysis/Figure1/',char(table_selected_dataset.nametable),'/']; 
    table_selected_dataset.cont_enrich_folder  = [pwd,'/Results/current_analysis/Figure1/',char(table_selected_dataset.nametable),'/Cont_enrich_',char(table_selected_dataset.nametable),'/']; 
    table_selected_dataset.disc_enrich_folder  = [pwd,'/Results/current_analysis/Figure1/',char(table_selected_dataset.nametable),'/Disc_enrich_',char(table_selected_dataset.nametable),'/'];
    table_selected_dataset.outputs_folder      = [pwd,'/Results/current_analysis/outputs/'];
    mkdir(table_selected_dataset.outputs_folder); mkdir(table_selected_dataset.cont_enrich_folder); mkdir(table_selected_dataset.disc_enrich_folder); 
end