This is an OpenSCAD library for generating kinematic mounts.

These mounts will be especially appropriate for high precision applications with low to moderate load, such as 3D printer print heads, laser optics, and possibly high speed light machining systems (eg: circuit routers).

Use:

Configure the mount dimensions by editing the .scad file. Use openscad to generate an STL. Print or machine the parts to make the mount.

See the comments in the .scad file for construction details.

Background:

A kinematic mechanical system is constrained by exactly the minimum number of points of contact required for it to have the desired number of degrees of freedom.

This tends to give these systems very predictable repeatable mechanical behaviour, even when made with innacurately. This makes them appropriate for high precision machines. Other things being equal, kinematic systems also tend to be less rigid than overconstrained systems, which tends to make them innapropriate for heavy duty machine tools such as mills and lathes.

A kinematic mount is not intended to move. With totally inelastic materials it would be totally rigid. It uses six points of contact, between three spheres and three mating V-grooves, to achieve this.