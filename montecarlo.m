clc; clear; close all;
% Constan paranmeters
zw = 1.5; % m
Tw = 10; % s
fw = 1/Tw; % Hz
nsh = 2; % Number of sheaves
ig = 11; % [-]
mpl = 18000; % kg
dD = 0.45; % m
dR = 0.5; % m
dp = 0.15; % m
mu_eq = 0.15; %
w0 = 5;
g = 9.81;
rho = 875;


% Calculating gear ratio between wire and motor
n = 1/((dD*dp)/(2*nsh*dR*2*ig));%ig*(dR/dp)/(dD/2)*(nsh)

% Calculating load inertia expeienced by the motor(s)
J = mpl*(dD/2)^2*(1/n)^2;
Cd = 0.7;

% Feed-forward controller gain
Kv = 1;

% Pump transfer function
w_hpu = 6;
zeta_hpu = 1;

% Valve transfer function
w_valve = 2*pi*50;
zeta_valve = 1;
%deltap_valve_set = 15*1e5;

% Load motor-parameters and valve parameters
motor_param = readtable('motor_parameters.csv');
valve_param = readtable('valve_parameters.csv');

max_number_of_motors = 8;
max_number_of_valves = 4;


% Creat table for the results
number_simulations = valve_param.Valve(end)*motor_param.motor(end)*max_number_of_motors*max_number_of_valves;
names = {'valve_size', 'motor_disp', 'number_of_motors', 'number_of_valves', 'error_rms', 'flow_max', 'flow_rms', 'motor_cost', 'valve_cost', 'total_cost'};
data_types = {'double','double', 'double', 'double', 'double', 'double', 'double', 'double', 'double', 'double'};
sim_result_table = table('Size', [number_simulations, 10], 'VariableTypes', data_types, 'VariableNames', names);


idx = 1;
tic % Starting timer
for valve_number = 1:valve_param.Valve(end)
    for number_of_motors = 1:max_number_of_motors
        for number_of_valves = 1:max_number_of_valves
            for motor_number = 1:motor_param.motor(end)
                fprintf('\nPerformed %i simulatins out of a total of %i\n', idx, number_simulations);
                toc

                % Setting varibles for simulation:
                Dm = motor_param.displacement(motor_number);
                nm = number_of_motors;
                nmax_motor = motor_param.max_rpm(motor_number);
                inertia_motor = motor_param.inertia(motor_number);
                nv = number_of_valves;
                %valve_max_stroke = valve_param.stroke(valve_number)/1000;
                Ad = valve_param.Ad(valve_number)/1e6; % m^2
                
                % Simulate with the current parameters
                try
                    result = sim('heave_comp.slx');
                    fprintf("Simulating...\n");

                    % Extractin position error and flow from simulation data
                    % and calculating cost
                    error = result.error.data(1,1, :);
                    flow = result.pump_flow.data(1, 1, :);
                    Cm = 2*nm*(1 + Dm/1000);
                    Csv = 2.5*nv*(1 + valve_param.Qnl(valve_number)/200);
                catch
                    warning('Simulation failed, setting nan as values')
                    error = nan;
                    flow = nan;
                    Cm = nan;
                    Csv = nan;
                end

                % Storing results in table
                sim_result_table.motor_disp(idx) = Dm;
                sim_result_table.number_of_motors(idx) = nm;
                sim_result_table.number_of_valves(idx) = nv;
                sim_result_table.error_rms(idx) = rms(error);
                sim_result_table.flow_max(idx) = max(abs(flow));
                sim_result_table.flow_rms(idx) = rms(flow);
                sim_result_table.valve_size(idx) = valve_number;
                sim_result_table.motor_cost(idx) = Cm;
                sim_result_table.valve_cost(idx) = Csv;
                sim_result_table.total_cost(idx) = Cm + Csv;
                idx = idx + 1;
            end
        end
        % Write to file for every 32-th simulation just in case
        writetable(sim_result_table, "simulation_results.csv");
        clc;
    end
end

writetable(sim_result_table, "simulation_results.csv");
fprintf('Performed %i simulatins out of a total of %i\n', idx, number_simulations);
fprintf('Finished\n');
toc







