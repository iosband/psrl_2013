function [ mu, tau ] = ...
    sampleNormalGammaMat( mu0, nMu0, tau0, nTau0, nObs, muObs, varObs )
%sampleNormalGammaMat takes in a prior and emprical set of information and
%then outputs the samples mu and tau parameters for a normal dist.
% http://en.wikipedia.org/wiki/Normal-gamma_distribution
% http://www.seas.harvard.edu/courses/cs281/papers/murphy-2007.pdf
%------------------------------------------------------------------
% mu0    - SxA Prior estimate of mean return
% nMu0   - SxA Prior number of prior observations which we based mu0 on
% tau0   - SxA Prior stimate of tau = sigma^-2
% nTau0  - SxA Prior umber of prior observations which we based tau0 on
% nObs   - SxA Empirical number of observations
% muObs  - SxA Empirical mean of observations
% varObs - SxA Empirical variance of observations
%------------------------------------------------------------------
% mu     - SxA Mean of output normal
% tau    - SxA Precision = sigma^-2
%------------------------------------------------------------------

% First do as if there is no observations
lambda0 = nMu0;
alpha0 = nTau0 / 2;
beta0 = alpha0 ./ tau0;

% Now account for the observations
mu = (lambda0.*mu0 + nObs.*muObs) ./ (lambda0+nObs);
lambda = lambda0+nObs;
alpha = alpha0 + nObs/2;
beta = beta0 + 0.5*(nObs.*varObs+ lambda0.*nObs.*(muObs-mu0).^2 ./(lambda0+nObs));

% Now sample according to this normal gamma
tau = gamrnd(alpha,1./beta);
mu = normrnd(mu, 1./sqrt(lambda.*tau));

end