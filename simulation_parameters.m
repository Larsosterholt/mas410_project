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

% Non fixed parameters
Dm = 100; % motor dispalcemant
nm = 2; % Number of motors
eta = 0.92;

Cd = 0.7;
Ad = 40/1e6; % m^2
nv = 2; % Number of valves