function h = plotRays(rays, varargin)
    if nargin
        h = plot(rays.z/1E-3, rays.y/1E-3, "DisplayName", varargin{1}, 'LineWidth', 1.5);
    else
        h = plot(rays.z/1E-3, rays.y/1E-3, 'LineWidth', 1.5);
    end
end