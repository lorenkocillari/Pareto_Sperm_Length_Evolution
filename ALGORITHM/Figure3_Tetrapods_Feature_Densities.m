function Figure3_Tetrapods_Feature_Densities
%%
    auxiliary_spereto;
    thr_FDR             = 0.05;
    binSize             = auxilary.binSize;
    
    load('DATA/All_selected_datasets.mat','table_selected_dataset'); 
    idx_data            = 8; % idx_data = 8 is associated to the Tetrapods dataset 
    arch_class          = table_selected_dataset(idx_data).tableselected.arch_class;
    nametable           = table_selected_dataset(idx_data).tableselected.nametable;
    Table_sperm_class   = table_selected_dataset(idx_data).tableselected.Table_sperm_class;
    DataPoints          = table_selected_dataset(idx_data).tableselected.DataPoints;
    DATI_arc            = DataPoints;
    cont_enrich_folder  = table_selected_dataset(idx_data).tableselected.cont_enrich_folder;
    
    analysis_type = 'all_species';
    load(['Results/current_analysis/paretofront_',char(nametable),'_',char(analysis_type),'.mat'],'meanClstErrs');
    arc = meanClstErrs;
    color_class = {'r','g','b'};
    
    % Feature density plots
    for i   = [22:length(Table_sperm_class.Properties.VariableNames)]
        DATI_new = DATI_arc(~any(ismissing(Table_sperm_class(:,i)),2),:);
        if sum(sum(DATI_new)) ~= 0
            contAttrNames  = Table_sperm_class.Properties.VariableNames(i);
            [DataPointsInd, ~] = sortDataByDistance(DATI_new,arc);
            EnMatCont  = table2array(Table_sperm_class(~any(ismissing(Table_sperm_class(:,i)),2),i));
            ContinuousEnrichment(color_class, arch_class, thr_FDR, DataPointsInd,EnMatCont, binSize, contAttrNames, cont_enrich_folder)
        end
    end
end