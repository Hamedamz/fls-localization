%% Hausdorff Distance: Compute the Hausdorff distance between two point clouds.
% Let A and B be subsets of a metric space (Z,dZ),
% The Hausdorff distance between A and B, denoted by dH (A, B), is defined by:
% dH (A, B)=max{sup dz(a,B), sup dz(b,A)}, for all a in A, b in B,
% dH(A, B) = max(h(A, B),h(B, A)),  
% where h(A, B) = max(min(d(a, b))),  
% and d(a, b) is a L2 norm.
% dist_H = hausdorff( A, B )
% A: First point sets.
% B: Second point sets.
% ** A and B may have different number of rows, but must have the same number of columns. **
% Hassan RADVAR-ESFAHLAN; Université du Québec; ÉTS; Montréal; CANADA
% 15.06.2010
%%
function [dH] = hausdorff( A, B)
A = A.';
B = B.';

alpha = min(90,size(A,1));

rp = randperm(size(A,1));
Aa = A(rp(1:alpha), :);
Ba = B(rp(1:alpha), :);
Da = Ba - Aa;

%disp(Aa);

minv = Inf;
mini = 0;

for i = 1:alpha
    Bb = Aa + Da(i, :);
    sum = 0;
    for j = 1:alpha
        sum = sum + norm(Bb(j, :) - Ba(j, :));
    end
    if sum < minv
        minv = sum;
        mini = i;
    end
end

A = A + Da(mini, :);

if(size(A,2) ~= size(B,2))
    fprintf( 'WARNING: dimensionality must be the same\n' );
    dist = [];
    return;
end
dH = max(compute_dist(A, B), compute_dist(B, A));


%% Compute distance
function[dist] = compute_dist(A, B)
m = size(A, 1);
n = size(B, 1);
dim= size(A, 2);
for k = 1:m
    C = ones(n, 1) * A(k, :);
    D = (C-B) .* (C-B);
    D = sqrt(D * ones(dim,1));
    dist(k) = min(D);
end
dist = max(dist);