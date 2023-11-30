clc; clear; close all;


load("man_gain_2.mat")
data
%%

setpoint = data{1}.extractTimetable;
%setpointVel = data{10}.extractTimetable;
actual = data{3}.extractTimetable;
actualVel = data{10}.extractTimetable;
u = data{6}.extractTimetable;
flow = data{9}.extractTimetable;
work = data{5}.extractTimetable;

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
clear fig ax
% Plotting position and error
 
fig = figure;           % Handle for the figure
ax = gca;               % Handle for the axis

fig.Units = 'centimeters';
fig.Position = [LLC_frame W_frame+1.4 H_frame];


hold on
yyaxis left
plt1 = plot(flow.Time, flow.Variables);
%plt1.Color = [0 0.502 0.502];%'b';    % y, m, c, r, g, b, w, k,
plt1.LineWidth  = LW1;
plt1.LineStyle = '-';

%plt2 = plot(setpoint.Time, setpoint.Variables);
%plt2.Color = [0.5 0 0 1];%'r';
%plt2.LineStyle = '--';
%plt2.LineWidth = LW2;

ax.Units = 'centimeters';
ax.GridLineStyle = '--';             
ax.Position = [LLC_axis W_axis H_axis];
ax.FontName = 'Times New Roman';
ax.FontSize = AxisFontSize;             % Specified above
label_y = ylabel('HPU flow [L/min]');
label_y.Units = "centimeters";
label_y.Position = [ylabel_x, ylabel_y];
%ylim([-1.1 1.1])

yyaxis right
plt3 = plot(work.Time, work.Variables/1000);
%plt3.Color = [0.5 0 0 1];%'r';
plt3.LineStyle = '-';
plt3.LineWidth = LW1;

ylabel('Work [kJ]');

label_x = xlabel('Time, [s]');
label_x.Units = "centimeters";
label_x.Position = [xlabel_x, xlabel_y];

%leg = legend('Controller input', 'Position error');
%leg.Location = "northwest";

xlim([duration(0,0,0) duration(0,0,30)])

hold off
grid on
box on


%filename1 = ['man_tune_plt_1_work_flow.eps'];
%saveas(fig,filename1, 'epsc');