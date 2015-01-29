%% Random MDPs with infinite horizon comparison
% We are going to sample random MDPs from a certain prior.

disp('Running the experiments for Random MDPs from the prior without episodic reset')
disp('We compare performance of UCRL2 to PSRL with exponential episodes (EXPOSE)')

SetRandMDP
SetPriors
SetExperiment
RunInf
PlotGraphs