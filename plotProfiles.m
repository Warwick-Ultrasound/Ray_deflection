function plotProfiles(R, v, n)
    r = linspace(-R, R, 1000);
    figure;
    plot(plug(r, R, v, n), r/1E-3);
    hold on;
    plot(laminar(r, R, v, n), r/1E-3);
    plot(turbulent(r, R, v, n), r/1E-3);
    hold off;
    xlabel("Velocity /ms^{-1}");
    ylabel("y /mm");
    legend("Plug", "Laminar", "Turbulent n="+string(n));
end