$fn = 200;

// all measurements in inches

oem_bumper_no_plastic = 50;
oem_bumper_plastic = 60.5;

max_tire_size = 35;

arm_thickness = 2;

// main bumper
bumper = [60.5, 4, 2];

//bumper angled cuts
angle = 60;
bumper_cut = [20, 8, 3];
cut_offset = 5;

// gap between tire carrier and bumper
gap = 1;

// tire carrier
spacer = [6.5,1.25];
carrier_length = 5.5;
carrier_offset = 
    [bumper[0] / 2,
     max_tire_size / 2 + bumper[1] + gap,
     carrier_length + arm_thickness];

// tow receiver
receiver_outer = [0.5,3,3];
receiver = [6, 2, 2];
receiver_pin = [5/8,3];
wall = 1/4;
receiver_offset = [bumper[0]/2-receiver[1]/2-wall, 1/2, -1];

// shackle holders
pin_size = 7/8 + 0.1;
shackle = [7/8, 21/8, 2+14/8];
shackle_offset = [9.5, 1/2, 0];

// hinge
hinge = [1, 4];
hinge_offset = [bumper[0]-5,bumper[1],bumper[2]-hinge[0]];

// holder for the tire carrier
bracket = [2, 2+1/2, 1];
bracket_back = [2,0.25,2];
bracket_front = [2,0.25,1/4];
bracket_offset = [shackle_offset[0], bumper[1], -wall];

// tire carrier
rotating_arm = [2 * hinge_offset[0] - bumper[0], 2, 2];
rotating_arm_offset = [bumper[0]-hinge_offset[0], bumper[1] + gap, 0];

A = (bumper[0]-2*shackle_offset[0])/2;
B = max_tire_size/2 - arm_thickness + sqrt(2) * arm_thickness/2;
C = sqrt(pow(A, 2) + pow(B,2));
theta = atan(B/A);

diagonal_arm = [C,2,2];

// mount

mounting_plate = [9, 3, 3/8];
mounting_leg = [3,3,2];
mounting_offset = 
    [shackle_offset[0]-mounting_plate[0]/2+mounting_leg[0]/2, 
     bumper[1]/2-mounting_plate[1]/2,
     -mounting_plate[2]-mounting_leg[2]];
mounting_offset_right = 
    [bumper[0]-shackle_offset[0]-mounting_plate[0]/2-mounting_leg[0]/2,
     mounting_offset[1],
     mounting_offset[2]];

module mount() {
    union() {
        cube(mounting_plate);
        translate(
            [mounting_plate[0]/2-mounting_leg[0]/2,
             mounting_plate[1]/2-mounting_leg[1]/2,
             mounting_plate[2]]) 
        cube(mounting_leg);
    }
}

translate(mounting_offset) mount();
translate(mounting_offset_right) mount();

module bracket() {
    translate([0,0,-gap])
    union() {
        translate([0,0,-bracket[0]]) 
            cube(bracket_back);
    
        translate([0,bracket[1]-wall,-bracket_front[2]]) 
            cube(bracket_front);
    
        cube(bracket);
    }
}

module hinge() {
    cylinder(h=hinge[1], r=hinge[0]);
}

module arm(length) {
    cube([length,arm_thickness,arm_thickness]);
}

module carrier() {
    translate([-arm_thickness/2,arm_thickness/2,0]) rotate([90,90,0]) arm(carrier_length);
    cylinder(r=spacer[0]/2,h=spacer[1]);
}

module shackle() {
    difference() { 
        cube(shackle);
        
        translate([-1/2, 21/16, 2+7/8]) rotate([0,90,0])
            cylinder(h=2,r=(pin_size/2));
    }
}

module receiver(solid = false) {
    translate([0, -receiver[2]-2*wall, -receiver[2]-2*wall])
    difference() {
        union() {
            cube([receiver[0], receiver[1] + 2 * wall, receiver[2] + 2 * wall]);
            translate([receiver[0] - receiver_outer[0], -wall, -wall]) 
                cube(receiver_outer);
        }
        
        if (!solid) 
            translate([-1, wall, wall]) 
                cube([receiver[0]+2, receiver[1], receiver[1]]);
        
        if (!solid) 
            translate([4, -1, 1+wall]) 
            rotate([0,90,90]) 
                cylinder(h=receiver_pin[1], r=receiver_pin[0] / 2);
    }
}

module bumper() {
    difference () {
        cube(bumper);
        
        translate([cut_offset,0,-1/16]) rotate([0,0,90+angle]) 
            cube(bumper_cut);
        
        mirror([1,0,0]) 
            translate([-bumper[0]+cut_offset,0,-1/16]) 
            rotate([0,0,90+angle]) 
                cube(bumper_cut);
    
        translate(receiver_offset)
            rotate([0,-90,90])
            receiver(true);
    }
}

bumper();

difference() {
    translate(receiver_offset)
        rotate([0,-90,90])
        receiver();
    //translate([0,0,-10000]) cube(10000);
}

translate(shackle_offset) shackle();
translate([bumper[0],0,0]) mirror([1,0,0]) translate(shackle_offset) shackle();

translate(hinge_offset) 
    rotate([-90,0,0]) 
        hinge();

translate([shackle_offset[0],bumper[1]+gap+arm_thickness,0]) 
    rotate([0,0,-90+theta]) 
    translate([arm_thickness,0,0]) 
    rotate([0,0,90]) 
        arm(diagonal_arm[0]);    

translate([bumper[0]-shackle_offset[0],bumper[1]+gap+arm_thickness,0]) 
    rotate([0,0, 90-theta]) 
    rotate([0,0,90]) 
        arm(diagonal_arm[0]);    

translate(rotating_arm_offset) 
    arm(rotating_arm[0]);    

translate(bracket_offset) rotate([90,0,0]) bracket();

translate(carrier_offset) rotate([0,0,45]) carrier();

//translate([bumper[0]/2+inch_to_mm,0,0]) rotate([0,0,90]) arm(1000);