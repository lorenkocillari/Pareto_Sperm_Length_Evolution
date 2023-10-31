%% Select the parameters for the Pareto analyses
auxilary = struct; 

% Choose parameters in order to identify the triangular Pareto fronts
auxilary.maxRuns = 100; % how many bootstrapping iterations should be performed to estimate the errors on the archetypes
auxilary.numIter = 5; % the number of iterations for the algorithm to find a minimal bounding simplex
auxilary.num_arch = 3; % # vertices of the polygons
auxilary.dim      = 2;  % # dimensions of the trait space
auxilary.algNum   = 1; % algNum is the parameter for choosing the algorithm to find the simplex:
%    algNum=1 :> Sisal (default)
%    algNum=2 :> MVSA
%    algNum=5 :> PCHA
% Sisal is presented at Bioucas-Dias JM (2009) in First Workshop on Hyperspectral Image and Signal Processing: Evolution in Remote Sensing, 2009. WHISPERS �09, pp 1�4.
% MVSA is presented at Li J, Bioucas-Dias JM (2008) in Geoscience and Remote Sensing Symposium, 2008. IGARSS 2008. IEEE International, pp III � 250�III � 253.
% PCHA is taken from http://www.mortenmorup.dk/index_files/Page327.htm

% Parameters for the feature density analysis
auxilary.binSize  = 0.125; % # bins selected to plot the feature density results
auxilary.x_name   = 'Log(BM)';
auxilary.y_name   = 'Log(SL)';