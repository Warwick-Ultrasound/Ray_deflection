%{
Have done the maths more rigorously for the deflected rays, so want to
start constructing some better code so it can be provided with the paper,
plus check that the results match up.
%}

clear;
clc;
close all;

theta_T = 38; % transducer wedge angle
v_ave = 500; % pipe average flow velocity
R = 30E-3; % Interior radius of pipe
c_l = c_water(20); % speed of sound in liquid
c_T = c_PEEK(20); % speed of sound in transducer wedge % ADD PROPER FN FOR THIS
theta0 = asind( c_l/c_T*sind(theta_T) ); % angle into water
N = 1000; % Number of points to calculate rays at
n = 8; % order of turbulent profile

% plot profiles
plotProfiles(R, v_ave, n);

% Calculate Rays
zeroRays = calcRay(theta0, v_ave, @zero, R, c_l, N, n);
plugRays = calcRay(theta0, v_ave, @plug, R, c_l, N, n);
lamRays = calcRay(theta0, v_ave, @laminar, R, c_l, N, n);
turbRays = calcRay(theta0, v_ave, @turbulent, R, c_l, N, n);

% Plot Image
figure;
%drawPipe(R);
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
%title("Flow Velocity = "+string(v_ave)+" m/s");

% CALCULATE CORRECTION FACTORS

% distance along axis compared to zero flow
d_plug = plugRays.z(end) - zeroRays.z(end);
d_lam = lamRays.z(end)- zeroRays.z(end);
d_turb = turbRays.z(end) - zeroRays.z(end);

% time difference measured between upstream and downstream
dt_plug = 2*d_plug*sind(theta_T)/c_T;
dt_lam = 2*d_lam*sind(theta_T)/c_T;
dt_turb = 2*d_turb*sind(theta_T)/c_T;

% use TTDs to measure flow rate with each profile
D = 2*R; % ID of pipe
v_plug = c_l^2*dt_plug/(4*D*tand(theta0));
v_lam = c_l^2*dt_lam/(4*D*tand(theta0));
v_turb = c_l^2*dt_turb/(4*D*tand(theta0));

% Now finally get FPCF
F_plug = v_ave/v_plug;
F_lam = v_ave/v_lam;
F_turb = v_ave/v_turb;

% Print axial distance covered
disp("___Extra Axial Distance Covered /mm___");
disp("Plug: "+string(plugRays.z(end)/1E-3 - zeroRays.z(end)/1E-3));
disp("Laminar: "+string(lamRays.z(end)/1E-3 - zeroRays.z(end)/1E-3));
disp("Turbulent: "+string(turbRays.z(end)/1E-3 - zeroRays.z(end)/1E-3));

disp(' ');
disp('___Hydraulic Correction Factors___');
disp('Laminar: '+string(F_lam));
disp('Turbulent: '+string(F_turb));

disp(' ');
disp("___Angle into pipe wall /deg___");
disp("Zero Flow: "+string(findAngle(zeroRays)));
disp("Plug: "+string(findAngle(plugRays)));
disp("Laminar: "+string(findAngle(lamRays)));
disp("Turbulent: "+string(findAngle(turbRays)));

function theta = findAngle(rays)
    x = rays.z;
    y = rays.y;
    dx = x(end) - x(end-1);
    dy = y(end) - y(end-1);
    theta = atand(dx/dy);
end