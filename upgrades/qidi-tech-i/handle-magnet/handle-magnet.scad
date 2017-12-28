//OpenSCAD!
// title      : Repligreater Magnet Handle Mount for Qidi Tech I
// author     : Stuart P. Bentley (@stuartpb)
// version    : 1.0.0
// file       : handle-magnet.scad

/* [Measurements] */

// The length of the handle, measured as the distance between
// the centers of the screw-holes.
// (Protip: you can calculate this by measuring the outer width
// and subtracting the gauge/width of the handle.)
distanceBetweenCenters = 96;

// The diameter of the handle (default: 10mm + 1mm tolerance).
rodDiameter = 11; // 

// The diameter of the magnet (default: 6mm + .6mm tolerance).
magnetDiameter = 6.6;

// The depth of the magnet (default: 3mm + .5mm tolerance).
magnetDepth = 3.5;

// The distance from the handle (measured from the center)
// to the place on the frame where the magnet will go.
distanceToFrame = 28;

/* [Parameters] */

// The radius of the material surrounding the handle and magnet.
holderWidth = 3;

// The width of the arms that extend to the magnet.
armWidth = 10;

// The depth of the arms and magnet holder.
holderDepth = 6;

// The length of the handle-grabbing cylinders.
handleGrab = 16;

/* [Tweaks] */

// Circle resolution
$fn = 90;

/* [Hidden] */

function hypotenuse(a, b) = sqrt(a*a + b*b);

// Angle from handle rods to magnet
angle = atan2(-distanceToFrame, distanceBetweenCenters/2);
armLength = hypotenuse(distanceToFrame, distanceBetweenCenters/2);
// Width of handle-holding cylinders
grabWidth = rodDiameter + holderWidth*2;

// Model
difference () {
  
  // Material
  union () {
    
    // Handle-grabbing cylinders
    linear_extrude(handleGrab) {
      // left cylinder
      translate([-distanceBetweenCenters/2, distanceToFrame/2])
        circle(d = grabWidth);
      // right cylinder
      translate([distanceBetweenCenters/2, distanceToFrame/2])
        circle(d = grabWidth);
    }
    
    // Arms / magnet holder
    linear_extrude(holderDepth) {
      // left arm
      translate([-distanceBetweenCenters/2, distanceToFrame/2])
        rotate([0,0, angle]) translate([0, -armWidth/2])
        square([armLength, armWidth]);
      // right arm
      translate([distanceBetweenCenters/2, distanceToFrame/2])
        rotate([0,0, 180-angle]) translate([0, -armWidth/2])
        square([armLength, armWidth]);
      // magnet holder
      translate([0, -distanceToFrame/2])
        circle(d = magnetDiameter + holderWidth*2);
    }
  }
  
  // Handle holes
  linear_extrude(handleGrab) {
    // left hole
    translate([-distanceBetweenCenters/2, distanceToFrame/2])
      circle(d = rodDiameter);
    // right hole
    translate([distanceBetweenCenters/2, distanceToFrame/2])
      circle(d = rodDiameter);
  }
  
  // Magnet slot
  linear_extrude(magnetDepth) {
    translate([0, -distanceToFrame/2])
      circle(d = magnetDiameter);
  }
}
