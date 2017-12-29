$fn = 50;

// all measurements in inches
arm_thickness = 1+1/4;

bottom = [25,11]; // 17x10 product dim, bottle 15x5x5
platform = [18,11];
height = 20;
grip = 3;

wheel = [2,1/2];

e = [[1,0,0],[0,1,0],[0,0,1]];

plate = 1/8;

function cart_dim() = [bottom[0]+grip,bottom[1],2*height];

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

module hook(t, l1, l2) {
    translate(e[0]*l1)
    union() {
        translate([t,0,t])
        cylinder(r=t/2,h=l2);
        rotate(-e[1]*90)
        cylinder(r=t/2,h=l1);
        rotate(90*e[0])
        translate(e[1]*1*t)
        difference() {
            rotate_extrude(convexity = 10)
                translate([t, 0, 0])
                    circle(r = t/2, $fn = 100);
            translate(-e[0]*2*t-e[2]*t) cube(4*t);
                translate(-e[1]*2*t-e[0]*4*t-e[2]*t) 
                    cube(4*t);
        }
    }
}

module square(a,b,t,angle=0) {
    rotate(e[1]*angle)
    union() {
        translate(e[2]*plate) union() {
            translate(e[2]*t) rotate(90*e[1]) arm(a+2*t);
            translate(e[2]*t+e[1]*(t+b)) rotate(90*e[1]) arm(a+2*t);
            translate(e[2]*t) rotate(-90*e[0]) arm(b+2*t);
            translate(e[2]*t+e[0]*(t+a)) rotate(-90*e[0]) arm(b+2*t);
        }
        cube([a+2*t,b+2*t,plate]);
    }
}

module cart() {
    translate(e[0]*(bottom[0]-platform[0])+e[2]*2*wheel[0])
    union() {
        translate(-e[0]*(bottom[0]-platform[0])) square(bottom[0],bottom[1],arm_thickness);
        translate(e[2]*height) square(platform[0]+1,platform[1], arm_thickness,-15);
        translate(e[2]*height/2) square(platform[0],platform[1], arm_thickness);
        
        arm(height+arm_thickness);
        translate(e[0]*(platform[0]+arm_thickness)) arm(height+6);
        translate(e[0]*(platform[0]+arm_thickness)+e[1]*(platform[1]+arm_thickness)) arm(height+6);
        translate(e[1]*(platform[1]+arm_thickness)) arm(height+arm_thickness);
        
        translate([platform[0]+2*arm_thickness,arm_thickness/2,height+arm_thickness/2+5.5])
        rotate(-e[0]*90)
        union() {
            hook(1/2,grip,platform[1]/2+arm_thickness);
            translate(e[2]*(platform[1]+arm_thickness)) rotate(e[0]*180) hook(1/2,grip,platform[1]/2+arm_thickness);
        }
        
        //translate([-(bottom[0]-platform[0]),0,arm_thickness]) arm(height+2.5,arm_thickness, 36);
        //translate([-(bottom[0]-platform[0]),arm_thickness+bottom[1],arm_thickness]) arm(height+2.5,arm_thickness, 36);
        
        translate([-(bottom[0]-platform[0]),0,arm_thickness]) arm(height,arm_thickness, 18);
        translate([-(bottom[0]-platform[0]),arm_thickness+bottom[1],arm_thickness]) arm(height,arm_thickness, 18);
        
        translate(-e[2]*wheel[0]-e[0]*(bottom[0]-platform[0]-wheel[0])+e[1]*(arm_thickness/2)) rotate(90*e[0]) cylinder(r=wheel[0],h=wheel[1]);
        translate(-e[2]*wheel[0]-e[0]*(bottom[0]-platform[0]-wheel[0])+e[1]*(bottom[1]+2*arm_thickness)) rotate(90*e[0]) cylinder(r=wheel[0],h=wheel[1]);
        translate(-e[2]*wheel[0]+e[0]*(platform[0]+wheel[0]/2)+e[1]*(arm_thickness/2)) rotate(90*e[0]) cylinder(r=wheel[0],h=wheel[1]);
        translate(-e[2]*wheel[0]+e[0]*(platform[0]+wheel[0]/2)+e[1]*(bottom[1]+2*arm_thickness)) rotate(90*e[0]) cylinder(r=wheel[0],h=wheel[1]);
    }
}

cart();