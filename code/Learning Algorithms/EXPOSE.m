function [rewards states actions values pols flags vTot] = ...
    EXPOSE(T, pTrue, rTrue, s1, mu0, nMu0, tau0, nTau0, alpha0, epsilon, maxIter)
%EXPOSE implements the EXPOSE algorithm up to time T and outputs observed
%rewards through time. The algorithm proceeds in episodes.
%------------------------------------------------------------------
% T      - 1x1 How many timesteps we will run the simulation
% pTrue  - SxSxA Probability transition matrices under actions
% rTrue  - SxA Working on a simple deterministic rewards
% s1     - 1x1 Initial state
% mu0    - SxA Prior estimate of mean return
% nMu0   - SxA Prior number of prior observations which we based mu0 on
% tau0   - SxA Prior stimate of tau = sigma^-2
% nTau0  - SxA Prior umber of prior observations which we based tau0 on
% alpha  - SxSxA Prior dirichlet distribution specification
% epsilon- 1x1 Accuracy in value iteration
% maxIter- 1x1 Maximum iterations in value iteration
%------------------------------------------------------------------
% rewards- Tx1 Record of rewards received in each timestep
% states - Tx1 Record of states
% actions- Tx1 Record of actions
% values - EXS Record of estimated Value functions per episode
% pols   - ExS Record of policies employes per episode
% flags  - Ex1 Record of convergence flags per episode
% vTot   - SxSxA total number of visits to each combo
%------------------------------------------------------------------

% Set up state and action counters
[S A] = size(rTrue);
vEps = zeros(S,A);
vTot = zeros(S,A);
vLim = max(ones(S,A),vTot);
pEmp = zeros(S,S,A);
rMean = zeros(S,A);
rVar  = zeros(S,A);

% Bayesian holders
pSample = zeros(S,S,A);
muSample = zeros(S,A);
varSample = zeros(S,A);

% Output variables
rewards = zeros(T,1);
states = zeros(T,1);
actions = zeros(T,1);
values = zeros(1,S);
pols = zeros(1,S);
flags = zeros(1,1);

% Initialise system
t = 1;
state = s1;
episode = 1;


while(t < T),
    % Update the counters
    vEps = zeros(S,A);
    vLim = max(ones(S,A),vTot);
    
    % Work out the EXPOSE Policy
    %disp('We have started a new episode - Calculating EXPOSE policy...')
    
    % Collate the necessary Bayes information
    alpha = alpha0 + pEmp; % Transitions
    pSample = sampleDirichletMat(alpha);
    [muSample, varSample] = sampleNormalGammaMat(mu0,nMu0,tau0,nTau0,vTot,rMean,rVar);
    
    % Compute the optimum policy for this sampled MDP
    [value policy flag rho] = ...
        valueIteration( pSample, muSample, epsilon, maxIter);
    
    values = [values; value'];
    flags = [flags;flag];
    pols = [pols; policy'];
    
    
    while(all(vEps < vLim)),
        % Follow the policy inside the episodes
        [action, newState, reward ] = ...
            singleStep(state, policy, pTrue, rTrue);
        actions(t) = action;
        rewards(t) = reward;
        states(t) = state;
        
        vEps(state,action) = vEps(state,action) + 1;
        vTot(state,action) = vTot(state,action) + 1;
        pEmp(newState,state,action) = pEmp(newState,state,action)+1;
        nCount = vTot(state,action);
        
        % Update the variance and mean of observed rewards
        rVar(state,action) = ((nCount-1)*rVar(state,action) + ...
            (reward-rMean(state,action))^2)/nCount;
        rMean(state,action) = ((nCount-1)*rMean(state,action) + ...
            + reward)/nCount;
        
        state = newState;
        t = t+1;
        if(t>T),
        	break;
        end
        
    end
    episode = episode + 1;
end

