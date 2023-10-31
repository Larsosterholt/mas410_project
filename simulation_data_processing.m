clc; clear; close all;

% Load data into WS
data = readtable("simulation_result_backup\simulation_results_corrected_valve_type.csv");

% Sort the table based on 'total_cost'
sorted_table = sortrows(data, 'total_cost');

% Select the first 50 rows
top_50_lowest_cost = sorted_table(1:100, :)

% Sort the table based on 'error_rms'
sorted_table = sortrows(top_50_lowest_cost, 'error_rms');

% Select the first 10 rows
top_10_lowest_error = sorted_table(1:10, :)

