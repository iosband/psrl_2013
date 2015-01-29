function [rewards states actions values pols] = ...
    UCRL2Finite(M, tau, pTrue, rTrue, s1, delta)
%UCRL2Finite implements the JAO algorithm up to time T and outputs observed
%rewards through time. For a fixed episode length tau, at the end of which
%the episode is deterministically returned to s1.
%------------------------------------------------------------------
% M      - 1x1 How many episodes
% tau    - 1x1 Episode length
% pTrue  - SxSxA Probability transition matrices under actions
% rTrue  - SxA Working on a simple deterministic rewards
% s1     - 1x1 Initial state at the beginning of each episode
% delta  - 1x1 Confidence parameter
%------------------------------------------------------------------
% rewards- Tx1 Record of rewards received in each timestep
% states - Tx1 Record of states
% actions- Tx1 Record of actions
% values - MXS Record of estimated Value functions per episode
% pols   - MxS Record of policies employes per episode
%------------------------------------------------------------------

% Set up state and action counters
[S A] = size(rTrue);
vEps = zeros(S,A);
vTot = zeros(S,A);
vLim = max(ones(S,A),vTot);
pEmp = zeros(S,S,A);
rEmp = zeros(S,A);

T = M*tau;

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
    vTot = vTot + vEps;
    vEps = zeros(S,A);
    vLim = max(ones(S,A),vTot);
    
    % Work out the optimistic policy
    %disp('We have started a new episode - Calculating UCRL policy...')
    
    [pHat, pDist, rHat, rDist] = ...
        computeConfidence( vTot, pEmp, rEmp, t, delta);
    
    [value policy] = ...
        dpExtVI( pHat, pDist, rHat, rDist, tau);
    
    values(episode,:) = value';
    pols(episode,:) = policy';
    
    
    for tEps = 1:tau,
        % Follow the policy inside the episodes
        [action, newState, reward ] = ...
            singleStep(state, policy, pTrue, rTrue);
        actions(t) = action;
        rewards(t) = reward;
        states(t) = state;
        
        vEps(state,action) = vEps(state,action) + 1;
        rEmp(state,action) = rEmp(state,action) + reward;
        
        if tEps ~= tau,
            % Don't get to learn from end of episode transitions
            pEmp(newState,state,action) = pEmp(newState,state,action)+1;
            state = newState;
        end
        t = t+1; 
    end
end

