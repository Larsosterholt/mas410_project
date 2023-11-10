clc; clear; close all;

%load("montecarlo.mat");
%load("sim_data_tau_05.mat")
%load("sim_data_tau_05_p250.mat")
load("sim_data_tau_05_p280.mat")
data

setpoint = data{1}.extractTimetable;
setpointVel = data{10}.extractTimetable;
actual = data{3}.extractTimetable;
actualVel = data{9}.extractTimetable;
u = data{6}.extractTimetable;
flow = data{8}.extractTimetable;

fig1 = figure;
yyaxis left
plot(setpointVel.Time, setpointVel.Variables)
ylabel('Velocity [m/s]')
hold on
grid on
plot(actualVel.Time, actualVel.Variables, '--')
yyaxis right
plot(flow.Time, flow.Variables)
ylabel('Flow [L/m]')
xlabel('Time [s]')
legend('Setpoint', 'Actual')

% Calculating pump work
% idx_175 = 82706;
% idx_225 = 83749;
% dt = diff(flow.Time((idx_175):idx_225))
% flow_period = flow.("Transfer Fcn1")((idx_175):idx_225-1)/6e4
% pressure = 210*1e5;
% work = sum(pressure.*flow_period.*dt)

%% Plotting for the repport
W_frame = 16;     % Final width of the frame [cm] of the plot in your document
H_frame = 8;      % Final height of the frame [cm] of the plot in your document
LLC_frame = [5,5];% Position of lower left corner of the frame on the screen [cm]
W_axis = 14.5;    % Width of axis [cm]
H_axis = 6.7;     % Height of axis [cm]
LLC_axis = [1.25, 1.1]; % Position of lower left corner of the axes on the frame [cm]
xlabel_x = W_axis/2;% x-position of the x-label
xlabel_y = -0.6;  % y-position of the x-label [cm]
ylabel_x = -0.6;  % x-position of the y-label [cm]
ylabel_y = H_axis/2;% y-position of the y-label
AxisFontSize = 11;% Font size for axis text in the final plot in your document
LW1 = 1;          % Line width of lines on plot
LW2 = 2;          % Line width of lines on plot

%%

% Plotting position
 
fig = figure;           % Handle for the figure
ax = gca;               % Handle for the axis

fig.Units = 'centimeters';
fig.Position = [LLC_frame W_frame H_frame];


hold on
plt1 = plot(actual.Time, actual.Variables);
plt1.Color = [0 0.502 0.502];%'b';    % y, m, c, r, g, b, w, k,
plt1.LineWidth  = LW2;

plt2 = plot(setpoint.Time, setpoint.Variables);
plt2.Color = [0.5 0 0 1];%'r';
plt2.LineStyle = '--';
plt2.LineWidth = LW2;

ax.Units = 'centimeters';
ax.GridLineStyle = '--';             
ax.Position = [LLC_axis W_axis H_axis];
ax.FontName = 'Times New Roman';
ax.FontSize = AxisFontSize;             % Specified above
label_y = ylabel('Position [m]');
label_y.Units = "centimeters";
label_y.Position = [ylabel_x, ylabel_y];




label_x = xlabel('Time, [s]');
label_x.Units = "centimeters";
label_x.Position = [xlabel_x, xlabel_y];

leg = legend('Actual position', 'Setpoint');
leg.Location = "southwest";

xlim([duration(0,0,0) duration(0,0,30)])

hold off
grid on
box on

%filename1 = 'plt_1_250.eps';
%saveas(fig,filename1, 'epsc');
%%

% Plotting velocity and flow
clear fig ax plt1 plt2 plt3

fig = figure;           % Handle for the figure
ax = gca;               % Handle for the axis

fig.Units = 'centimeters';
fig.Position = [LLC_frame W_frame+1.3 H_frame];


hold on
yyaxis left
plt1 = plot(actualVel.Time, actualVel.Variables);
plt1.Color = [0 0.502 0.502];%'b';    % y, m, c, r, g, b, w, k,
plt1.LineStyle = '-';
plt1.LineWidth  = LW2;

plt2 = plot(setpointVel.Time, setpointVel.Variables);
plt2.LineStyle = '--';
plt2.Color = [0.5 0 0 1];%'r';
plt2.LineWidth = LW2;

ax.Units = 'centimeters';
ax.GridLineStyle = '--';             
ax.Position = [LLC_axis W_axis H_axis];
ax.FontName = 'Times New Roman';
ax.FontSize = AxisFontSize;             % Specified above
%ax.XTick = 0:5:30;                    % Divisions on axes
%ax.YTick = -2:0.5:2;                    % Divisions on axes
%axis([0, 30, -2, 2]);
ax.YColor = [0.5 0 0 1];

label_y_l = ylabel('Velocity [m/s]');
label_y_l.Units = "centimeters";
label_y_l.Position = [ylabel_x, ylabel_y];
label_y_l.Color = [0.5 0 0 1];

yyaxis right
plt3 = plot(flow.Time, flow.Variables);
%plt3.Color = [0.5 0 0 1];%'r';
plt3.LineStyle = '-';
plt3.LineWidth = LW2;

ylabel('Flow [L/min]');
%label_y_r = ylabel('Flow [L/min]');
%label_y_r.Units = "centimeters";
%label_y_r.Position = [ylabel_x, ylabel_y];
%label_y_r.set("Position", "Right")


label_x = xlabel('Time, [s]');
label_x.Units = "centimeters";
label_x.Position = [xlabel_x, xlabel_y];

leg = legend('Actual velocity', 'Setpoint');
leg.Location = "northwest";

xlim([duration(0,0,0) duration(0,0,30)])


hold off
grid on
box on

%filename1 = 'plt_2_250.eps';
%saveas(fig,filename1, 'epsc');

%%
clear fig ax
% Plotting position and error
 
fig = figure;           % Handle for the figure
ax = gca;               % Handle for the axis

fig.Units = 'centimeters';
fig.Position = [LLC_frame W_frame+1.4 H_frame];

hold on
yyaxis left
plt1 = plot(actual.Time, actual.Variables);
plt1.Color = [0 0.502 0.502];%'b';    % y, m, c, r, g, b, w, k,
plt1.LineWidth  = LW2;

plt2 = plot(setpoint.Time, setpoint.Variables);
plt2.Color = [0.5 0 0 1];%'r';
plt2.LineStyle = '--';
plt2.LineWidth = LW2;

ax.Units = 'centimeters';
ax.GridLineStyle = '--';             
ax.Position = [LLC_axis W_axis H_axis];
ax.FontName = 'Times New Roman';
ax.FontSize = AxisFontSize;             % Specified above
label_y = ylabel('Position [m]');
label_y.Units = "centimeters";
label_y.Position = [ylabel_x, ylabel_y];


yyaxis right
plt3 = plot(setpoint.Time, (setpoint.Variables - actual.Variables)*1000);
%plt3.Color = [0.5 0 0 1];%'r';
plt3.LineStyle = '-';
plt3.LineWidth = LW2;

ylabel('Position error [mm]');

label_x = xlabel('Time, [s]');
label_x.Units = "centimeters";
label_x.Position = [xlabel_x, xlabel_y];

leg = legend('Actual position', 'Setpoint');
leg.Location = "northwest";

xlim([duration(0,0,0) duration(0,0,30)])

hold off
grid on
box on

%filename1 = 'plt_3_250.eps';
%saveas(fig,filename1, 'epsc');

%%
clear fig ax
% Plotting position and error
 
fig = figure;           % Handle for the figure
ax = gca;               % Handle for the axis

fig.Units = 'centimeters';
fig.Position = [LLC_frame W_frame+1.4 H_frame];


hold on
yyaxis left
plt1 = plot(u.Time, u.Variables);
%plt1.Color = [0 0.502 0.502];%'b';    % y, m, c, r, g, b, w, k,
plt1.LineWidth  = LW1;

%plt2 = plot(setpoint.Time, setpoint.Variables);
%plt2.Color = [0.5 0 0 1];%'r';
%plt2.LineStyle = '--';
%plt2.LineWidth = LW2;

ax.Units = 'centimeters';
ax.GridLineStyle = '--';             
ax.Position = [LLC_axis W_axis H_axis];
ax.FontName = 'Times New Roman';
ax.FontSize = AxisFontSize;             % Specified above
label_y = ylabel('Valve opening [-]');
label_y.Units = "centimeters";
label_y.Position = [ylabel_x, ylabel_y];
ylim([-1.1 1.1])

yyaxis right
plt3 = plot(setpoint.Time, (setpoint.Variables - actual.Variables)*1000);
%plt3.Color = [0.5 0 0 1];%'r';
plt3.LineStyle = '-';
plt3.LineWidth = LW1;

ylabel('Position error [mm]');

label_x = xlabel('Time, [s]');
label_x.Units = "centimeters";
label_x.Position = [xlabel_x, xlabel_y];

%leg = legend('Controller input', 'Position error');
%leg.Location = "northwest";

xlim([duration(0,0,0) duration(0,0,30)])

hold off
grid on
box on

%filename1 = 'plt_4_280.eps';
%saveas(fig,filename1, 'epsc');