## Accompanying MATLAB code
### Ian Osband - December 2013 - [Paper link](http://arxiv.org/abs/1306.0940)


This is the MATLAB code used to generate the simulations in our paper.
Namely the graphs and table in the simulation section.

The code should run for anyone with MATLAB (or Octave) and does not make use of any packages or files which are not included in the distribution. I have made an effort to add many explanatory notes to the code and hopefully this should make sense.

Please email `iosband@stanford.edu` with any questions or errors.

------------------------------------------------------------------------------------------

The code is divided into 4 folders:

## 1. Set Parameters
Here you can go and edit exactly which experiments are run.

- SetExperiment - Change episode length, number of MDPs, length of time etc.
- SetPriors - Change the algorithm's prior structure.
- SetRandMDP - Choose what size of MDP to deal with in the random case.
- SetRiverSwim - Choose fixed MDP (not drawn from prior) to test the algorithm on.

## 2. Learning Algorithms
Here are the reinforcement learning algorithms which will be employed on the MDP

- PSRL - Posterior sampling for fixed episodes tau, as described in the paper.
- EXPOSE - EXponential POsterior Sampling Episodes, PSRL with episode doubling (UCRL2 style)
- UCRL2Finite - UCRL2 adapted to handle the case of finite episodes tau.
- UCRL2 - Near optimal optimistic algorithm of Jaksch et al. for infinite horizon problems.

## 3. Experiments
Here are the experiments we will test the MDPs on.

- tauRandMDP - Random episodic MDPs drawn from the prior, size specified in SetRandMDP
- infRandMDP - The same but on an infinite horizon (i.e. no episodic reset)
- tauRiverSwim - Fixed episodic MDPs which are specified in SetRiverSwim
- infRiverSwim - The same but on an infinite horizon (i.e. no episodic reset)
- RunInf/RunTau should be altered to make use of the MATLAB PCT if you have that available.

This is very simple (basically for <--> parfor in that loop) for multi-core speedups.

## 4. Computations
Here are the back-end functions used within the learning algorithms.

- Updating/sampling from a prior (for PSRL)
- Computing optimistic estimates for MDPs (for UCRL2)
- Planning/optimising an MDP (via value iteration)

The user can simply run "RunAllExperiments" and should be able to reproduce the results in the paper. Depending on the computer, whether you have the MATLAB PCT and size of the parameters chosen this may take some time. I would recommend running each experiment seperately.

------------------------------------------------------------------------------------------
