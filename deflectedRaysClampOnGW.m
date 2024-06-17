%{
Main script for calculating the deflected rays in a clamp-on
V-configuration guided wave ultrasonic TTD flow meter. This uses the
principle from Kiefer's paper 10.1109/TUFFC.2022.3201106.
%}

clear;
clc;
close all;

% INPUTS
v_ave = 1; % pipe average flow velocity
R = 30E-3; % Interior radius of pipe
c_l = c_water(20); % speed of sound in liquid
GW.cp = 3998; % guided wave phase velocity
GW.cg = 2305; % guided wave group velocity
N = 1000; % Number of points to calculate rays at
n = 8; % order of turbulent profile

% plot profiles
plotProfiles(R, v_ave, n);

% Calculate Rays
theta0 = asind(c_l/GW.cp); % Lamb angle into water for guided wave mode
zeroRays = calcRay(theta0, v_ave, @zero, R, c_l, N, n);
plugRays = calcRay(theta0, v_ave, @plug, R, c_l, N, n);
lamRays = calcRay(theta0, v_ave, @laminar, R, c_l, N, n);
turbRays = calcRay(theta0, v_ave, @turbulent, R, c_l, N, n);

% Plot Image
figure;
h(1) = plotRays(zeroRays, 'Zero Flow');
hold on;
h(2) = plotRays(plugRays, 'Plug');
h(3) = plotRays(lamRays, 'Laminar');
h(4) = plotRays(turbRays, 'Turbulent, $n=8$');
yline([-1,1]*R/1E-3, 'LineWidth', 2);
hold off;
set(gca, 'FontName', 'Times', 'FontSize', 14);
legend(h, 'Location', 'southeast', 'Interpreter', 'latex');
xlabel("$z$ /mm", 'Interpreter', 'latex');
ylabel("$y$ /mm", 'Interpreter', 'latex');

% calculate TTDs
d_lam = lamRays.z(end) - zeroRays.z(end); % distance along z due to flow
d_turb = turbRays.z(end) - zeroRays.z(end);
d_plug = plugRays.z(end) - zeroRays.z(end);
dt_lam = 2*(d_lam/GW.cg); % TTD
dt_turb = 2*(d_turb/GW.cg);
dt_plug = 2*(d_plug/GW.cg);

% calculate correction factors
k_lam = dt_plug/dt_lam;
k_turb = dt_plug/dt_turb;

disp("Laminar k = "+string(k_lam));
disp("Turbulent k = "+string(k_turb));