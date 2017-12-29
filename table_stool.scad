$fn = 200;

use <table.scad>;
use <stool.scad>;
use <shed.scad>;
use <cart.scad>;

translate([shed_dim()[1]/2,0,1/4]) rotate([0,0,90]) table();

translate(
    [-chair_dim()[0],
     chair_dim()[0],
      2+1/4]) 
      chair();
      
translate([-shed_dim()[1]/4,shed_dim()[0]/2,0]) rotate([0,0,-90]) shed();

translate([0,-cart_dim()[0],1/4]) rotate([0,0,80]) cart();