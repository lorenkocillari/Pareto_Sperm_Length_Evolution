function generate_datasets_from_the_main_dataset
%% Datasets are sorted in the following order: 1) Frogs; 2) Birds; 3) Ectotherm; 4) Endotherm; 5) Internal; 6) Mammalia; 7) Reptilia; 8) Tetrapods;
Table_sperm = readtable([pwd,'/DATA/Pareto_sperm length_evolution_data_edited05.10.23.xlsx']); % Read the main dataset from the .xlsx file  
name_class = {'Amphibia','Aves','Ectotherms','Endotherms','Internal','Mammalia','Reptilia','Tetrapods'};
color_class_ALL = {[144, 155, 70]/255, [221, 119, 70]/255, [122, 115, 253]/255,  [246, 70, 29]/255, [152, 0, 54]/255,  [10, 135, 164]/255, [0,1,0], [0, 0, 0]};
arch_class_ALL = {'F','B','EC','EN', 'I','M','R','T'};

% We generated the datasets for each group of species and added the residuals for the features of sperm length and clutch size
table_selected_dataset = struct;
for idx_data   = 1:length(name_class)
    name_dataset = name_class{idx_data};
    switch name_dataset
        case 'Amphibia'
            Table_data   = Table_sperm((ismember(Table_sperm.class,'Amphibia')),:); 
            color_class = color_class_ALL{idx_data}; arch_class = arch_class_ALL{idx_data};
            [table_selected_dataset(idx_data).tableselected] = add_residuals_to_datasets(idx_data,Table_data, name_dataset,color_class,arch_class);
            clear Table_data name_dataset
        case 'Aves'
            Table_data   = Table_sperm((ismember(Table_sperm.class,'Aves')),:); 
            color_class = color_class_ALL{idx_data}; arch_class = arch_class_ALL{idx_data};
            [table_selected_dataset(idx_data).tableselected] = add_residuals_to_datasets(idx_data,Table_data, name_dataset,color_class,arch_class);
            clear Table_data name_dataset
        case 'Ectotherms'
            Table_data   = Table_sperm((ismember(Table_sperm.thermoregulation,'ectotherm')),:); 
            color_class = color_class_ALL{idx_data}; arch_class = arch_class_ALL{idx_data};
            [table_selected_dataset(idx_data).tableselected] = add_residuals_to_datasets(idx_data,Table_data, name_dataset,color_class,arch_class);
            clear Table_data name_dataset
        case 'Endotherms'
            Table_data   = Table_sperm((ismember(Table_sperm.thermoregulation,'endotherm')),:); 
            color_class = color_class_ALL{idx_data}; arch_class = arch_class_ALL{idx_data};
            [table_selected_dataset(idx_data).tableselected] = add_residuals_to_datasets(idx_data,Table_data, name_dataset,color_class,arch_class);
            clear Table_data name_dataset
        case 'Internal'
            Table_data   = Table_sperm((ismember(Table_sperm.fertilization,'internal')),:); 
            color_class = color_class_ALL{idx_data}; arch_class = arch_class_ALL{idx_data};
            [table_selected_dataset(idx_data).tableselected] = add_residuals_to_datasets(idx_data,Table_data, name_dataset,color_class,arch_class);
            clear Table_data name_dataset
        case 'Mammalia'
            Table_data   = Table_sperm((ismember(Table_sperm.class,'Mammalia')),:); 
            color_class = color_class_ALL{idx_data}; arch_class = arch_class_ALL{idx_data};
            [table_selected_dataset(idx_data).tableselected] = add_residuals_to_datasets(idx_data,Table_data, name_dataset,color_class,arch_class);
            clear Table_data name_dataset
        case 'Reptilia'
            Table_data   = Table_sperm((ismember(Table_sperm.class,'Reptilia')),:); 
            color_class = color_class_ALL{idx_data}; arch_class = arch_class_ALL{idx_data};
            [table_selected_dataset(idx_data).tableselected] = add_residuals_to_datasets(idx_data,Table_data, name_dataset,color_class,arch_class);
            clear Table_data name_dataset
        case 'Tetrapods'
            Table_data   = Table_sperm;
            color_class = color_class_ALL{idx_data}; arch_class = arch_class_ALL{idx_data};
            [table_selected_dataset(idx_data).tableselected] = add_residuals_to_datasets(idx_data,Table_data, name_dataset,color_class,arch_class);
            clear Table_data name_dataset
    end
end
save('DATA/All_selected_datasets.mat','table_selected_dataset');
end