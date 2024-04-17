function test_of_triangularity(analysis_type)
    %% This code computes the test of triangularity
    load('DATA/All_selected_datasets.mat','table_selected_dataset');
    for idx_data            = 1:8
        nametable           = table_selected_dataset(idx_data).tableselected.nametable;
        namefolder          = table_selected_dataset(idx_data).tableselected.namefolder;
        DataPoints          = table_selected_dataset(idx_data).tableselected.DataPoints;
        name_class          = table_selected_dataset(idx_data).tableselected.name_class;
        phylogenetic_class  = table_selected_dataset(idx_data).tableselected.Table_sperm_class.class;
        findArchetypes(nametable, namefolder, DataPoints, phylogenetic_class, analysis_type,name_class)
    end
end