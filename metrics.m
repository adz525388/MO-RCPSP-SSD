function [d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12, ...
          drr1,drr2,drr3,drr4, ...
          OS12,OS13,OS14,OS23,OS24,OS34, ...
          Nnd1,Nnd2,Nnd3,Nnd4, ...
          Nps1,Nps2,Nps3,Nps4, ...
          Igd1,Igd2,Igd3,Igd4, ...
          Sp1,Sp2,Sp3,Sp4,mids,sns] = ...
          metrics(pobje1,pobje2,pobje3,pobje4)
% METRICS
% Calculates performance metrics for the Pareto solution sets obtained
% under four workforce configurations: A1, A2, A3, and A4.
%
% The first three columns of each input matrix contain:
%   Column 1: labor cost
%   Column 2: makespan
%   Column 3: workload imbalance
%
% Column 4 contains the Pareto rank. Only rank-1 solutions are considered.
%
% All objectives are assumed to be minimized.

%% ------------------------------------------------------------------------
% 1. Extract rank-1 Pareto solutions
% -------------------------------------------------------------------------

P1 = extract_rank_one_solutions(pobje1);
P2 = extract_rank_one_solutions(pobje2);
P3 = extract_rank_one_solutions(pobje3);
P4 = extract_rank_one_solutions(pobje4);

% Remove duplicate objective vectors within each configuration
P1unique = unique(P1, 'rows', 'stable');
P2unique = unique(P2, 'rows', 'stable');
P3unique = unique(P3, 'rows', 'stable');
P4unique = unique(P4, 'rows', 'stable');

%% ------------------------------------------------------------------------
% 2. C-metric: pairwise coverage relationships
% C(A,B) = fraction of solutions in B dominated by at least one solution in A
% -------------------------------------------------------------------------

d1  = calculate_c_metric(P1unique, P2unique); % C(A1,A2)
d2  = calculate_c_metric(P2unique, P1unique); % C(A2,A1)

d3  = calculate_c_metric(P1unique, P3unique); % C(A1,A3)
d4  = calculate_c_metric(P3unique, P1unique); % C(A3,A1)

d5  = calculate_c_metric(P1unique, P4unique); % C(A1,A4)
d6  = calculate_c_metric(P4unique, P1unique); % C(A4,A1)

d7  = calculate_c_metric(P2unique, P3unique); % C(A2,A3)
d8  = calculate_c_metric(P3unique, P2unique); % C(A3,A2)

d9  = calculate_c_metric(P2unique, P4unique); % C(A2,A4)
d10 = calculate_c_metric(P4unique, P2unique); % C(A4,A2)

d11 = calculate_c_metric(P3unique, P4unique); % C(A3,A4)
d12 = calculate_c_metric(P4unique, P3unique); % C(A4,A3)

%% ------------------------------------------------------------------------
% 3. Construct the common empirical reference Pareto set
% -------------------------------------------------------------------------

Pall = unique([P1unique; P2unique; P3unique; P4unique], ...
              'rows', 'stable');

Pstar = nondominated_set(Pall);

if isempty(Pstar)
    error('metrics:EmptyReferenceSet', ...
          'The common empirical reference Pareto set is empty.');
end

%% ------------------------------------------------------------------------
% 4. Common objective normalization
%
% The same normalization limits are applied to A1-A4 to preserve
% comparability between workforce configurations.
% -------------------------------------------------------------------------

fmin = min(Pstar, [], 1);
fmax = max(Pstar, [], 1);
frange = fmax - fmin;

% Prevent division by zero if an objective is constant in Pstar
frange(frange == 0) = 1;

PstarN = normalize_objectives(Pstar,    fmin, frange);
P1N    = normalize_objectives(P1unique, fmin, frange);
P2N    = normalize_objectives(P2unique, fmin, frange);
P3N    = normalize_objectives(P3unique, fmin, frange);
P4N    = normalize_objectives(P4unique, fmin, frange);

%% ------------------------------------------------------------------------
% 5. D1R metric
%
% This preserves the squared normalized-distance structure used in the
% original implementation.
% -------------------------------------------------------------------------

drr1 = calculate_d1r(PstarN, P1N);
drr2 = calculate_d1r(PstarN, P2N);
drr3 = calculate_d1r(PstarN, P3N);
drr4 = calculate_d1r(PstarN, P4N);

%% ------------------------------------------------------------------------
% 6. Overall spread ratios
%
% The original raw-objective formulation is retained.
% -------------------------------------------------------------------------

OS12 = calculate_os_ratio(P1unique, P2unique);
OS13 = calculate_os_ratio(P1unique, P3unique);
OS14 = calculate_os_ratio(P1unique, P4unique);
OS23 = calculate_os_ratio(P2unique, P3unique);
OS24 = calculate_os_ratio(P2unique, P4unique);
OS34 = calculate_os_ratio(P3unique, P4unique);

%% ------------------------------------------------------------------------
% 7. Number of Pareto and unique nondominated solutions
% -------------------------------------------------------------------------

% Total number of rank-1 solutions, including repeated objective vectors
Nps1 = size(P1, 1);
Nps2 = size(P2, 1);
Nps3 = size(P3, 1);
Nps4 = size(P4, 1);

% Number of unique rank-1 objective vectors
Nnd1 = size(P1unique, 1);
Nnd2 = size(P2unique, 1);
Nnd3 = size(P3unique, 1);
Nnd4 = size(P4unique, 1);

%% ------------------------------------------------------------------------
% 8. Inverted Generational Distance
% -------------------------------------------------------------------------

Igd1 = calculate_igd(PstarN, P1N);
Igd2 = calculate_igd(PstarN, P2N);
Igd3 = calculate_igd(PstarN, P3N);
Igd4 = calculate_igd(PstarN, P4N);

%% ------------------------------------------------------------------------
% 9. Spacing metric
%
% The original average-pairwise-distance definition is retained, but it is
% now calculated using normalized objective values.
% -------------------------------------------------------------------------

Sp1 = calculate_spacing(P1N);
Sp2 = calculate_spacing(P2N);
Sp3 = calculate_spacing(P3N);
Sp4 = calculate_spacing(P4N);

%% ------------------------------------------------------------------------
% 10. MID and SNS
% -------------------------------------------------------------------------

normalized_pareto_sets = {P1N, P2N, P3N, P4N};

mids_column = calculate_mid(normalized_pareto_sets);
sns_column  = calculate_sns(normalized_pareto_sets, mids_column);

% Preserve the original row-vector output structure
mids = mids_column';
sns  = sns_column';

end


%% =========================================================================
% Local functions
% =========================================================================

function P = extract_rank_one_solutions(pobje)
% Extracts the first three objectives of rank-1 solutions.

    if isempty(pobje)
        error('metrics:EmptyInput', ...
              'One of the input objective matrices is empty.');
    end

    if size(pobje, 2) < 4
        error('metrics:InvalidInput', ...
              'Each input matrix must contain at least four columns.');
    end

    P = pobje(pobje(:,4) == 1, 1:3);

    if isempty(P)
        error('metrics:NoRankOneSolution', ...
              'An input matrix contains no rank-1 solution.');
    end
end


function coverage = calculate_c_metric(A, B)
% Calculates C(A,B), the proportion of solutions in B dominated by at
% least one solution in A.
%
% Standard Pareto dominance for minimization:
% a dominates b if a is no worse in all objectives and strictly better
% in at least one objective.

    if isempty(B)
        coverage = NaN;
        return;
    end

    dominatedB = false(size(B,1), 1);

    for i = 1:size(B,1)
        b = B(i,:);

        dominanceCheck = ...
            all(A <= b, 2) & any(A < b, 2);

        dominatedB(i) = any(dominanceCheck);
    end

    coverage = sum(dominatedB) / size(B,1);
end


function Pnd = nondominated_set(P)
% Returns the nondominated subset of P for a minimization problem.

    if isempty(P)
        Pnd = [];
        return;
    end

    P = unique(P, 'rows', 'stable');
    numberOfSolutions = size(P,1);
    isDominated = false(numberOfSolutions,1);

    for i = 1:numberOfSolutions
        if isDominated(i)
            continue;
        end

        for j = 1:numberOfSolutions
            if i == j
                continue;
            end

            if all(P(j,:) <= P(i,:)) && any(P(j,:) < P(i,:))
                isDominated(i) = true;
                break;
            end
        end
    end

    Pnd = P(~isDominated,:);
end


function PN = normalize_objectives(P, fmin, frange)
% Normalizes objective values using common reference-set limits.

    if isempty(P)
        PN = [];
        return;
    end

    PN = (P - fmin) ./ frange;
end


function d1r = calculate_d1r(referenceSetN, approximationSetN)
% Calculates D1R using the mean minimum normalized Euclidean distance
% from every reference point to the approximation set.

    if isempty(referenceSetN) || isempty(approximationSetN)
        d1r = NaN;
        return;
    end

    minimumDistances = zeros(size(referenceSetN,1),1);

    for i = 1:size(referenceSetN,1)
        differences = approximationSetN - referenceSetN(i,:);
        distances = sqrt(sum(differences.^2,2));
        minimumDistances(i) = min(distances);
    end

    d1r = mean(minimumDistances);
end


function os = calculate_os_ratio(PA, PB)
% Calculates the overall spread ratio using the original formulation.

    if isempty(PA) || isempty(PB)
        os = NaN;
        return;
    end

    rangeA = max(PA, [], 1) - min(PA, [], 1);
    rangeB = max(PB, [], 1) - min(PB, [], 1);

    volumeA = prod(rangeA);
    volumeB = prod(rangeB);

    os = (volumeA + 0.5) / (volumeB + 0.5);
end


function igd = calculate_igd(referenceSetN, approximationSetN)
% Calculates the Inverted Generational Distance.
%
% For every point in the common normalized reference set, the minimum
% Euclidean distance to the approximation set is calculated. IGD is the
% mean of these minimum distances.

    if isempty(referenceSetN) || isempty(approximationSetN)
        igd = NaN;
        return;
    end

    minimumDistances = zeros(size(referenceSetN,1),1);

    for i = 1:size(referenceSetN,1)
        differences = approximationSetN - referenceSetN(i,:);
        distances = sqrt(sum(differences.^2, 2));

        minimumDistances(i) = min(distances);
    end

    igd = mean(minimumDistances);
end


function spacing = calculate_spacing(PN)
% Calculates spacing based on the dispersion of average pairwise
% Euclidean distances.
%
% The definition is consistent with the user's original function, but
% normalized objective values are used.

    numberOfSolutions = size(PN,1);

    if numberOfSolutions <= 1
        spacing = 0;
        return;
    end

    averageDistances = zeros(numberOfSolutions,1);

    for i = 1:numberOfSolutions
        totalDistance = 0;

        for j = 1:numberOfSolutions
            if i ~= j
                totalDistance = totalDistance + ...
                    norm(PN(i,:) - PN(j,:), 2);
            end
        end

        averageDistances(i) = ...
            totalDistance / (numberOfSolutions - 1);
    end

    meanDistance = mean(averageDistances);

    spacing = sqrt( ...
        sum((averageDistances - meanDistance).^2) / ...
        (numberOfSolutions - 1) ...
    );
end


function mids = calculate_mid(normalizedParetoSets)
% Calculates the Mean Ideal Distance.
%
% After normalization, the empirical ideal point is [0,0,0]. MID is the
% mean Euclidean distance of the Pareto solutions to this ideal point.

    numberOfSets = numel(normalizedParetoSets);
    mids = zeros(numberOfSets,1);

    for i = 1:numberOfSets
        PN = normalizedParetoSets{i};

        if isempty(PN)
            mids(i) = NaN;
            continue;
        end

        distancesToIdeal = sqrt(sum(PN.^2, 2));
        mids(i) = mean(distancesToIdeal);
    end
end


function sns = calculate_sns(normalizedParetoSets, mids)
% Calculates the spread of nondominated solutions around the corresponding
% MID value.
%
% SNS is represented by the sample standard deviation of normalized
% Euclidean distances from the ideal point.

    numberOfSets = numel(normalizedParetoSets);
    sns = zeros(numberOfSets,1);

    for i = 1:numberOfSets
        PN = normalizedParetoSets{i};
        numberOfSolutions = size(PN,1);

        if numberOfSolutions <= 1
            sns(i) = 0;
            continue;
        end

        distancesToIdeal = sqrt(sum(PN.^2, 2));

        sns(i) = sqrt( ...
            sum((distancesToIdeal - mids(i)).^2) / ...
            (numberOfSolutions - 1) ...
        );
    end
end