clc; clear; close all;

%global zw Tw fw nsh ig mpl dD dR dp mu_eq w0 g
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

% Pump transfer function
w_hpu = 6;
zeta_hpu = 1;

% Valve transfer function
w_valve = 2*pi*50;
zeta_valve = 1;
deltap_valve_set = 15*1e5;

% Non fixed parameters
Dm = 100; % motor dispalcemant
nm = 2; % Number of motors
eta = 0.92;

Cd = 0.7;
Ad = 40/1e6; % m^2
nv = 2; % Number of valves

Dmax = 50; % cm^3/ref
np = 2;
nmaxp = 2700;