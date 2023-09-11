function rays = calcRay(theta0, v_ave, profile, R, c_l, N, varargin)
    % input arguments:
    %
    % theta0: angle of ray when water is at rest
    % v_ave: pipe average flow velocity
    % profile: function handle for flow profile
    % R: pipe ID/2
    % c_l: speed of sound in liquid
    % N: Number of points required
    % n: order of turbulent profile, if using

    if nargin
        n = varargin{1};
    end
    if mod(N,2) ~= 0
        error("N must be even");
    end
    
    % calculate y coords for the v-path
    y = linspace(R, -R, N/2);
    y = [y, flip(y)]; % there and back again
    dy = abs(y(2)-y(1));

    % now loop through them calculating z
    z = zeros(size(y));
    z(1) = 0; % start at z=0
    for ii = 2:length(y)
        % local velocity
        v = profile(y(ii), R, v_ave, n);
        theta_f = atand( tand(theta0) + v/(c_l*cosd(theta0)));
        z(ii) = z(ii-1) + dy*tand(theta_f);
    end
    rays.z = z;
    rays.y = y;
end