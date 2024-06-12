function calculate_ESV_PCHA(DataPoints_front, DataDim,table_selected_dataset,namefolder)
    %% We calculate the explained variance using with PCHA (Morup M, Hansen KL, 2011)
    for indNmembers=1:DataDim+3
        [~,~,~,SSE(indNmembers),varexpl(indNmembers)] = PCHA1(DataPoints_front(:,1:DataDim)',indNmembers);
    end    
    figure; plot(2:DataDim+3, SSE(2:end),'.-','linewidth',2,'MarkerSize',20);
    title('Explained variance','fontsize',14);
    xlabel('Number of Archetypes','fontsize',14);ylabel('Sum of Squares Error','fontsize',14);    

end