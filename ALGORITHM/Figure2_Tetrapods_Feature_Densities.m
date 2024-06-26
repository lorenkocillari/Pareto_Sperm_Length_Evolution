function Figure2_Tetrapods_Feature_Densities
%%
    params_Pareto_analysis;
    thr_pval             = 0.05;
    binSize             = params_Pareto.binSize;
    
    load([pwd,'/DATA/All_selected_datasets.mat'],'table_selected_dataset'); 
    idx_data            = 8; % idx_data = 8 is associated to the Tetrapods dataset 
    arch_class          = table_selected_dataset(idx_data).tableselected.arch_class;
    nametable           = table_selected_dataset(idx_data).tableselected.nametable;
    Table_sperm_class   = table_selected_dataset(idx_data).tableselected.Table_sperm_class;
    DataPoints          = table_selected_dataset(idx_data).tableselected.DataPoints;
    DATI_arc            = DataPoints;
    cont_enrich_folder  = table_selected_dataset(idx_data).tableselected.cont_enrich_folder;
    
    analysis_type = 'all_species';
    load([pwd,'/Results/current_analysis/paretofront_',char(nametable),'_',char(analysis_type),'.mat'],'meanClstErrs');
    arc = meanClstErrs;
    color_class = {[175, 29, 29]/255,  [255, 194, 10]/255, [12, 123, 220]/255,[0,0,0]};
    
    % Feature density plots
    for i = [20,22,23,25,26,27] % These are the features corresponding to 1) Genome size; 2) Residuals of sperm length; 3) Residuals of Testes Mass
        DATI_new = DATI_arc(~any(ismissing(Table_sperm_class(:,i)),2),:);
        if sum(sum(DATI_new)) ~= 0
            contAttrNames  = Table_sperm_class.Properties.VariableNames(i);
            [DataPointsInd, ~] = sortDataByDistance(DATI_new,arc);
            EnMatCont  = table2array(Table_sperm_class(~any(ismissing(Table_sperm_class(:,i)),2),i));
            ContinuousEnrichment(color_class, arch_class, thr_pval, DataPointsInd,EnMatCont, binSize, contAttrNames, cont_enrich_folder)
        end
    end
end