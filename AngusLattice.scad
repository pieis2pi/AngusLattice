// Angus' Lattice OpenSCAD
// 2016 by Evan Thomas
/* 
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE":
 * <pieis2pi@u.washington.edu> wrote this file.  As long as you retain this
 * notice you can do whatever you want with this stuff. If we meet some day,
 * and you think this stuff is worth it, you can buy me a beer in return.
 * -Evan Thomas
 * ----------------------------------------------------------------------------
 */
diameter = 2;
side_length = 40.0;
side_number = 3;
lattice_number = 2;
base_height=1.0;
base_scale=1.5;
hole = false; // hole for little light.
$fn = 30;
angle = asin(1/sqrt(3)); // angle to roatate to get isometric perspective.
// In terms of the above the height of the final object is:
// height = length/side_number*sin(angle)*(3*side_number-1)+diameter;
// If you want to define height rather than side length, you can instead put in:
// height = whatever;
// side_length = (height-diameter)*side_number/sin(angle)/(3*side_number-1);
length = side_length-diameter; // one extra radius on each side of the cube.

module lattice(length,number,diameter){
	spacing=length/number;
	for(i=[0:number])
		for(j=[0:number]){
			hull(){
				translate([0,i*spacing,j*spacing])
					sphere(d=diameter);
				translate([length,i*spacing,j*spacing])
					sphere(d=diameter);}
			hull(){
				translate([j*spacing,0,i*spacing])
					sphere(d=diameter);
				translate([j*spacing,length,i*spacing])
					sphere(d=diameter);}
			hull(){
				translate([i*spacing,j*spacing,0])
					sphere(d=diameter);
				translate([i*spacing,j*spacing,length])
					sphere(d=diameter);}}
}

union(){
	difference(){
		translate([0,0,-length/side_number*sin(angle)+base_height])
			for(i=[1:lattice_number])
				rotate([45,-angle,(i-1)*120/lattice_number])
					lattice(length,side_number,diameter);
		translate([0,0,-length/side_number*sin(angle)])
			cylinder(h=length/side_number*sin(angle),
						d=2*length/side_number*cos(angle)*base_scale);}
	if(hole)
		difference(){
			cylinder(h=base_height,d=2*length/side_number*cos(angle)*base_scale);
			cylinder(h=base_height,d=2*length/side_number*cos(angle)/base_scale);}
	else
		cylinder(h=base_height,d=2*length/side_number*cos(angle)*base_scale);}