# Ray_deflection

This repository accompanies an article submitted to Elsevier Flow MEasurement & Instrumentation linked here [ADD LINK].

The purpose of the code is to explore how different flow profiles effect the beam in an ultrasonic flowmeter, and what this means for the different ways of thinking about how the transit time difference arises.

# Summary

1. plug.m
2. laminar.m
3. turbulent.m
4. zero.m
5. calcRay.m
6. DeflectedRaysMain.m
7. plotRays.m
8. plotProfiles.m
9. profilesFigure.m

Files 1 to 3 are functions which take the radial coordinate and cross-section average flow velocity and return the velocity at the requested radial coordinate. File 4 is a fucntion which imitates the form of fucntions 1 to 3, but returns zero everywhere inside the pipe. 

File 5, calcRay, takes the angle of the zero flow ray, the flow speed and profile, the pipe dimensions, and the speed of sound in the liquid, and returns the (y,z) coordinates of the deflected ray following the mathematics detailed in the linked article. 

File 6 is the main script which uses calcray, along with all of the flow profiles, to produce the deflected rays figure in the article and calculate the hydraulic correction factors. 

Files 7 and 8 are used to plot the figures in file 6.

File 9 is used to create the figure of flow profiles found in the article.

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

## DeflectedRaysMain

A script which uses the functions above to calculate and plot the ray paths for the figure in the results section of the article. It then uses the endpoints of the different paths to calculate the hydraulic correction factor for 
each profile, and checks that the angle the ray exits the fluid is the same as the angle it enters it.

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
