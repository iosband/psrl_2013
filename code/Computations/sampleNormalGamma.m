function [ mu, tau ] = ...
    sampleNormalGamma( mu0, nMu0, tau0, nTau0, nObs, muObs, sObs )
%sampleNormalGamma takes in a prior and emprical set of information and
%then outputs the samples mu and tau parameters for a normal dist.
% http://en.wikipedia.org/wiki/Normal-gamma_distribution
% http://www.seas.harvard.edu/courses/cs281/papers/murphy-2007.pdf
%------------------------------------------------------------------
% mu0    - 1x1 Prior estimate of mean return
% nMu0   - 1x1 Prior number of prior observations which we based mu0 on
% tau0   - 1x1 Prior stimate of tau = sigma^-2
% nTau0  - 1x1 Prior umber of prior observations which we based tau0 on
% nObs   - 1x1 Empirical number of observations
% muObs  - 1x1 Empirical mean of observations
% sObs   - 1x1 Empirical variance of observations
%------------------------------------------------------------------
% mu     - 1x1 Mean of output normal
% tau    - 1x1 Precision = sigma^-2
%------------------------------------------------------------------

% First do as if there is no observations
lambda0 = nMu0;
alpha0 = nTau0/2;
beta0 = alpha0/tau0;

% Now account for the observations
mu = (lambda0*mu0 + nObs*muObs)/(lambda0+nObs);
lambda = lambda0+nObs;
alpha = alpha0 + nObs/2;
beta = beta0 + 0.5*(nObs*sObs+ lambda0*nObs*(muObs-mu0)^2/(lambda0+nObs));

% Now sample according to this normal gamma
tau = gamrnd(alpha,1/beta);
mu = normrnd(mu, 1/sqrt(lambda*tau));

end