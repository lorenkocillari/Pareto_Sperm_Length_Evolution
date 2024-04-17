function calculate_ESV_PCHA(DataPoints_front, DataDim,table_selected_dataset,namefolder)
    %% Calculate ESV for dimensions 2-min(10,Dimension of the data) - calculate ESV using the standard PCHA method.
%     fprintf('Calculating explained variance with PCHA (Morup M, Hansen KL, 2011)\n');
    for indNmembers=1:DataDim+3
        [~,~,~,SSE(indNmembers),varexpl(indNmembers)] = PCHA1(DataPoints_front(:,1:DataDim)',indNmembers);
    end    

    %% plot the ESV curve to extract the desired dimension
    figure; plot(2:DataDim+3, SSE(2:end),'.-','linewidth',2,'MarkerSize',20);
    title('Explained variance','fontsize',14);
    xlabel('Number of Archetypes','fontsize',14);ylabel('Sum of Squares Error','fontsize',14);    
    idx_data = 8; % idx_data = 8 is associated to the Tetrapods dataset        
    name_class = table_selected_dataset(idx_data).tableselected.name_class;
    filename = [namefolder,name_class,' Pareto_Front_SSE.eps']; 
%     set(gcf,'renderer','Painters'); print(filename, '-depsc', '-tiff', '-r300', '-painters'); hold off;    
end