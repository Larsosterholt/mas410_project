clc; clear; close all;

%global zw Tw fw nsh ig mpl dD dR dp mu_eq w0 g


% Pump transfer function
w_hpu = 6;





gains_0 = [8; 0; 0.66667; 1];
upperBound = [20; 20; 20; 2];
lowerBound = [0; 0; 0; 0];

result = costFun(gains_0)

function cost = costFun(gains)
%global rho g w_valve zeta_valve deltap_valve_set Dm nm
%global nmax_motor inertia_motor Ad nv J n utmost_controller_Kp
%global utmost_controller_Kd inner_controller_Kp Kv

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
Dm = 28; % motor dispalcemant
nm = 2; % Number of motors
eta = 0.92;
nmax_motor = 8000;
inertia_motor = 0.0012;
Cd = 0.7;
%Ad = (100/6e4)/(Cd*sqrt(2/875*(70*1e5)/2));
Ad = (150/6e4)/(Cd*sqrt(2/875*(70*1e5)/2));
%Ad = (200/6e4)/(Cd*sqrt(2/875*(70*1e5)/2));
nv = 3; % Number of valves


% Calculating gear ratio between wire and motor
n = 1/((dD*dp)/(2*nsh*dR*2*ig));%ig*(dR/dp)/(dD/2)*(nsh)

% Calculating load inertia expeienced by the motor(s)
J = mpl*(dD/2)^2*(1/n)^2;

% Extract controller gains for the simulation
utmost_controller_Kp = gains(1);
utmost_controller_Kd = gains(2);
inner_controller_Kp = gains(3);
Kv = gains(4);

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
