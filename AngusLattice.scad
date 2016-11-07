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
bar_type = "dodeca";
diameter = 2;
side_length = 40.0;
side_number = 3;
lattice_number = 2;
base_height=1.0;
base_scale=1.5;
hole = false; // hole for little light.
angle = asin(1/sqrt(3)); // angle to roatate to get isometric perspective.
// In terms of the above the height of the final object is:
// height = length/side_number*sin(angle)*(3*side_number-1)+diameter;
// If you want to define height rather than side length, you can instead put in:
// height = whatever;
// side_length = (height-diameter)*side_number/sin(angle)/(3*side_number-1);
length = side_length-diameter; // one extra radius on each side of the cube.

module dodecahedron(height)	// This module taken from OpenSCAD User Manual
{					// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Print_version
	scale([height,height,height]){	//scale by height parameter
		intersection(){	//make a cube
			cube([2,2,1], center = true); 
				intersection_for(i=[0:4]){	//loop i from 0 to 4, and intersect results
		//make a cube, rotate it 2*atan((1+sqrt(5))/2) degrees around the X axis,
		//then 72*i around the Z axis
					rotate([0,0,72*i])
						rotate([2*atan((1+sqrt(5))/2),0,0])
							cube([2,2,1], center = true);}}}}

module basic_shape(type,diameter){
	if(type=="sphere")
		sphere(d=diameter,$fn=30);
	else if (type=="cube")
		cube(size=diameter,center=true);
	else if (type=="dodeca")
		dodecahedron(height=diameter);
}	// dodecahedron looks great except for top point.
		

module lattice(type,length,number,diameter){
	spacing=length/number;
	for(i=[0:number])
		for(j=[0:number]){
			hull(){
				translate([0,i*spacing,j*spacing])
					 basic_shape(type,diameter);
				translate([length,i*spacing,j*spacing])
					 basic_shape(type,diameter);}
			hull(){
				translate([j*spacing,0,i*spacing])
					basic_shape(type,diameter);
				translate([j*spacing,length,i*spacing])
					basic_shape(type,diameter);}
			hull(){
				translate([i*spacing,j*spacing,0])
					basic_shape(type,diameter);
				translate([i*spacing,j*spacing,length])
					basic_shape(type,diameter);}}
}

union(){
	difference(){
		translate([0,0,-length/side_number*sin(angle)+base_height])
			for(i=[1:lattice_number])
				rotate([45,-angle,(i-1)*120/lattice_number])
					lattice(bar_type,length,side_number,diameter);
		translate([0,0,-length/side_number*sin(angle)-diameter])
			cylinder(h=length/side_number*sin(angle)+diameter,
						d=2*length/side_number*cos(angle)*base_scale,$fn=30);}
	if(hole)
		difference(){
			cylinder(h=base_height,d1=2*length/side_number*cos(angle)*base_scale,
						d2=2*length/side_number*cos(angle)*base_scale*0.9,$fn=50);
			cylinder(h=base_height,d1=2*length/side_number*cos(angle)/base_scale*0.9,
						d2=2*length/side_number*cos(angle)/base_scale,$fn=50);}
	else
		cylinder(h=base_height,d1=2*length/side_number*cos(angle)*base_scale,
					d2=2*length/side_number*cos(angle)*base_scale*0.9,$fn=50);}