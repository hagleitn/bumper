inch_to_mm = 25.4;

bumper = [58*inch_to_mm, 4*inch_to_mm, 2*inch_to_mm];
angle = 60;
bumper_cut = [500, 155, 55];

receiver_outer = [0.5,3,3] * inch_to_mm;
receiver = [6, 2, 2] * inch_to_mm;
wall = 1/4 * inch_to_mm;

arm = [0, 2, 2] * inch_to_mm;

pin_size = ((7/8) + 0.1) * inch_to_mm;

shackle = [7/8, 21/8, 2+14/8] * inch_to_mm;

hinge = [1, 4] *inch_to_mm;

shackle_offset = (7+1/16)*inch_to_mm;

bracket = [2, 2+1/2, 1/2]*inch_to_mm;

module bracket() {
    translate([0,0,-2*inch_to_mm]) cube([2,0.25,2]*inch_to_mm);
    translate([0,2+1/4,-1/2]*inch_to_mm) cube([2,0.25,1/2]*inch_to_mm);
    cube(bracket);
}

module hinge() {
    cylinder(h=hinge[1], r=hinge[0]);
}

module arm(length) {
    cube(arm+[length,0,0]);
}

carrier_length = 6*inch_to_mm;
module carrier() {
    translate([-arm[1]/2,arm[2]/2,0]) rotate([90,90,0]) arm(carrier_length);
    cylinder(r=3.5*inch_to_mm,h=1*inch_to_mm);
}

module shackle() {
    difference() { 
        cube(shackle);
        translate([-2,21/16*inch_to_mm,(2+7/8)*inch_to_mm]) rotate([0,90,0]) cylinder(h=2*inch_to_mm,r=(pin_size/2));
    }
}

module receiver(solid = false) {
    difference() {
        union() {
            cube([receiver[0], receiver[1]+2*wall, receiver[2]+2*wall]);
            translate([receiver[0]-receiver_outer[0],-0.25*inch_to_mm,-0.25*inch_to_mm]) cube(receiver_outer);
        }
        if (!solid) translate([-1, wall, wall]) cube([receiver[0]+2, receiver[1], receiver[1]]);
        if (!solid) translate([4*inch_to_mm, -1, 1*inch_to_mm+wall]) rotate([0,90,90]) cylinder(h=3*inch_to_mm, r=(5/16)*inch_to_mm);
    }
}

difference () {
    cube(bumper);
    translate([130,0,-1]) rotate([0,0,90+angle]) cube(bumper_cut);
    mirror([1,0,0]) translate([-bumper[0]+130,0,-1]) rotate([0,0,90+angle]) cube(bumper_cut);
    translate([receiver[1]/2+wall+bumper[0]/2,3*inch_to_mm,-1*inch_to_mm])
    rotate([0,-90,90])
    receiver(true);
}

translate([bumper[0]/2+receiver[1]/2+wall,3*inch_to_mm,-1*inch_to_mm])
rotate([0,-90,90])
receiver();

translate([shackle_offset, 1/2*inch_to_mm, 0]) shackle();
translate([bumper[0],0,0]) mirror([1,0,0]) translate([shackle_offset, 1/2*inch_to_mm, 0]) shackle();

cross_bar = bumper[0]-2*shackle_offset-shackle[0]/2;
adj = (cross_bar-2*hinge[0])/2;
diag_bar = sqrt(pow(adj, 2) + pow(35/2*inch_to_mm,2));
ang = acos(adj/diag_bar);

translate([2*hinge[0]/2,0,0])
union() {
    translate([bumper[0]-shackle_offset-hinge[0]/2,bumper[1],bumper[2]-hinge[0]]) 
        rotate([-90,0,0]) 
        hinge();
    
    translate([shackle_offset-2*hinge[0]-0.5*inch_to_mm, bumper[1]+0.5*inch_to_mm,0]) 
        arm(cross_bar+2*hinge[0]+0.5*inch_to_mm);
    
    translate([shackle_offset,bumper[1]+0.5*inch_to_mm+arm[1],0]) 
        rotate([0,0,-90+ang]) 
        translate([arm[1],0,0]) 
        rotate([0,0,90]) 
            arm(diag_bar+1/4*inch_to_mm);
    
    translate([2*shackle_offset+cross_bar-3*hinge[0]/2,0,0]) 
        mirror([1,0,0]) 
        translate([shackle_offset,bumper[1]+0.5*inch_to_mm+arm[1],0]) 
        rotate([0,0,-90+ang]) 
        translate([arm[1],0,0]) 
        rotate([0,0,90]) 
            arm(diag_bar+1/4*inch_to_mm);
}

translate([shackle_offset+0*hinge[0]+0*inch_to_mm,bumper[1]+bracket[2],-1/4*inch_to_mm]) rotate([90,0,0]) bracket();

translate([0*receiver[0]/2+1*bumper[0]/2-0*inch_to_mm,35/2*inch_to_mm+bumper[1]+1.4*inch_to_mm,7*inch_to_mm]) rotate([0,0,45]) carrier();

//translate([bumper[0]/2+inch_to_mm,0,0]) rotate([0,0,90]) arm(1000);