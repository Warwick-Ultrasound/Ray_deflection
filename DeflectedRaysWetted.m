%{
This is a script which repeats the clamp-on calculation of ray deflection
for the case of wetted sensors. The way the rays are calculated is the
same, but the hydraulic correction factor calculation is a bit different as
we now have to find where it intersects with the sloped transducer face.
%}

clear;
clc;
close all;

theta_T = 38; % transducer wedge angle
v_ave = 500; % pipe average flow velocity
R = 30E-3; % Interior radius of pipe
c_l = c_water(20); % speed of sound in liquid
c_T = c_PEEK(20); % speed of sound in transducer wedge
theta0 = asind( c_l/c_T*sind(theta_T) ); % angle into water
N = 10000; % Number of points to calculate rays at
n = 7; % order of turbulent profile

% plot profiles
plotProfiles(R, v_ave, n);

% Calculate Rays
zeroRays = z_path(calcRay(theta0, v_ave, @zero, R, c_l, N, n));
plugRays = z_path(calcRay(theta0, v_ave, @plug, R, c_l, N, n));
lamRays = z_path(calcRay(theta0, v_ave, @laminar, R, c_l, N, n));
slowLam = z_path(calcRay(theta0, v_ave/5, @laminar, R, c_l, N, n));
turbRays = z_path(calcRay(theta0, v_ave, @turbulent, R, c_l, N, n));

% Dimensions for drawing
h = 60E-3; % height of transducer body
w = 60E-3; % width of transducer body
xlims = [-80, 60]*1E-3; % x limits for drawing pipe

% Plot paths
figure;
ha(1) = plotRays(zeroRays, 'Zero Flow');
hold on;
ha(2) = plotRays(slowLam, 'Laminar, $v ='+string(v_ave/5)+"$~ms\textsuperscript{-1}");
ha(3) = plotRays(plugRays, 'Plug, $v ='+string(v_ave)+"$~ms\textsuperscript{-1}"');
ha(4) = plotRays(lamRays, 'Laminar, $v ='+string(v_ave)+"$~ms\textsuperscript{-1}");
ha(5) = plotRays(turbRays, 'Turbulent, $n='+string(n)+'$ , $v ='+string(v_ave)+"$~ms\textsuperscript{-1}");
drawPipe(zeroRays,theta0, w, R, xlims);
hold off;
drawTransducers(zeroRays, theta0, h, w);
set(gca, 'FontName', 'Times', 'FontSize', 14);
legend(ha, 'Location', 'west', 'Interpreter', 'latex');
legend('boxoff');
xlabel("$z$ /mm", 'Interpreter', 'latex');
ylabel("$y$ /mm", 'Interpreter', 'latex');
ylim([-1 1]*1.4*R/1E-3);
% set aspect ratio
xl = xlim;
yl = ylim;
set(gca, 'PlotBoxAspectRatio', [diff(xl), diff(yl), 1]);

% calculate line for reception transducer face
face = @(x) tand(theta0)*x - R - 2*R*tand(theta0)^2;

% find intersections
plug_yc = findCross(plugRays, face);
lam_yc = findCross(lamRays, face);
turb_yc = findCross(turbRays, face);

% vertical distances as described in article
plug_dy = plug_yc + R;
lam_dy = lam_yc + R;
turb_dy = turb_yc + R;

% calculated velocities
plug_v = c_l*plug_dy/(2*R*tand(theta0)*cosd(theta0));
lam_v = c_l*lam_dy/(2*R*tand(theta0)*cosd(theta0));
turb_v = c_l*turb_dy/(2*R*tand(theta0)*cosd(theta0));

% correction factors
k_plug = v_ave/plug_v;
k_lam = v_ave/lam_v;
k_turb = v_ave/turb_v;

disp("--------Calculated Correction Factors----------");
disp("Plug flow: "+string(k_plug));
disp("Laminar flow: "+string(k_lam));
disp("Turbulent flow: "+string(k_turb));

disp("--------Expected Correction Factors------------");
disp("Plug flow: 1");
disp("Laminar flow: 0.750");
disp("Turbulent flow: "+string(2*n/(2*n+1)));

function rays = z_path(rays)
    % calcRays is set up to calculatefor a V-path, so this function cuts
    % that path in half for Z path meters. This aproach keeps the calcRays
    % function from having an extra input just for this purpose, at the
    % expense of a bit of extra computation.
    rays.z = rays.z(1:end/2);
    rays.y = rays.y(1:end/2);
end
function yc = findCross(ray, line)
    % Finds the y height of the point where a ray intersects with a line.
    x = ray.z;
    y = ray.y;
    for ii = 1:length(x)
        if y(ii) < line(x(ii))
            ray = fit(x(ii-1:ii).', y(ii-1:ii).', 'poly1');
            face = fit(x(ii-1:ii).', line(x(ii-1:ii)).', 'poly1');
            ray = coeffvalues(ray);
            face = coeffvalues(face);

            yc = (ray(2)-ray(1)/face(1)*face(2))/(1-ray(1)/face(1));
            return;
        end
    end
end