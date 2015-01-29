function [value policy flag rho] = ...
    valueIteration( probs, rewards, epsilon, maxIter)
%valueIteration implements the repeated bellman operator to look for
%solutions to get policies and values for a given probs and rewards.
%------------------------------------------------------------------
% probs  - SxSxA estimate of transition probabilities
% rewards- SxA estimate of reward function
% epsilon- 1x1 tolerance for convergence
% maxIter- 1x1 maximum number of iterations
%------------------------------------------------------------------
% value  - Sx1 new value function
% policy - Sx1 new policy to take
% flag   - 1x1 0 signals epsilon convergence, 1 for maxIter
% rho    - 1x1 Optimal average reward
%------------------------------------------------------------------

[S A] = size(rewards);
oldVal = zeros(S,1);
complete = false;
err = 1;
nIter =1;
flag =1;

while( ~complete),
    % Keep applying the extended bellman operator until convergence
    [value, policy] = bellman(oldVal, probs, rewards);
    
    err = span(value-oldVal);
    nIter=nIter+1;
    oldVal = value;
    
    if(err<epsilon),
        complete=true;
        flag=0;
    end
    
    if(nIter>maxIter),
        complete=true;
    end
end


optP = zeros(S,S);
optR = zeros(S,1);

% Now compute the optimal markov chain
for state = 1:S,
    optP(state,:) = probs(:,state,policy(state))';
    optR(state) = rewards(state,policy(state));
end

rho = dot(mean(optP^1000), optR);
end
