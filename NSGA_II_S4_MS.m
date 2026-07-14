function [ activity_pop, worker_pop, pobje, managerial_cost_S4 ] = NSGA_II_S4_MS( population_size, number_of_activity, multi_skill_set_of_worker,...
                                                multi_HT_proficiency_level, task_time_of_each_skill,skill_matrix, total_skill_number,...
                                                predecessor_matrix, iteration_number, successor_matrix, crprob, mutprob, number_of_skill,...
                                                number_of_worker, multi_HT_worker_cost, swc_multi)

% Initialization
[ first_p_activity, first_p_worker ] = initialization_S4( population_size, number_of_activity, multi_skill_set_of_worker,...
                                                skill_matrix, total_skill_number, predecessor_matrix );
                                            
p_activity = first_p_activity;
p_worker = first_p_worker;


[ tutobje, managerial_cost_S4 ] = fitness_function_S4( p_activity, p_worker, multi_HT_worker_cost, population_size, number_of_worker, number_of_activity,...
                                            swc_multi, predecessor_matrix, number_of_skill, task_time_of_each_skill, multi_HT_proficiency_level,total_skill_number);

activity_pop = p_activity;
worker_pop = p_worker;
pobje = tutobje;

i = 1;
while (i < iteration_number)
    
% 1. Calculate Rank + Crowding 
    objvals = pobje(:,1:3);
    [rank_values, crowding_values] = non_dominated_sorting(objvals);
    pobje(:,4) = rank_values;
    pobje(:,5) = crowding_values;
    
% Selection procedure
[mid_population_activity, mid_population_worker] = selection(activity_pop, worker_pop, pobje, population_size, number_of_activity);

% Crossover procedure (C1: one-point crossover)
[ popc_activity, popc_worker ] = S2S4C1( number_of_activity, population_size, mid_population_activity,...
                                                mid_population_worker, predecessor_matrix, successor_matrix, crprob );
                                            
% Mutation procedure (swapping mutation)
[ Q_activity, Q_worker ] = swap_mutation( mutprob, population_size, popc_activity, popc_worker,...
                                                    skill_matrix, total_skill_number, number_of_activity );
p_activity = Q_activity;
p_worker = Q_worker;
                                                
% Calculate the fitness function
[ tutobje ] = fitness_function_S4( p_activity, p_worker, multi_HT_worker_cost, population_size, number_of_worker, number_of_activity,...
                                            swc_multi, predecessor_matrix, number_of_skill, task_time_of_each_skill, multi_HT_proficiency_level,total_skill_number);
qobje = tutobje;

[ activity_pop, worker_pop, pobje ] = P_uret( activity_pop, worker_pop, Q_activity, Q_worker, pobje, qobje, population_size);

i = i+1;
                                                                   
end
                                                                
end

