// Kinematic mount

// Tips:
//
//  The fixed and free plates are just examples. Use the *_holes() modules 
//   in your own designs, to adapt any suitable size and shape solids to be 
//   kinematically mounted to each other.
//
//  The spheres should probably be ball bearings, rather than custom made. Just
//   edit the sphere_raduius to match the balls you want to use. Epoxy them in 
//   place in the cups on the fixed_plate.
//
//  Bigger spheres will (other things being equal) give you a stiffer mount.
//
//  (So long as the flex in the plates stays negligable) using more widely spaced
//   spheres will give you a stiffer mount. Pass a different triangle_r to change the 
//   sphere spacing.

// Conventions:
//  +ve Z is 'up'
//  +ve Y is 'right'
//
//  The origin is the centre of the mount, midway between the plates,
//   and also the centre of the circle the spheres lie on.

// Configuration: edit to meet yor needs or to modify the example.

triangle_radius = 60; 
sphere_radius = 15;
// Good for an M8 bolt
centre_mount_hole_radius = 9/2;
// The space between the plates when the mount is engaged.
plate_gap = 1;
// The minimum thickness of any structure
min_thickness = 2;

// The clearance to leave for a inteference fit between parts
//  0.3 is suitable for a rough RepRap 3D print
//  0.05 is suitable for a high quality CNC mill
interference = 0.3;
// The clearance to leave for radial misalignment of the assembly
radial_clearance = 4;

module fixed_plate(sphere_r, triangle_r, plate_t) {
	difference() {
		fixed_plate_solid(sphere_r, triangle_r, plate_t);
		fixed_plate_holes(sphere_r, triangle_r);
	}
}

module fixed_plate_solid(sphere_r, triangle_r, plate_t) {
	plate_edge_length = 2 * (triangle_r + sphere_r + min_thickness);
	translate([0, 0, -plate_t/2 - plate_gap/2])
		cube([plate_edge_length,
			   plate_edge_length,
				plate_t], center=true);
}

module fixed_plate_holes(sphere_r, triangle_r) {
	for ( angle = [0, 120, 240] ) {
		rotate([0, 0, angle])
			translate([triangle_r, 0, 0])
				//tetrahedron();
				sphere(r = sphere_r + interference);
	}	
}
//fixed_plate_holes(sphere_radius, triangle_radius);

// WRITEME
//module tetrahedron() {
//	polyhedron
//}

module free_plate(sphere_r, triangle_r, plate_t) {
	difference() {
		free_plate_solid(sphere_r, triangle_r, plate_t);
		free_plate_holes(sphere_r, triangle_r);
	}
}
//free_plate(sphere_radius, triangle_radius);

module free_plate_solid(sphere_r, triangle_r, plate_t) {
	translate([0, 0, plate_t + plate_gap])
		fixed_plate_solid(sphere_r, triangle_r, plate_t);
}

module free_plate_holes(sphere_r, triangle_r) {
	for ( angle = [0, 120, 240] ) {
		rotate([0, 0, angle])
			translate([triangle_r, 0, 0])
				rotate([45, 0, 0])
					// A triangular prisim would be better here.
					cube([2*(sphere_r + radial_clearance),
							2*sphere_r,
							2*sphere_r],
						  center = true);
	}
}
//free_plate_holes(sphere_radius, triangle_radius);

module common_holes(plate_t) {
	cylinder(h = 2 * (plate_t + interference) + plate_gap,
				r = centre_mount_hole_radius,
				center = true);
}

module spheres(sphere_r, triangle_r) {
	for ( angle = [0, 120, 240] ) {
		rotate([0, 0, angle])
			translate([triangle_r, 0, 0])
				sphere(r=sphere_r);
	}
}
//spheres(sphere_radius, triangle_radius);

module kinematic_mount(sphere_r, triangle_r) {
	#spheres(sphere_r, triangle_r);
       	plate_thickness = sphere_r + min_thickness;
	difference() {
		union() {
			%fixed_plate(sphere_r, triangle_r, plate_thickness);
			free_plate(sphere_r, triangle_r, plate_thickness);
		}
		common_holes(plate_thickness);
	}
}

kinematic_mount(sphere_radius, triangle_radius);
//free_plate_holes();
