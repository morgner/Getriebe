/*
3-RaederKoppelGetriebe

Autor:		Manfred Morgner
Lizenz:		Creative Commons - Attribution, Non Commercial, Share Alike
*/

$fn=73;
eps=.001;
spiel=.42;

s1=.42;
s2=.42+1*.44;
s3=.42+2*.44;
s4=.42+3*.44;

// G();
// translate([-15,20,02.5]) G();
// translate([+15,20,02.5]) G();

module G(cdi=5,
         hzo=0)
    {
    translate([0,0,2])
    difference()
        {
        union()
            {
            translate([0,0,hzo/2+      -1+eps]) cylinder(d=cdi-1-spiel,                        h=hzo+9+spiel, center=true);
            // upper Ramp
            translate([0,0,hzo +3.1+.75*spiel]) cylinder(d1=cdi-1+s3-spiel, d2=cdi-1+s2-spiel, h=2*spiel, center=true);
            // hanging Ramp
            translate([0,0,hzo  +3.1-.5*spiel]) cylinder(d1=cdi-1- 2*spiel, d2=cdi-1+s3-spiel, h=.5*spiel, center=true);
            }
        rotate([0,0,  0]) translate([0+6,0, hzo/2+1-eps]) cube([8,4,hzo+9], center=true);
        rotate([0,0,120]) translate([0+6,0, hzo/2+1-eps]) cube([8,4,hzo+9], center=true);
        rotate([0,0,240]) translate([0+6,0, hzo/2+1-eps]) cube([8,4,hzo+9], center=true);
        translate([0,0,hzo/2]) cylinder(d1=cdi-4*s4, d2=cdi-4*s2, h=hzo+9.9+spiel+eps, center=true);
        }
    }

difference()
    {
//                                         | |
//  A |_| - B |^| - C ||_|| - D ||^|| - E ||_|| - F ||^|| - G | |
//                                                   | |
    union()
        {
        color([.5,1,.5]) translate([0,0, 6+20]) rotate([0,0,$t*360]) lever(30, "BA"); //  |^|_________|_|
        color([.5,.5,1]) translate([0,0, 0+20])                      lever(50, "CD"); // ||_||_______||_||
                                                                                      //  | |         | | 
        color([1,.9,.5]) translate([0,0,  0  ])                      lever(30, "EF"); // ||_||_______||_||
        color([1,.5,.9]) translate([0,0,  6  ])                      lever(30, "GG"); //  | |_________| |
        color([.6,1,.3]) translate([0,0, 12  ]) rotate([0,0,$t*360]) lever(30, "BB"); //  |^|_________|^| 
        color([1,.5,.9]) translate([0,0, -6  ])                      lever(30, "HH"); //  | |_________| |
        color([.5,1,.5]) translate([0,0,-12  ]) rotate([0,0,$t*360]) lever(30, "AA"); //  |^|_________|_|
        }
//    translate([0,-3+20, 0+3+2])   cube([40,6,12], center=true);
    }



module B( T = "", cdi=15.4 )
    {
    if (T=="G")
        translate([0,0,0+3-eps]) cylinder(d =cdi-1,                          h=6+4*eps,    center=true);
    else
        translate([0,0,0+5])     cylinder(d =cdi-1,                          h=9-1*s2+eps, center=true);
    if (T=="A" || T=="B")
        translate([0,0,0+2.25])  cylinder(d =cdi-1+4*s1,                     h=2.2+spiel,  center=true);
    if (T!="G") 
        translate([0,0,6-  .6])  cylinder(d2=cdi+2*s2-spiel, d1=cdi-1-spiel, h=3*spiel,    center=true); // A
    if (T=="H") 
        translate([0,0,1-  .4])  cylinder(d1=cdi+2*s2-spiel, d2=cdi-1-spiel, h=3*spiel,    center=true); // A
    }



module lever(gl= 30,
             T = "AA")
    {
    gl2 = gl/2;       // lever length half
    ch  = 6;          // capsule height
    ch2 = ch/2;       // capsule height half
    cdo = 18;         // capsule outer diameter
    cdw = .42+.88;    // capsule wall thickness
    cdi = cdo-2*cdw;  // capsule inner diameter   18 - 2.6 = 15.4 ?

    module A( T = "" )
        {
        if (T=="G")
            translate([0,0,0+3-eps]) cylinder(d=cdi-1, h=6+4*eps, center=true);
        else
            translate([0,0,0+5]) cylinder(d=cdi-1, h=9-1*s2+eps, center=true);
        if (T=="A" || T=="B")
            translate([0,0,0+2.25]) cylinder(d=cdi-1+4*s1, h=2.2+spiel, center=true);
        if (T!="G") 
            translate([0,0,  6-.6]) cylinder(d2=cdi+2*s2-spiel, d1=cdi-1-spiel, h=3*spiel, center=true); // A
        }


    translate([+gl2,0,0])
        {
        // has wheels in the eyes
        if (T[0]=="C")     translate([-gl2,0,3.75])                   G(cdi,hzo=0);
        if (T[0]=="D")     translate([-gl2,0,2.25]) rotate([180,0,0]) G(cdi,hzo=0);
        if (T[1]=="C")     translate([+gl2,0,3.75])                   G(cdi,hzo=0);
        if (T[1]=="D")     translate([+gl2,0,2.25]) rotate([180,0,0]) G(cdi,hzo=0);
        // has high wheels in the eyes
        if (T[0]=="E")     translate([-gl2,0,3.75])                   G(cdi,hzo=6);
        if (T[0]=="F")     translate([-gl2,0,2.25]) rotate([180,0,0]) G(cdi,hzo=6);
        if (T[1]=="E")     translate([+gl2,0,3.75])                   G(cdi,hzo=6);
        if (T[1]=="F")     translate([+gl2,0,2.25]) rotate([180,0,0]) G(cdi,hzo=6);
        difference()
            {
            union()
                {
                translate([-gl2,0,0+ch2]) cylinder(d=cdo, h=ch, center=true); 
                translate([+gl2,0,0+ch2]) cylinder(d=cdo, h=ch, center=true); 

                // steg
                translate([0,0,0+2.25+eps])
                    intersection()
                        {
                        dr  = 20;
                        dr2 = dr/2;
                        translate([0,0, 0+eps])                    cube([gl,8,4.5], center=true);
                        translate([0,0, 0-dr2+2]) rotate([0,90,0]) cylinder(d=dr, h=gl, center=true);
                        }
                }

            if (T[0]=="B" || T[0]=="D" || T[0]=="F") translate([-gl2,0,6]) rotate([180,0,0]) B(T[0], cdi);
            else                                     translate([-gl2,0,0])                   B(T[0], cdi);
            if (T[1]=="B" || T[1]=="D" || T[1]=="F") translate([+gl2,0,6]) rotate([180,0,0]) B(T[1], cdi);
            else                                     translate([+gl2,0,0])                   B(T[1], cdi);

//            translate([0,-6, 6]) cube([80,12,16], center=true);          
//            echo("This is cdi: ", cdi);

            }
        }
    }
