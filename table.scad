$fn = 200;

// all measurements in inches
arm_thickness = 1+1/4;
plate_thickness = 1/4;
rod_thickness = 1/2;

table = [30,20,33];

surface_height = 12;

module arm(height, thickness=arm_thickness, angle=0) {
    length = height/cos(angle) + thickness*tan(angle);
    echo(length);
    max_ = 2*max(thickness,height,length);
    difference () {
            rotate([0,angle,0])
            translate([thickness,0,0])
            rotate([0,-90,0])
                cube([length,thickness,thickness]);
        translate([-1, -1, -max_]) cube(max_);
        translate([-1, -1, height]) cube(max_);
    }
}

module table() {
translate([0,0,table[2]]) cube([table[0],table[1],plate_thickness]);

translate([0,0,surface_height]) cube([table[0],table[1],plate_thickness]);

arm(table[2]);
    translate([table[0]-arm_thickness,0,0]) arm(table[2]);
    translate([table[0]-arm_thickness,table[1]-arm_thickness,0]) arm(table[2]);
    translate([0,table[1]-arm_thickness,0]) arm(table[2]);
    
    translate([0,arm_thickness/2,table[2]-5]) rotate([0,90,0]) cylinder(h=table[0], r=rod_thickness/2);
    translate([0,table[1]-arm_thickness/2,table[2]-5]) rotate([0,90,0]) cylinder(h=table[0], r=rod_thickness/2);
    translate([arm_thickness/2,table[1],table[2]-5]) rotate([90,0,0]) cylinder(h=table[1], r=rod_thickness/2);
    translate([table[0]-arm_thickness/2,table[1],table[2]-5]) rotate([90,0,0]) cylinder(h=table[1], r=rod_thickness/2);
}

function table_dim() = table;

table();