%% Infinite RiverSwim transition model
%Canonical reinforcement learning problem, requires planning and
%exploration to perform well. See KL-UCRL Figure 1 for the example.

disp('Running the experiments for the RiverSwim MDP without episodic reset')
disp('We compare performance of UCRL2 to PSRL with exponential episodes (EXPOSE)')

SetRiverSwim
SetPriors
SetExperiment
RunInf
PlotGraphs