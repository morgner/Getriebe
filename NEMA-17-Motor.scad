/*

MOTOR

*/


$fn=164;
eps=0.001;

nema17();

M3=3;

module nema17()
    {
    translate([0,0,34.3/2]) 
        difference()
            {
            union()
                {
                intersection()
                    {
                    color([0,0,0]) cube([42.3,42.3,34.3], center=true);
                    color([.9,.9,.9]) cylinder(d=55, h=34+eps, center=true);
                    }
                color([.8,.8,.8]) translate([0,0,34.3/2]) cylinder(d=22, h=2+eps);
                color([1,1,1]) translate([0,0,34.3/2]) cylinder(d=5, h=24.1+eps);
                }
            translate([0,0,-4.5+eps]) union()
                {
                translate([ 31/2, 32/2,34.3/2]) cylinder(d=M3, h=4.5+eps);
                translate([ 31/2,-32/2,34.3/2]) cylinder(d=M3, h=4.5+eps);
                translate([-31/2, 32/2,34.3/2]) cylinder(d=M3, h=4.5+eps);
                translate([-31/2,-32/2,34.3/2]) cylinder(d=M3, h=4.5+eps);
                }
            translate([0,0,-34.3+eps]) union()
                {
                translate([ 31/2, 32/2,34.3/2]) cylinder(d=M3, h=4.5+eps);
                translate([ 31/2,-32/2,34.3/2]) cylinder(d=M3, h=4.5+eps);
                translate([-31/2, 32/2,34.3/2]) cylinder(d=M3, h=4.5+eps);
                translate([-31/2,-32/2,34.3/2]) cylinder(d=M3, h=4.5+eps);
                }
            }
        }