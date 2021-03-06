This repository includes a seismic migration routine for Common Offset Gathers using a Kirchhoff depth migration. It is written in MatLab code.
This routine was an assignment for a university class and of course is highly specific. However, it may (of course) be adapted to other uses, within the limits of the license.

## COmig.m
This is the main routine that will load the data do some data conditioning and then call the migration routine.

Our data set is a CO slice so it is quite small. We will iterate through different migration velocities and hence, scan for the final migration velocity.

## CO_kirch_time.m
Function for time migration and then interpolation to depth. This was our first try. It is however non-functional as of now. Fixes may be implemented later.

## CO_kirch_depth.m
Proper depth migration with interpolation to a discretized depth grid.

## mig_graphs.m
Several imaging functions for seismic images. The output of a migrated and stacked image may look like this:

v_mig = 2250 m/s
![Common Offset Gather at 2250](output/COGv2250.png)

v_mig = 2750 m/s
![COG at 2750](output/COGv2750.png)