function [rewards states actions values pols vTot] = ...
    PSRL(M, tau, pTrue, rTrue, s1, mu0, nMu0, tau0, nTau0, alpha0)
%PSRL implements the PSRL algorithm for M episodes of timeframe tau and
%outputs the rewards, states, acitons etc as before. At the end of tau
%timesteps the agent will be deterministically returned to s1
%------------------------------------------------------------------
% M      - 1x1 How many episodes for simulation
% tau    - 1x1 Length of episode
% pTrue  - SxSxA Probability transition matrices under actions
% rTrue  - SxA Working on a simple deterministic rewards
% s1     - 1x1 Initial state at beginning of each episode
% mu0    - SxA Prior estimate of mean return
% nMu0   - SxA Prior number of prior observations which we based mu0 on
% tau0   - SxA Prior stimate of tau = sigma^-2
% nTau0  - SxA Prior umber of prior observations which we based tau0 on
% alpha0 - SxSxA Prior dirichlet distribution specification
%------------------------------------------------------------------
% rewards- Tx1 Record of rewards received in each timestep
% states - Tx1 Record of states
% actions- Tx1 Record of actions
% values - MXS Record of estimated Value functions per episode
% pols   - MxS Record of policies employes per episode
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
T = M * tau;

% Bayesian holders
pSample = zeros(S,S,A);
muSample = zeros(S,A);
varSample = zeros(S,A);

% Output variables
rewards = zeros(T,1);
states = zeros(T,1);
actions = zeros(T,1);
values = zeros(M,S);
pols = zeros(M,S);

% Initialise system
t = 1;

for episode=1:M,
    state = s1;
    
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
    [value policy] = dpValueIteration(pSample,muSample,tau);

    values(episode,:) = value';
    pols(episode,:) = policy';
    
    for tEps = 1:tau,
        % Follow the policy inside the episodes
        [action, newState, reward ] = ...
            singleStep(state, policy, pTrue, rTrue);
        actions(t) = action;
        rewards(t) = reward;
        states(t) = state;
        
        % Update the mean and variance of observed rewards
        vEps(state,action) = vEps(state,action) + 1;
        vTot(state,action) = vTot(state,action) + 1;
        nCount = vTot(state,action);
        
        rVar(state,action) = ((nCount-1)*rVar(state,action) + ...
            (reward-rMean(state,action))^2)/nCount;
        rMean(state,action) = ((nCount-1)*rMean(state,action) + ...
            + reward)/nCount;
        
        if tEps ~= tau,
            % Don't get to learn from end of episode transitions
            pEmp(newState,state,action) = pEmp(newState,state,action)+1;
            state = newState;
        end
            
        t = t+1;
    end
end

