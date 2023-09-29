function drawPipe(zeroRay,theta0, w, R, xlims)
    % This function draws the pipe for the wetted meter with the cutouts
    % for the transducers
    
    % Draw horizontal lines between xlims with gaps for transducers
    dx = w/(2*cosd(theta0)); % distance between centre of transducer and interscetion with pipe wall
    gap = [0-dx, 0+dx]; % where the gap is in the top line
    line([xlims(1), gap(1)]/1E-3, [1, 1]*R/1E-3, 'Color', 'k', 'LineWidth', 2); % left section
    line([gap(2), xlims(2)]/1E-3, [1, 1]*R/1E-3, 'Color', 'k', 'LineWidth', 2); % right section

    centre = zeroRay.z(end); % x coord of middle of bottom transducer
    gap = [centre-dx, centre+dx];
    line([xlims(1), gap(1)]/1E-3, [1, 1]*-R/1E-3, 'Color', 'k', 'LineWidth', 2); % left section
    line([gap(2), xlims(2)]/1E-3, [1, 1]*-R/1E-3, 'Color', 'k', 'LineWidth', 2); % right section

    % Draw sloped parts to close pipe
    xoff = w/2*cosd(theta0); % dist between centre of face and transducer corner in x
    yoff = w/2*sind(theta0); % same for y
    line([xoff, dx]/1E-3, [R+yoff, R]/1E-3, 'Color', 'k', 'LineWidth', 2);

    xoff = w/(2*cosd(theta0));
    yoff = w/2*sind(theta0);
    line([centre-xoff, centre-w/2*cosd(theta0)]/1E-3, [-R, -R-yoff]/1E-3, 'Color', 'k', 'LineWidth', 2);

end