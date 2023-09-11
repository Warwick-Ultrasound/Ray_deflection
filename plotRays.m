function h = plotRays(rays, varargin)
    if nargin
        h = plot(rays.z/1E-3, rays.y/1E-3, "DisplayName", varargin{1});
    else
        h = plot(rays.z/1E-3, rays.y/1E-3);
    end
end