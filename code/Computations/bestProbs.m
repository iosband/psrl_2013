function [ pOpt ] = bestProbs(oldVal, pHat, dist)
%bestProbs goes through a single state action pair and
%computes the most optimistic possible probablity transitions
%------------------------------------------------------------------
% oldVal - Sx1 old estimate of the value function
% pHat   - Sx! estimate of transition probabilities
% dist   - 1x1 How much L1 slack to play with
%------------------------------------------------------------------
% pOpt   - Sx1 optimistic probability transitions
%------------------------------------------------------------------

S = length(pHat);
pOpt = pHat;

%Sort to find out which are the best estimated states
%idx stores states in order of goodness, best first.
%Add in a bit of randomness to break ties.
[tmp idx] = sort(-(oldVal+rand(S,1)*0.00001));
best = idx(1);

pOpt(best) = min(1, pHat(best)+dist/2);

l = S;
while ( sum(pOpt)> 1),
    worst = idx(l);
    pOpt(worst) = max(0, 1 - sum(pOpt) + pOpt(worst));
    l = l-1 ;
end

end

