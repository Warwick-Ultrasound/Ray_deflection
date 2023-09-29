function drawTransducers(zeroRay, theta0, h, w)
    % Draws the transducers for a wetted meter. Takes zeroRay as the input
    % as this is an easy way to indicate where the transducers are supposed
    % to go. theta0 is the angle they're pitched over at and w and h are
    % the height and width.

    % start with top transducer
    xc = zeroRay.z(1);
    yc = zeroRay.y(1);
    x = [-w/2, w/2, w/2, -w/2]; % corners of a rectange centrered of xc,yc
    y = [h, h, 0, 0];
    rot = [cosd(theta0), -sind(theta0);
        sind(theta0), cosd(theta0)];
    for ii = 1:4
        newCoords = rot*[x(ii); y(ii)];
        x(ii) = newCoords(1);
        y(ii) = newCoords(2);
    end
    x = x+xc;
    y = y+yc;
    hold on;
    patch(x/1E-3, y/1E-3, [255, 224, 102]/255, 'LineWidth', 2);
    hold off

    % Now the bottom one
    xc = zeroRay.z(end);
    yc = zeroRay.y(end);
    x = [-w/2, w/2, w/2, -w/2]; % corners of a rectange centrered of xc,yc
    y = [0, 0, -h, -h];
    rot = [cosd(theta0), -sind(theta0);
        sind(theta0), cosd(theta0)];
    for ii = 1:4
        newCoords = rot*[x(ii); y(ii)];
        x(ii) = newCoords(1);
        y(ii) = newCoords(2);
    end
    x = x+xc;
    y = y+yc;
    hold on;
    patch(x/1E-3, y/1E-3, [255, 224, 102]/255, 'LineWidth', 2);
    hold off
end