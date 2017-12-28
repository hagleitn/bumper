$fn = 200;

// all measurements in inches
arm_thickness = 1+1/4;
seat = 12;
height = 24 - arm_thickness;
thickness = 1/4;

module arm(height, thickness=arm_thickness, angle=0) {
    length = height/cos(angle) + thickness*tan(angle);
    echo(height = height, thickness=thickness, angle=angle,length = length);
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

module seat(size, thickness) {
    cube([size, size, thickness]);
}

module chair() {
    arm_angle = 2*atan((sqrt(-pow(arm_thickness,2)+pow(height,2)+pow(seat,2))-height)/(arm_thickness+seat));
    angle_to_plate = 90 - arm_angle;
    echo(arm_angle=arm_angle, angle_to_plate=angle_to_plate);
    translate([0,0,height]) seat(seat, thickness);    
    arm(height, angle=arm_angle);
    translate([seat,0,0]) rotate([0,0,90]) arm(height, angle=arm_angle);
    translate([seat,seat,0]) rotate([0,0,180]) arm(height, angle=arm_angle);
    translate([0,seat,0]) rotate([0,0,-90]) arm(height, angle=arm_angle);
    
    rotate([0,90,0]) arm(seat);
    translate([arm_thickness,0,0]) rotate([0,90,90]) arm(seat);
    translate([0,seat-arm_thickness,0]) rotate([0,90,0]) arm(seat);
    translate([seat,0,0]) rotate([0,90,90]) arm(seat);
}

function chair_dim() = [seat,seat,height];

chair();