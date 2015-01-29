function [rewards states actions values pols flags] = ...
    UCRL2(T, pTrue, rTrue, s1, delta, epsilon, maxIter)
%UCRL2 implements the JAO algorithm up to time T and outputs observed
%rewards through time. The algorithm proceeds in episodes.
%------------------------------------------------------------------
% T      - 1x1 How many timesteps we will run the simulation
% pTrue  - SxSxA Probability transition matrices under actions
% rTrue  - SxA Working on a simple deterministic rewards
% s1     - 1x1 Initial state
% delta  - 1x1 Confidence parameter
% epsilon- 1x1 Accuracy in value iteration
% maxIter- 1x1 Maximum iterations in value iteration
%------------------------------------------------------------------
% rewards- Tx1 Record of rewards received in each timestep
% states - Tx1 Record of states
% actions- Tx1 Record of actions
% values - EXS Record of estimated Value functions per episode
% pols   - ExS Record of policies employes per episode
% flags  - Ex1 Record of convergence flags per episode
%------------------------------------------------------------------

% Set up state and action counters
[S A] = size(rTrue);
vEps = zeros(S,A);
vTot = zeros(S,A);
vLim = max(ones(S,A),vTot);
pEmp = zeros(S,S,A);
rEmp = zeros(S,A);

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
    vTot = vTot + vEps;
    vEps = zeros(S,A);
    vLim = max(ones(S,A),vTot);
    
    % Work out the optimistic policy
    %disp('We have started a new episode - Calculating UCRL policy...')
    
    [pHat, pDist, rHat, rDist] = ...
        computeConfidence( vTot, pEmp, rEmp, t, delta);
    
    [value policy flag] = ...
        extendedValueIteration( pHat, pDist, rHat, rDist, epsilon, maxIter);
    
    
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
        rEmp(state,action) = rEmp(state,action) + reward;
        pEmp(newState,state,action) = pEmp(newState,state,action)+1;
        
        state = newState;
        t = t+1;
        if(t==T),
        	break;
    	end	
        
    end
    episode = episode + 1;
end

