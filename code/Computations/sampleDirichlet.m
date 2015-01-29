function [ theta ] = sampleDirichlet( alpha )
%sampleDirichlet produces one realisation from Dirichlet distribution
%parametrised by alpha. This could be used for multinomial transition probs
%------------------------------------------------------------------
% alpha - Sx1 Parameters of the Dirichlet, usually counts
%------------------------------------------------------------------
% theta - Sx1 Output transition probs
%------------------------------------------------------------------

S = length(alpha);
theta = zeros(S,1);
scale=1; %Questions here

for i=1:S,
    theta(i) = gamrnd(alpha(i),scale,1,1);
end

theta = theta ./ sum(theta);


end

