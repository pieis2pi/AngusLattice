roundedness = 0.2; 
diameter = 2;

module rounded_cube(length,roundedness){
	minkowski(){
		cube(size=length*(1-roundedness),center=true);
		sphere(d=length*roundedness,$fn=20);}}

rounded_cube(diameter,roundedness);

