function drawPipe(R)
    yline([-1,1]*R/1E-3, 'LineWidth', 2);
    ylim(1.05*[-R, R]/1E-3);
end