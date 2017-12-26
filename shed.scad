$fn = 200;

shed_outer = [10*12,8*12,6*12];
wall = 1/4;

shed_inner = shed_outer - [2*wall,2*wall,2*wall];

door = [shed_outer[0]/2, 2*wall, shed_outer[2]-8];

module shed() {
    difference() {
        cube(shed_outer);
        translate([wall,wall,wall]) cube(shed_inner);
        translate([shed_outer[0]/2-door[0]/2,-wall/2,0]) 
            cube(door);
        translate([-1,-1,shed_outer[2]-8]) rotate([0,-7,0]) cube(shed_outer+[4,4,4]);
        translate([shed_outer[0]+2-1,-1,shed_outer[2]-8]) mirror() rotate([0,-7,0]) cube(shed_outer+[4,4,4]);
    }
    translate([0,0,shed_outer[2]-8]) rotate([0,-7,0]) cube([(shed_outer[0]/2)/cos(7),shed_outer[1],wall]);
    translate([shed_outer[0],0,shed_outer[2]-8]) mirror() rotate([0,-7,0]) cube([(shed_outer[0]/2)/cos(7),shed_outer[1],wall]);
}

function shed_dim() = shed_outer;

shed(); 
    