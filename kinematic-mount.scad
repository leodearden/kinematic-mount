// Kinematic mount

// Tips:
//
//  The fixed and free plates are just examples. You can use the *_holes() modules
//   to adapt any suitable size and shape solids to be kinematically mounted 
//   to each other.
//
//  The spheres should probably be ball bearings, rather than custom made. Just
//   edit the sphere_raduius to match the balls you want to use. Epoxy them in 
//   place in the cups on the fixed_plate.
//
//  Bigger spheres will (other things being equal) give you a stiffer mount.
//
//  (So long as the flex in the plates stays negligable) using more widely spaced
//   spheres will give you a stiffer mount. Edit triangle_radius to change the 
//   sphere spacing.

// Conventions:
//  +ve Z is 'up'
//  +ve Y is 'right'
//
//  The origin is the centre of the mount, midway between the plates,
//   and also the centre of the circle the spheres lie on.

// Configuration: edit to meet your needs.

triangle_radius = 60; 
sphere_radius = 15;
// Good for an M8 bolt
centre_mount_hole_radius = 9/2;
// The space between the plates when the mount is engaged.
plate_gap = 2;
// The minimum thickness of any structure
min_thickness = 2;

// The clearance to leave for a inteference fit between parts
//  0.3 is suitable for a rough RepRap 3D print
//  0.05 is suitable for a high quality CNC mill
interference = 0.3;
// The clearance to leave for radial misalignment of the assembly
radial_clearance = 4;
// not used yet
//cutout_radius = 60;

// Derived variables go here
plate_thickness = sphere_radius + min_thickness ;
fixed_plate_top_z = -plate_gap / 2;
plate_edge_length = 2 * (triangle_radius + sphere_radius + min_thickness);
free_plate_bottom_z = -fixed_plate_top_z;

// 
module fixed_plate() {
	difference() {
		fixed_plate_solid();
		fixed_plate_holes();
	}
}

module fixed_plate_solid() {
	translate([0, 0, -plate_thickness/2 + fixed_plate_top_z])
		cube([plate_edge_length,
			   plate_edge_length,
				plate_thickness], center=true);
}

module fixed_plate_holes() {
	//tetrahedron();
	for ( angle = [0, 120, 240] ) {
		rotate([0, 0, angle])
			translate([triangle_radius, 0, 0])
				sphere(r = sphere_radius + interference);
	}	
	common_holes();
}

//module tetrahedron() {
//	polyhedron
//}

module free_plate() {
	difference() {
		free_plate_solid();
		free_plate_holes();
	}
}

module free_plate_solid() {
	translate([0, 0, plate_thickness - fixed_plate_top_z + free_plate_bottom_z])
		fixed_plate_solid();
}

module free_plate_holes() {
	for ( angle = [0, 120, 240] ) {
		rotate([0, 0, angle])
			translate([triangle_radius, 0, 0])
				rotate([45, 0, 0])
					cube([2*(sphere_radius + radial_clearance),
							2*sphere_radius,
							2*sphere_radius],
						  center = true);
	}
	common_holes();
}

module common_holes() {
	cylinder(h = 2 * (plate_thickness + interference) + plate_gap,
				r = centre_mount_hole_radius,
				center = true);
}

module spheres() {
	for ( angle = [0, 120, 240] ) {
		rotate([0, 0, angle])
			translate([triangle_radius, 0, 0])
				sphere(r=sphere_radius);
	}
}

module kinematic_mount() {
	#spheres();
	%fixed_plate();
	free_plate();
}

kinematic_mount();
//free_plate_holes();
