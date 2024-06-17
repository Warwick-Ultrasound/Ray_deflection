# Ray_deflection

This repository accompanies an article submitted to Elsevier Flow Measurement & Instrumentation linked here [ADD LINK].

The purpose of the code is to explore how different flow profiles affect the beam in an ultrasonic flowmeter, and what this means for the different ways of thinking about how the transit time difference arises.

# Summary

1. plug.m
2. laminar.m
3. turbulent.m
4. zero.m
5. calcRay.m
6. DeflectedRaysClampOn.m
7. DeflectedRaysWetted.m
8. plotRays.m
9. drawTransducers.m
10. drawPipe.m
11. plotProfiles.m
12. profilesFigure.m

Files 1 to 3 are functions which take the radial coordinate and cross-sectional average flow velocity and return the velocity at the requested radial coordinate. File 4 is a function which imitates the form of functions 1 to 3, but returns zero everywhere inside the pipe. 

File 5, calcRay, takes the angle of the zero flow ray, the flow speed and profile, the pipe dimensions, and the speed of sound in the liquid, and returns the (y,z) coordinates of the deflected ray following the mathematics detailed in the linked article. 

Files 6 and 7 are the main scripts which use calcRay, along with all of the flow profiles, to produce the deflected rays figures in the article and calculate the hydraulic correction factors. 

Files 8-10 are functions which help to plot the various elements in the ray figures.

File 11 is used to plot the shapes of the profiles used in the main scripts DeflectedRaysClampOn.m and DeflectedRaysWetted.m

File 12 is used to create the figure of flow profiles found in the article.

This documentation will not attempt to go through the mathematics of how the rays are calculated, as those details are published in the article. It will instead go through how to use the code in some detail that cannot be included in the article. Below is the full documentation for the code provided.

# Documentation

## plug

```MATLAB
  v = plug(r, R, v_ave, ~)
```

Returns the axial velocity of a plug flow profile. Will return NaN outside the pipe, 0 at the pipe wall, and v_ave anywhere inside the pipe.

### Inputs:
- r: The radial coordinate, either a single one or a vector of them.
- R: The pipe interior radius.
- v_ave: The average velocity over the pipe cross-sectional area.
The 4th input is not used but is left there so that all profiles can use identical syntax. This input is used in the turbulent profile to specify the order n.

### Outputs:
- v: The radial velocity as the point or points specified in r.

## laminar

```MATLAB
  v = laminar(r, R, v_ave, ~)
```

Identical to plug, only returns the laminar flow profile instead of plug flow. Returns NaN outside the pipe.

## turbulent

```MATLAB
  v = turbulent(r, R, v_ave, n)
```

The same as for all of the above profile functions only the final input argument is now used. The exponent n can be specified to control how steep the velocity tail-off is near the wall. 

## zero

```MATLAB
  v = zero(r, R, ~, ~)
```

Similar to all of the other profiles, but it will always return zero inside the pipe and NaN outside. This is useful as it allows the calculation and plotting of the zero flow ray using existing code for the other flow profiles.

## calcray

```MATLAB
  rays = calcRay(theta0, v_ave, profile, R, c_l, N, n)
```

Calculates the path that the ultrasound ray would take through a given flow profile.

### Inputs: 
- theta0: The angle between the pipe normal and the ray in the water at zero flow.
- v_ave: The average flow velocity over the pipe cross-section.
- profile: A function handle to one of the flow profiles above (or your own, following the same form), e.g. @laminar
- R: The interior radius of the pipe.
- c_l: The speed of sound in the fluid.
- N: The number of points to evaluate the ray coordinates at.
- n: Order of the turbulent flow profile, if using. Otherwise, it is an optional argument.

### Outputs:
- rays: A struct containing two fields: y and z - these are the vectors of coordinates for plotting the ray.

## DeflectedRaysClampOn

A script which uses the functions above to calculate and plot the ray paths for the figure in the results section of the article. It then uses the endpoints of the different paths to calculate the hydraulic correction factor for 
each profile, and checks that the angle the ray exits the fluid is the same as the angle it enters it.

## DeflectedRaysWetted

Similar to DeflectedRaysClampOn but for a meter with wetted transducers, so slightly different method for calculating the correction factors and a different plot.

## plotRays

```MATLAB
  h = plotRays(rays, DisplayName)
```

Plots the ray struct that is produced by calcRays.

### Inputs:
- rays: The struct containing ray coordinates from calcRays.
- DisplayName (Optional): Sets the 'DisplayName' property to help with using legends.

### Outputs:
- h: The axes handle to the plot line.

## drawTransducers

```MATLAB
  drawTransducers(zeroRay, theta0, h, w)
```

Draws the rectangles representing the transducers in the correct location for the wetted meter.

### Inputs:
- zeroRay: Struct representing the zero flow ray between the two transducers. Returned by calcRay with v = 0, but should be passed through the function z_path defined in DeflectedRaysWetted first to get the Z path rather than the V path.
- theta0: The angle between the normal to the transducers and the vertical.
- h: The height of the transducers.
- w: The width of the transducers.

## drawPipe

```MATLAB
  drawPipe(zeroRay,theta0, w, R, xlims)
```

Draws the pipe for the meter with wetted sensors. This is nontrivial as cutouts need to be left for the sensors.

### Inputs:

- zeroRay: Struct representing the zero flow ray between the two transducers. Returned by calcRay with v = 0, but should be passed through the function z_path defined in DeflectedRaysWetted first to get the Z path rather than the V path.
- theta0: The angle between the normal to the transducers and the vertical.
- R: The pipe interior radius.
- xlims: The horizontal coordinates to which the lines representing the pipe walls will be extended.

## plotProfiles

```MATLAB
  plotProfiles(R, v, n)
```

Plots the plug, laminar and turbulent profiles.

### Inputs:
- R: Pipe interior radius.
- v: Average velocity over pipe cross-section.
- n: Order for the turbulent profile.

## profilesFigure

A script which plots the figure in the theory section to illustrate the differences between different flow profiles. 
