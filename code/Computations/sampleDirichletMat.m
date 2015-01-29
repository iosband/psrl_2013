function [ theta ] = sampleDirichletMat( alpha )
%sampleDirichletMat produces one realisation from Dirichlet distribution
%parametrised by alpha. This could be used for multinomial transition probs
%------------------------------------------------------------------
% alpha - SxSxA Parameters of the Dirichlet, usually counts
%------------------------------------------------------------------
% theta - SxSxA Output transition probs
%------------------------------------------------------------------

[S tmp A] = size(alpha);
theta = zeros(S,S,A);

scale=1; %Questions here

theta = gamrnd(alpha,scale);
% Normalise the probability vector
theta = theta ./ repmat(sum(theta,1),[S,1,1]);
end

