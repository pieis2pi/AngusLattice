// Angus' Lattice OpenSCAD v2
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
bar_type = "rounded";
roundedness = 0.5; // only used if previous option is "rounded". (0.0=cube 1.0=sphere)
diameter = 2;
side_length = 40.0;
side_number = 1;
lattice_number = 2;
base_height = 1.0;
base_scale = 1.2;
base_bevel = false; // base can have a bevel or not.
hole = false; // hole for little light.
angle = asin(1/sqrt(3)); // angle to roatate to get isometric perspective.
// In terms of the above the height of the final object is:
// height = length/side_number*sin(angle)*(3*side_number-1)+diameter;
// If you want to define height rather than side length, you can instead put in:
// height = whatever;
// side_length = (height-diameter)*side_number/sin(angle)/(3*side_number-1);
length = side_length-diameter; // one extra half bar on each side of the cube.

module dodecahedron(height)	// This module taken from OpenSCAD User Manual
{					// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Print_version
	scale([height,height,height]){	//scale by height parameter
		intersection(){					//make a cube
			cube([2,2,1],center=true); 
				intersection_for(i=[0:4]){	//loop i from 0 to 4, and intersect results
			//make a cube, rotate it 2*atan((1+sqrt(5))/2) degrees around the X axis,
				//then 72*i around the Z axis
					rotate([0,0,72*i])
						rotate([2*atan((1+sqrt(5))/2),0,0])
							cube([2,2,1],center=true);}}}}

module rounded_cube(length,roundedness){
	minkowski(){
		cube(size=length*(1-roundedness),center=true);
		sphere(d=length*roundedness,$fn=20);}}

module basic_shape(type,diameter){
	if(type=="sphere")			// computationally demanding. can decrease $fn. 
		sphere(d=diameter,$fn=20);
	else if(type=="cube")		// easiest computationally.
		cube(size=diameter,center=true);
	else if(type=="dodeca")		// looks great except for top point.
		dodecahedron(height=diameter);
	else if(type=="rounded")	// computationally demanding. looks nice though.
		rounded_cube(diameter,roundedness);
}

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
		translate([0,0,length/2])
			union(){
				for(n=[1:lattice_number])
					for(i=[-1,1])
						for(j=[-1,1])
							rotate((n-1)*120/lattice_number,[i,j,1])
								translate([-length/2,-length/2,-length/2])
									lattice(bar_type,length,side_number,diameter);}
		translate([0,0,-length/2])
			cylinder(h=length/2,d=length*sqrt(2)+2*diameter,$fn=50);}
	if(base_bevel){
		if(hole)
			difference(){
				cylinder(h=base_height,d1=length*sqrt(2)*base_scale,
							d2=length*sqrt(2)*base_scale*0.9,$fn=50);
				cylinder(h=base_height,d1=length*sqrt(2)/base_scale/2*0.9,
							d2=length*sqrt(2)/base_scale/2,$fn=50);}
		else
			cylinder(h=base_height,d1=length*sqrt(2)*base_scale,
						d2=length*sqrt(2)*base_scale*0.9,$fn=50);}
	else{
		if(hole)
			difference(){
				cylinder(h=base_height,d=length*sqrt(2)*base_scale,$fn=50);
				cylinder(h=base_height,d=length*sqrt(2)/base_scale/2,$fn=50);}
		else
			cylinder(h=base_height,d=length*sqrt(2)*base_scale,$fn=50);}}
