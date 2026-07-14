clc;
clear;

% numWorkers = 6;
% pool = parpool('local', numWorkers, 'IdleTimeout', Inf); % Süresiz

number_of_activity = 16;
number_of_pactivity = 7;
number_of_worker = 40;
number_of_skill = 10;
workers = number_of_worker;

% Determination of the Required Input Parameters for the Algorithms
        
        % Sets of Factors (A, B, W, and S) for Each Experiment
        skill_set = 1:number_of_skill;
        activity_set = 1:number_of_activity;
        worker_set = 1:number_of_worker;
        while(1)
            cp1 = randi(number_of_activity-1);
            cp2 = cp1 + number_of_pactivity;
        if cp2 <= number_of_activity-1, break, end
        end
        pactivity_set = activity_set(1,cp1+1:cp2);
        
        % Determine the skill types required by the activities and the total number of workers assigned to each activity
        [ skill_matrix, total_skill_number ] = number_of_skills_and_workers( number_of_activity, number_of_skill, number_of_worker );
        
        % Define the single-skilled worker sets and the homogeneous and heterogeneous proficiency levels of the workers
        [ single_skill_set_of_worker, single_HM_proficiency_level, single_HT_proficiency_level,...
                                                        single_HM_worker_cost, single_HT_worker_cost ] = ...
                                                        single_skill_matrix( number_of_worker, number_of_skill,...
                                                        total_skill_number );
        
        % Define the multi-skilled worker sets and the workers' homogeneous and heterogeneous proficiency levels
        [ multi_skill_set_of_worker, multi_HM_proficiency_level, multi_HT_proficiency_level,...
                                                        multi_HM_worker_cost, multi_HT_worker_cost ] = ...
                                                        multi_skill_matrix( number_of_worker, number_of_skill,...
                                                        total_skill_number );
        
        % Determine the processing times (PT) for each workstation
        [ task_time_of_each_skill ] = task_times( number_of_activity, skill_matrix, number_of_skill );

        % Determine precedence relationship betweeen workstation
        [ predecessor_matrix ] = predecence_relationship( number_of_activity, pactivity_set );
         
        % Determine successor relationship between workstation
        [ successor_matrix ] = successor_relationship( number_of_activity, predecessor_matrix );
              
        % Determine the idle workstations (for WIP)
        [ swc_single, swc_multi ] = waiting( number_of_activity, predecessor_matrix );

% parameter and their leves
A = [50 100 150];
B = [0.7 0.8 0.9];
C = [0.05 0.1 0.15];
D = [250 500 750];

parametre_ve_seviyeleri = [A;B;C;D];

% Ortogonal array (L9)
orthogonal_array = [1	1	1	1;
                    1	2	2	2;
                    1	3	3	3;
                    2	1	2	3;
                    2	2	3	1;
                    2	3	1	2;
                    3	1	3	2;
                    3	2	1	3;
                    3	3	2	1];

run_number = 5;
number_of_algorithm = 4;
deney = zeros(size(orthogonal_array,1),size(orthogonal_array,2));

time = zeros(run_number,number_of_algorithm);
general_time = cell(size(orthogonal_array,1),1);

tut_activity_pop = cell(run_number,number_of_algorithm);
tut_worker_pop = cell(run_number,number_of_algorithm);
general_activity_pop = cell(size(orthogonal_array,1),1);
general_worker_pop = cell(size(orthogonal_array,1),1);

met_C = cell(size(orthogonal_array,1),1);
met_D = cell(size(orthogonal_array,1),1);
met_OS = cell(size(orthogonal_array,1),1);
met_Nnd = cell(size(orthogonal_array,1),1);
met_Nps = cell(size(orthogonal_array,1),1);
met_Igd = cell(size(orthogonal_array,1),1);
met_Sp = cell(size(orthogonal_array,1),1);
met_MID = cell(size(orthogonal_array,1),1);
met_SNS = cell(size(orthogonal_array,1),1);

Cmetric = zeros(run_number,12);
Dmetric = zeros(run_number,4);
OSmetric = zeros(run_number,6);
Npsmetric = zeros(run_number,4);
Nndmetric = zeros(run_number,4);
Igdmetric = zeros(run_number,4);
Spmetric = zeros(run_number,4);
MIDmetric = zeros(run_number,4);
SNSmetric = zeros(run_number,4);

a = 1;
while(1)

deney(a,:) = orthogonal_array(a,:);

        % Solve the algorithms using a genetic algorithm
        % Initialize the genetic algorithm parameters
        
        population_size = A(1,deney(a,1));
        crprob = B(1,deney(a,2));
        mutprob = C(1,deney(a,3));
        iteration_number = D(1,deney(a,4));
        
for b = 1:run_number
        
% NSGA-II-S1-SS: NSGA-II with single-skilled and heterogeneous workers for scenario 1 (specialization-oriented)
tic;
        [ activity_pop, worker_pop, pobje, managerial_cost_S1 ] = NSGA_II_S1_SS( population_size, number_of_activity, single_skill_set_of_worker,...
                                                single_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, single_HT_worker_cost, swc_single);
         pobje1 = pobje;
         activity_pop1 = activity_pop;
         worker_pop1 = worker_pop;
         tut_activity_pop{b,1} = activity_pop1;
         tut_worker_pop{b,1} = worker_pop1;

time_NSGA_II_S1_SS = toc;
time(b,1) = time_NSGA_II_S1_SS;

% NSGA-II-S2-SS: NSGA-II with single-skilled and heterogeneous workers for scenario 2 (flexibility-oriented)
tic;
        [ activity_pop, worker_pop, pobje, managerial_cost_S2 ] = NSGA_II_S2_SS( population_size, number_of_activity, single_skill_set_of_worker,...
                                                single_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, single_HT_worker_cost, swc_single);
         pobje2 = pobje;
         activity_pop2 = activity_pop;
         worker_pop2 = worker_pop;
         tut_activity_pop{b,2} = activity_pop2;
         tut_worker_pop{b,2} = worker_pop2;

time_NSGA_II_S2_SS = toc;
time(b,2) = time_NSGA_II_S2_SS;

% NSGA-II-S3-MS: NSGA-II with multi-skilled and heterogeneous workers for scenario 3 (specialization-oriented)
tic;
        [ activity_pop, worker_pop, pobje, managerial_cost_S3 ] = NSGA_II_S3_MS( population_size, number_of_activity, multi_skill_set_of_worker,...
                                                multi_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, multi_HT_worker_cost, swc_multi);
         pobje3 = pobje;
         activity_pop3 = activity_pop;
         worker_pop3 = worker_pop;
         tut_activity_pop{b,3} = activity_pop3;
         tut_worker_pop{b,3} = worker_pop3;

time_NSGA_II_S3_MS = toc;
time(b,3) = time_NSGA_II_S3_MS;

% NSGA-II-S4-MS: NSGA-II with multi-skilled and heterogeneous workers for scenario 4 (flexibility-oriented)
tic;
        [ activity_pop, worker_pop, pobje, managerial_cost_S4 ] = NSGA_II_S4_MS( population_size, number_of_activity, multi_skill_set_of_worker,...
                                                multi_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, multi_HT_worker_cost, swc_multi);
         pobje4 = pobje;
         activity_pop4 = activity_pop;
         worker_pop4 = worker_pop;
         tut_activity_pop{b,4} = activity_pop4;
         tut_worker_pop{b,4} = worker_pop4;

time_NSGA_II_S4_MS = toc;
time(b,4) = time_NSGA_II_S4_MS;

% Comparison metrics

[d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12, ...
          drr1,drr2,drr3,drr4, ...
          OS12,OS13,OS14,OS23,OS24,OS34, ...
          Nnd1,Nnd2,Nnd3,Nnd4, ...
          Nps1,Nps2,Nps3,Nps4, ...
          Igd1,Igd2,Igd3,Igd4, ...
          Sp1,Sp2,Sp3,Sp4,mids,sns] = ...
          metrics(pobje1,pobje2,pobje3,pobje4);

%d1 C(pobj1,pobje2) ; d2 C(pobje2, pobje1); ....
Cmetric(b,:) = [d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12];
Dmetric(b,:) = [drr1 drr2 drr3 drr4];
OSmetric(b,:) = [OS12 OS13 OS14 OS23 OS24 OS34];
Npsmetric(b,:) = [Nps1 Nps2 Nps3 Nps4];
Nndmetric(b,:) = [Nnd1 Nnd2 Nnd3 Nnd4];
Igdmetric(b,:) = [Igd1 Igd2 Igd3 Igd4];
Spmetric(b,:) = [Sp1 Sp2 Sp3 Sp4];
MIDmetric(b,:) = mids;
SNSmetric(b,:) = sns;

end

    % Store the performance metrics obtained during the experiments
    met_C{a,1} = Cmetric;
    met_D{a,1} = Dmetric;
    met_OS{a,1} = OSmetric;
    met_Nnd{a,1} = Nndmetric;
    met_Nps{a,1} = Npsmetric;
    met_Igd{a,1} = Igdmetric;
    met_Sp{a,1} = Spmetric;
    met_MID{a,1} = MIDmetric;
    met_SNS{a,1} = SNSmetric;
    
    general_time{a,1} = time;
    general_activity_pop{a,1} = tut_activity_pop;
    general_worker_pop{a,1} = tut_worker_pop;

a = a+1;
if a > size(orthogonal_array,1), break, end
end

% Parameter tuning results for all algorithms separately

runs = 5;
metrics = {'Nps', 'Igd', 'Sp', 'MID', 'SNS'};
num_experiments = size(orthogonal_array, 1);

for alg = 1:4   % 1=A1, 2=A2, 3=A3, 4=A4

    all_metrics = cell(runs, 1);
    for run = 1:runs
        all_metrics{run} = zeros(num_experiments, length(metrics));
    end

    % Collect metric values for selected algorithm
    for i = 1:num_experiments
        for run = 1:runs
            for j = 1:length(metrics)
                metric = metrics{j};
                data = eval(sprintf('met_%s{i,1}', metric));
                value = data(run, alg);   % alg = 1,2,3,4
                all_metrics{run}(i, j) = value;
            end
        end
    end

    % Normalization for each run
    for run = 1:runs
        Nps = all_metrics{run}(:,1);
        Igd = all_metrics{run}(:,2);
        Sp  = all_metrics{run}(:,3);
        MID = all_metrics{run}(:,4);
        SNS = all_metrics{run}(:,5);

        % higher is better
        max_Nps = max(Nps);
        max_SNS = max(SNS);

        % lower is better
        min_Igd = min(Igd);
        min_Sp  = min(Sp);
        min_MID = min(MID);

        normalized_Nps = Nps / max_Nps;
        normalized_Nps(isnan(normalized_Nps)) = 0;
        normalized_Nps(isinf(normalized_Nps)) = 0;

        normalized_SNS = SNS / max_SNS;
        normalized_SNS(isnan(normalized_SNS)) = 0;
        normalized_SNS(isinf(normalized_SNS)) = 0;

        normalized_Igd = min_Igd ./ Igd;
        normalized_Igd(isnan(normalized_Igd)) = 0;
        normalized_Igd(isinf(normalized_Igd)) = 0;

        normalized_Sp = min_Sp ./ Sp;
        normalized_Sp(isnan(normalized_Sp)) = 0;
        normalized_Sp(isinf(normalized_Sp)) = 0;

        normalized_MID = min_MID ./ MID;
        normalized_MID(isnan(normalized_MID)) = 0;
        normalized_MID(isinf(normalized_MID)) = 0;

        all_metrics{run}(:,1) = normalized_Nps;
        all_metrics{run}(:,2) = normalized_Igd;
        all_metrics{run}(:,3) = normalized_Sp;
        all_metrics{run}(:,4) = normalized_MID;
        all_metrics{run}(:,5) = normalized_SNS;
    end

    % Separate runs
    all_metrics_run1 = all_metrics{1};
    all_metrics_run2 = all_metrics{2};
    all_metrics_run3 = all_metrics{3};
    all_metrics_run4 = all_metrics{4};
    all_metrics_run5 = all_metrics{5};

    % Sum of normalized metrics
    sum1 = sum(all_metrics_run1, 2);
    sum2 = sum(all_metrics_run2, 2);
    sum3 = sum(all_metrics_run3, 2);
    sum4 = sum(all_metrics_run4, 2);
    sum5 = sum(all_metrics_run5, 2);

    general_result = [sum1, sum2, sum3, sum4, sum5];

    % File name by algorithm
    filename_Tag = sprintf('Taguchi_Sonuclar_A%d.xlsx', alg);

    % Write Excel
    writematrix(general_result, filename_Tag, 'Sheet', 1);
    writematrix(all_metrics_run1, filename_Tag, 'Sheet', 2);
    writematrix(all_metrics_run2, filename_Tag, 'Sheet', 3);
    writematrix(all_metrics_run3, filename_Tag, 'Sheet', 4);
    writematrix(all_metrics_run4, filename_Tag, 'Sheet', 5);
    writematrix(all_metrics_run5, filename_Tag, 'Sheet', 6);
end