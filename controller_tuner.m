clc; clear; close all;



gains_0 = [8, 0, 0.66667, 0, 0];
upperBound = [20, 20, 20, 2, 2];
lowerBound = [0, 0, 0, -2, -2];
A = [];
B = [];
Aeq = [];
beq = [];
nonlcon = [];
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
%  'interior-point'
%gains = fmincon(@costFun, gains_0, A, B, Aeq, beq, lowerBound, upperBound, nonlcon, options)


%[utmost_controller_Kp, utmost_controller_Kd, inner_controller_Kp, Kv_pos, Kv_neg]
optimal_gain = [12.1176 0.0000 0.4409 -0.6268 0.3420]; % Gains from fmincon
my_gain = [8 0 1.5 1 1] % Manually tuned gains
error_RMS = costFun(optimal_gain)



function cost = costFun(gains)
% Fixed parameters
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

% Valve transfer function
w_valve = 2*pi*50;
zeta_valve = 1;
deltap_valve_set = 15*1e5;

% Non fixed parameters, corresponding to the choise of sytem
Dm = 4.93; % motor dispalcemant
nm = 5; % Number of motors
eta = 0.92;
nmax_motor = 8000;
inertia_motor = 0.0012;
Cd = 0.7;
%Ad = (100/6e4)/(Cd*sqrt(2/875*(70*1e5)/2));
%Ad = (150/6e4)/(Cd*sqrt(2/875*(70*1e5)/2));
Ad = (200/6e4)/(Cd*sqrt(2/875*(70*1e5)/2));
nv = 1; % Number of valves


% Calculating gear ratio between wire and motor
n = 1/((dD*dp)/(2*nsh*dR*2*ig));%ig*(dR/dp)/(dD/2)*(nsh)

% Calculating load inertia expeienced by the motor(s)
J = mpl*(dD/2)^2*(1/n)^2;

% Extract controller gains for the simulation
utmost_controller_Kp = gains(1);
utmost_controller_Kd = gains(2);
inner_controller_Kp = gains(3);
Kv_pos = gains(4);
Kv_neg = gains(5);


% Simulation
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
cost = rms(error);
end
