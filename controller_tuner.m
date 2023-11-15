clc; clear; close all;
% [utmost_controller_Kp, utmost_controller_Kd, inner_controller_Kp, Kv_pos, Kv_neg]

% Initial gains:
gains_0 = [16 0 750 1 1]; 
gains_1 = [40 0 650 1 1]; 
gains_2 = [40 0 650 0 0]; 


upperBound = [100, 20, 1000, 10, 10];
lowerBound = [0, 0, 0, -10, -10];
A = [];
B = [];
Aeq = [];
beq = [];
nonlcon = [];

% Optimizing
%options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
% options = optimoptions('fmincon','Display','iter'); % Defalt optimizer
% gains0_optimized = fmincon(@costFun, gains_0, A, B, Aeq, beq, lowerBound, upperBound, nonlcon, options)
% save('tuner_results\gains0_max.mat', "gains0_optimized");
% gains1_optimized = fmincon(@costFun, gains_1, A, B, Aeq, beq, lowerBound, upperBound, nonlcon, options)
% save('tuner_results\gains1_max.mat', "gains1_optimized");
% gains2_optimized = fmincon(@costFun, gains_2, A, B, Aeq, beq, lowerBound, upperBound, nonlcon, options)
% save('tuner_results\gains2_max.mat', "gains2_optimized");

% For testing
gains_0 = [40 0 650 1 1]; 
error_RMS = costFun(gains_0)

%% Cost function
function cost = costFun(gains)
% Fixed parameters
nsh = 2; % Number of sheaves
ig = 11; % [-]
mpl = 18000; % kg
dD = 0.45; % m
dR = 0.5; % m
dp = 0.15; % m
g = 9.81;

% Valve transfer function
w_valve = 2*pi*50;
zeta_valve = 1;
deltap_valve_set = 15*1e5;

% Non fixed parameters, corresponding to the choise of sytem
Dm = 16;% % motor dispalcemant
nm = 5; % Number of motors
eta = 0.92;
nmax_motor = 8000;
inertia_motor = 0.0004;
Cd = 0.7;
Ad = (200/6e4)/(Cd*sqrt(2/875*(70*1e5)/2));
nv = 4; % Number of valves

% Calculating gear ratio between wire and motor
n = 1/((dD*dp)/(2*nsh*dR*2*ig));

% Calculating load inertia expeienced by the motor(s)
J = mpl*(dD/2)^2*(1/n)^2;

% Extract controller gains for the simulation
utmost_controller_Kp = gains(1);
utmost_controller_Kd = gains(2);
inner_controller_Kp = gains(3);
Kv_pos = gains(4);
Kv_neg = gains(5);

% Assigning parameter and controller gains to simulink model
modelname = 'heave_comp_controler_tuner';
hws = get_param(modelname, 'modelworkspace');
list = whos;   % Get the list of variables defined in the function
N = length(list);
% Assign everything in the model workspace
for  i = 1:N
    hws.assignin(list(i).name,eval(list(i).name));
end

% Simulating and returning cost
result = sim('heave_comp_controler_tuner.slx');
error = result.error.data(1,1, :);
%cost = max(abs(error))*1000 
cost = rms(error)*1000;
end
