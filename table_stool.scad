$fn = 200;

use <table.scad>;
use <stool.scad>;
use <shed.scad>;

translate([0,0,1/4]) table();

translate(
    [table_dim()[0]/2-chair_dim()[0]/2,
     -4*chair_dim()[1]/2,
      2+1/4]) 
      chair();
      
translate([-shed_dim()[1]/4,shed_dim()[0]/2,0]) rotate([0,0,-90]) shed();