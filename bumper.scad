inch_to_mm = 25.4;

oem_bumper_no_plastic = 50 * inch_to_mm;
oem_bumper_plastic = 60.5 * inch_to_mm;

max_tire_size = 35 * inch_to_mm;

arm_thickness = 2 * inch_to_mm;

// main bumper
bumper = [60.5, 4, 2] * inch_to_mm;

//bumper angled cuts
angle = 60;
bumper_cut = [20, 8, 3] * inch_to_mm;
cut_offset = 130;

// gap between tire carrier and bumper
gap = 1 * inch_to_mm;

// tire carrier
spacer = [6.5,1.25] * inch_to_mm;
carrier_length = 5.5 * inch_to_mm;
carrier_offset = 
    [bumper[0] / 2,
     max_tire_size / 2 + bumper[1] + gap + 0.8 * inch_to_mm,
     carrier_length + arm_thickness];

// tow receiver
receiver_outer = [0.5,3,3] * inch_to_mm;
receiver = [6, 2, 2] * inch_to_mm;
receiver_pin = [5/8,3] * inch_to_mm;
wall = 1/4 * inch_to_mm;
receiver_offset = 
    [bumper[0]/2-receiver[1]/2-wall,
     1/2 * inch_to_mm,
     -1 * inch_to_mm];

// shackle holders
pin_size = ((7/8) + 0.1) * inch_to_mm;
shackle = [7/8, 21/8, 2+14/8] * inch_to_mm;
shackle_offset = [9.5, 1/2, 0] * inch_to_mm;

hinge = [1, 4] *inch_to_mm;

// holder for the tire carrier
bracket = [2, 2+1/2, 1]*inch_to_mm;

cross_bar = bumper[0]-2*shackle_offset[0]+arm_thickness;
adj = (cross_bar-2*hinge[0])/2;
diag_bar = sqrt(pow(adj, 2) + pow(max_tire_size/2,2));
ang = acos(adj/diag_bar);

module bracket() {
    translate([0,0,-2*inch_to_mm]) cube([2,0.25,2]*inch_to_mm);
    translate([0,2+1/4,-1/2]*inch_to_mm) cube([2,0.25,1/2]*inch_to_mm);
    cube(bracket);
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
        
        translate([-2,21/16*inch_to_mm,(2+7/8)*inch_to_mm]) rotate([0,90,0])
            cylinder(h=2*inch_to_mm,r=(pin_size/2));
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
            translate([4*inch_to_mm, -1, 1*inch_to_mm+wall]) 
            rotate([0,90,90]) 
                cylinder(h=receiver_pin[1], r=receiver_pin[0] / 2);
    }
}

module bumper() {
    difference () {
        cube(bumper);
        
        translate([cut_offset,0,-1]) rotate([0,0,90+angle]) 
            cube(bumper_cut);
        
        mirror([1,0,0]) 
            translate([-bumper[0]+cut_offset,0,-1]) 
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

translate([2*hinge[0]/2,0,0])
union() {
    translate([bumper[0]-6*hinge[0],bumper[1],bumper[2]-hinge[0]]) 
        rotate([-90,0,0]) 
        hinge();
    
    translate([shackle_offset[0]-12*hinge[0]/2, bumper[1]+1*inch_to_mm,0]) 
        arm(cross_bar+15*hinge[0]/2);
    
    translate([shackle_offset[0]-arm_thickness/2,bumper[1]+1*inch_to_mm+arm_thickness,0]) 
        rotate([0,0,-90+ang]) 
        translate([arm_thickness,0,0]) 
        rotate([0,0,90]) 
            arm(diag_bar+1/4*inch_to_mm);
    
    translate([2*shackle_offset[0]+cross_bar-3*hinge[0]/2,0,0]) 
        mirror([1,0,0]) 
        translate([shackle_offset[0]+arm_thickness/2+0.5*inch_to_mm,bumper[1]+1*inch_to_mm+arm_thickness,0]) 
        rotate([0,0,-90+ang]) 
        translate([arm_thickness,0,0]) 
        rotate([0,0,90]) 
            arm(diag_bar+1/4*inch_to_mm);
}

translate([shackle_offset[0],bumper[1]+bracket[2],-1/4*inch_to_mm]) rotate([90,0,0]) bracket();

translate(carrier_offset) rotate([0,0,45]) carrier();

//translate([bumper[0]/2+inch_to_mm,0,0]) rotate([0,0,90]) arm(1000);