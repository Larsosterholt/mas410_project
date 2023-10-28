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
% Calculating gear ratio between wire and motor
n = 1/((dD*dp)/(2*nsh*dR*2*ig));%ig*(dR/dp)/(dD/2)*(nsh)

% Calculating load inertia expeienced by the motor(s)
J = mpl*(dD/2)^2*(1/n)^2;
Cd = 0.7;
Ad = 78/1e6; % m^2
valve_max_stroke = 0.9/1000; %mm

% Feed-forward controller gains
Ka = 0.7;
Kv = 1;

% Pump transfer function
w_hpu = 6;
zeta_hpu = 1;

% Valve transfer function
w_valve = 2*pi*50;
zeta_valve = 1;
deltap_valve_set = 15*1e5;

% Load motor-parameters
motor_param = readtable('motor_parameters.csv');

% Create table to save the results
number_simulations = 224;
sim_result.simulation_number(1:number_simulations) = 0;
sim_result.error_rms(1:number_simulations) = 0;
sim_result.flow_max(1:number_simulations) = 0;
sim_result.flow_rms(1:number_simulations) = 0;
sim_result.motor_cost(1:number_simulations) = 0;
sim_result.valve_cost(1:number_simulations) = 0;


sim_result_table = struct2table(sim_result)

model = 'heave_comp.slx';
%set_param(model, "DisplayErrorDirections", "false")
%Simulink.SuppressedDiagnostic(model)

idx = 1;
for number_of_motors = 1:2%1:8
    for number_of_valves = 2:2%1:4
        for motor_number = 6:6%1:motor_param.motor(end)
            % Setting varibles for simulation:
            Dm = motor_param.displacement(motor_number);
            nm = number_of_motors;
            nmax_motor = motor_param.max_rpm(motor_number);
            inertia_motor = motor_param.inertia(motor_number);
            nv = number_of_valves;

            % Simulate with the current parameters
            try
                result = sim(model);
                fprintf("Simulating...\n");    
                % Extractin position error and flow from simulation data
                % and calculating cost
                error = result.error.data(1,1, :);
                flow = result.pump_flow.data(1, 1, :);
                Cm = 2*nm*(1 + Dm/1000);
                Csv = 2.5*nv*(1 + 150/200);
            catch
                warning('Simulation failed, setting 401-not-found as values')
                error = 401;
                flow = 401;
                Cm = 401;
                Csv = 401;
            end

            idx = idx + 1;
        end
    end
end


% Non fixed parameters
%Dm = 28; % motor dispalcemant
%nm = 2; % Number of motors
%eta = 0.92;
%nmax_motor = 8000;
%inertia_motor = 0.0012;

%Cd = 0.7;
%Ad = 78/1e6; % m^2
%valve_max_stroke = 1.2/1000; %mm
%nv = 2; % Number of valves






