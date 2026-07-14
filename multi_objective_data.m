clc;
clear;

rng('shuffle')

activities = [12 16 20];
pactivities = [5 7 9];
workers = [30 40 50];
skills = [5 10 15];

% Number of total experiment
number_of_experiment = size(activities,2)*size(skills,2)*size(workers,2);

[ tut_pactivity_set, tut_single_skill_set_of_worker, tut_task_time_of_each_skill, tut_skill_matrix, tut_total_skill_number, tut_predecessor_matrix,...
           tut_successor_matrix, time_NSGA_II_S1_SS, time_NSGA_II_S2_SS, time_NSGA_II_S3_MS, time_NSGA_II_S4_MS, tut_single_HM_proficiency_level, tut_single_HT_proficiency_level,...
           tut_multi_skill_set_of_worker, tut_multi_HM_proficiency_level, tut_multi_HT_proficiency_level, tut_single_HM_worker_cost, tut_single_HT_worker_cost,...
           tut_multi_HM_worker_cost, tut_multi_HT_worker_cost, tut_activity_pop1, tut_activity_pop2, tut_activity_pop3, tut_activity_pop4, tut_worker_pop1,...
           tut_worker_pop2, tut_worker_pop3, tut_worker_pop4, tut_swc_single, tut_swc_multi, tut_total_swc_single, tut_total_swc_multi, tut_managerial_cost_S1,...
           tut_managerial_cost_S2, tut_managerial_cost_S3, tut_managerial_cost_S4] = all_datas_sets( number_of_experiment, pactivities );

% Main loop for design of experiment
met_C = cell(1,size(pactivities,2));
met_D = cell(1,size(pactivities,2));
met_OS = cell(1,size(pactivities,2));
met_Nnd = cell(1,size(pactivities,2));
met_Nps = cell(1,size(pactivities,2));
met_Igd = cell(1,size(pactivities,2));
met_Sp = cell(1,size(pactivities,2));
met_MID = cell(1,size(pactivities,2));
met_SNS = cell(1,size(pactivities,2));
Cmetric = zeros(number_of_experiment,12);
Dmetric = zeros(number_of_experiment,4);
OSmetric = zeros(number_of_experiment,6);
Npsmetric = zeros(number_of_experiment,4);
Nndmetric = zeros(number_of_experiment,4);
Igdmetric = zeros(number_of_experiment,4);
Spmetric = zeros(number_of_experiment,4);
MIDmetric = zeros(number_of_experiment,4);
SNSmetric = zeros(number_of_experiment,4);
for i = 1:size(pactivities,2)
    if i == 1
        number_of_pactivity = pactivities(1,1);
    elseif i == 2
        number_of_pactivity = pactivities(1,2);
    elseif i == 3
        number_of_pactivity = pactivities(1,3);
    end
    
    for j= 1:number_of_experiment
        if j ==1
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,1);
        elseif j == 2
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,2);
        elseif j == 3
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,3);
        elseif j == 4
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,1);
        elseif j == 5
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,2);
        elseif j == 6
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,3);
        elseif j == 7
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,1); 
        elseif j == 8
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,2); 
        elseif j == 9
            number_of_activity = activities(1,1);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,3);
        elseif j == 10
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,1);
        elseif j == 11
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,2);
        elseif j == 12
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,3);
        elseif j == 13
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,1);
        elseif j == 14
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,2);
        elseif j == 15
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,3);
        elseif j == 16
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,1);
        elseif j == 17
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,2);
        elseif j == 18
            number_of_activity = activities(1,2);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,3);
        elseif j == 19
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,1);
        elseif j == 20
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,2);
        elseif j == 21
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,1);
            number_of_worker = workers(1,3);
        elseif j == 22
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,1);
        elseif j == 23
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,2);
        elseif j == 24
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,2);
            number_of_worker = workers(1,3);
        elseif j == 25
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,1);
        elseif j == 26
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,2);
        elseif j == 27
            number_of_activity = activities(1,3);
            number_of_skill = skills(1,3);
            number_of_worker = workers(1,3); 
        end
        
        %% Define the required input parameters for the algorithms
        
        % Factor sets (A, B, W, and S) for each experiment
        skill_set = 1:number_of_skill;
        activity_set = 1:number_of_activity;
        worker_set = 1:number_of_worker;
        while(1)
            cp1 = randi(number_of_activity-1);
            cp2 = cp1 + number_of_pactivity;
        if cp2 <= number_of_activity-1, break, end
        end
        pactivity_set = activity_set(1,cp1+1:cp2);
        tut_pactivity_set{j,i} = pactivity_set;
        
        % Determine the skill types required by the activities and the total number of workers assigned to each activity
        [ skill_matrix, total_skill_number ] = number_of_skills_and_workers( number_of_activity, number_of_skill, number_of_worker );
        tut_skill_matrix{j,i} = skill_matrix;
        tut_total_skill_number{j,i} = total_skill_number;
        
        % Define the single-skilled worker sets and the homogeneous and heterogeneous proficiency levels of the workers
        [ single_skill_set_of_worker, single_HM_proficiency_level, single_HT_proficiency_level,...
                                                        single_HM_worker_cost, single_HT_worker_cost ] = ...
                                                        single_skill_matrix( number_of_worker, number_of_skill,...
                                                        total_skill_number );
        tut_single_skill_set_of_worker{j,i} = single_skill_set_of_worker;
        tut_single_HM_proficiency_level{j,i} = single_HM_proficiency_level;
        tut_single_HT_proficiency_level{j,i} = single_HT_proficiency_level;
        tut_single_HM_worker_cost{j,i} = single_HM_worker_cost;
        tut_single_HT_worker_cost{j,i} = single_HT_worker_cost;
        
        % Define the multi-skilled worker sets and the workers' homogeneous and heterogeneous proficiency levels
        [ multi_skill_set_of_worker, multi_HM_proficiency_level, multi_HT_proficiency_level,...
                                                        multi_HM_worker_cost, multi_HT_worker_cost ] = ...
                                                        multi_skill_matrix( number_of_worker, number_of_skill,...
                                                        total_skill_number );
        tut_multi_skill_set_of_worker{j,i} = multi_skill_set_of_worker;
        tut_multi_HM_proficiency_level{j,i} = multi_HM_proficiency_level;
        tut_multi_HT_proficiency_level{j,i} = multi_HT_proficiency_level;
        tut_multi_HM_worker_cost{j,i} = multi_HM_worker_cost;
        tut_multi_HT_worker_cost{j,i} = multi_HT_worker_cost;
        
        % Determine the processing times (PT) for each workstation
        [ task_time_of_each_skill ] = task_times( number_of_activity, skill_matrix, number_of_skill );
        tut_task_time_of_each_skill{j,i} = task_time_of_each_skill;

        % etermine the precedence relationships among the workstations
        [ predecessor_matrix ] = predecence_relationship( number_of_activity, pactivity_set );
        tut_predecessor_matrix{j,i} = predecessor_matrix;
         
        % Determine the successor relationships among the workstations
        [ successor_matrix ] = successor_relationship( number_of_activity, predecessor_matrix );
        tut_successor_matrix{j,i} = successor_matrix;
              
        % Determine the idle workstations (for WIP cost)
        [ swc_single, swc_multi ] = waiting( number_of_activity, predecessor_matrix );
        tut_swc_single{j,i} = swc_single;
        tut_total_swc_single(j,i) = sum(swc_single);
        tut_swc_multi{j,i} = swc_multi;
        tut_total_swc_multi(j,i) = sum(swc_multi);
         
        %% Solve the algorithms using a genetic algorithm
        
        % Initialize the genetic algorithm parameters
        crprob = 0.7;
        mutprob = 0.1;
        iteration_number = 750;
        population_size = 150;

% NSGA-II-S1-SS: NSGA-II with single-skilled and heterogeneous workers for scenario 1 (specialization-oriented)
tic;
        [ activity_pop, worker_pop, pobje, managerial_cost_S1 ] = NSGA_II_S1_SS( population_size, number_of_activity, single_skill_set_of_worker,...
                                                single_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, single_HT_worker_cost, swc_single);
         pobje1 = pobje;
         activity_pop1 = activity_pop;
         worker_pop1 = worker_pop;
         tut_activity_pop1{j,i} = activity_pop1;
         tut_worker_pop1{j,i} = worker_pop1;
         tut_managerial_cost_S1{j,i} = managerial_cost_S1;

time_NSGA_II_S1_SS(j,i) = toc;


% NSGA-II-S2-SS: NSGA-II with single-skilled and heterogeneous workers for scenario 2 (flexibility-oriented)
tic;
        [ activity_pop, worker_pop, pobje, managerial_cost_S2 ] = NSGA_II_S2_SS( population_size, number_of_activity, single_skill_set_of_worker,...
                                                single_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, single_HT_worker_cost, swc_single);
         pobje2 = pobje;
         activity_pop2 = activity_pop;
         worker_pop2 = worker_pop;
         tut_activity_pop2{j,i} = activity_pop2;
         tut_worker_pop2{j,i} = worker_pop2;
         tut_managerial_cost_S2{j,i} = managerial_cost_S2;

time_NSGA_II_S2_SS(j,i) = toc;


% NSGA-II-S3-MS: NSGA-II with multi-skilled and heterogeneous workers for scenario 3 (specialization-oriented)
tic;
        [ activity_pop, worker_pop, pobje, managerial_cost_S3 ] = NSGA_II_S3_MS( population_size, number_of_activity, multi_skill_set_of_worker,...
                                                multi_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, multi_HT_worker_cost, swc_multi);
         pobje3 = pobje;
         activity_pop3 = activity_pop;
         worker_pop3 = worker_pop;
         tut_activity_pop3{j,i} = activity_pop3;
         tut_worker_pop3{j,i} = worker_pop3;
         tut_managerial_cost_S3{j,i} = managerial_cost_S3;

time_NSGA_II_S3_MS(j,i) = toc;


% NSGA-II-S4-MS: NSGA-II with multi-skilled and heterogeneous workers for scenario 4 (flexibility-oriented)
tic;
        [ activity_pop, worker_pop, pobje, managerial_cost_S4 ] = NSGA_II_S4_MS( population_size, number_of_activity, multi_skill_set_of_worker,...
                                                multi_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, multi_HT_worker_cost, swc_multi);
         pobje4 = pobje;
         activity_pop4 = activity_pop;
         worker_pop4 = worker_pop;
         tut_activity_pop4{j,i} = activity_pop4;
         tut_worker_pop4{j,i} = worker_pop4;
         tut_managerial_cost_S4{j,i} = managerial_cost_S4;

time_NSGA_II_S4_MS(j,i) = toc;

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
Cmetric(j,:) = [d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12];
Dmetric(j,:) = [drr1 drr2 drr3 drr4];
OSmetric(j,:) = [OS12 OS13 OS14 OS23 OS24 OS34];
Npsmetric(j,:) = [Nps1 Nps2 Nps3 Nps4];
Nndmetric(j,:) = [Nnd1 Nnd2 Nnd3 Nnd4];
Igdmetric(j,:) = [Igd1 Igd2 Igd3 Igd4];
Spmetric(j,:) = [Sp1 Sp2 Sp3 Sp4];
MIDmetric(j,:) = mids;
SNSmetric(j,:) = sns;

        
    end
    
    % Store the performance metrics obtained during the experiments
    met_C{1,i} = Cmetric;
    met_D{1,i} = Dmetric;
    met_OS{1,i} = OSmetric;
    met_Nps{1,i} = Npsmetric;
    met_Nnd{1,i} = Nndmetric;
    met_Igd{1,i} = Igdmetric;
    met_Sp{1,i} = Spmetric;
    met_MID{1,i} = MIDmetric;
    met_SNS{1,i} = SNSmetric;
end

save('workspace_results.mat')