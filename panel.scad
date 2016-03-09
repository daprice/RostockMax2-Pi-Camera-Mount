//PiPlate for Rostock Max

//This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
//© 2016 Dale Price


//---------------------
//      Settings
//---------------------

/* [Printer Config (default: Rostock Max v2)] */

//the width of the Rostock Max side panel (mm)
panelWidth = 200;

//the height of the Rostock Max side panel
panelHeight = 113;

//the thickness of the Rostock Max side panel
panelThickness = 6;


include <MCAD/boxes.scad> //used for the base shape of the RoMax side panel

difference() {
	//basic shape of romax side panel
	roundedBox([panelWidth, panelHeight, panelThickness],2.5,true);
	
	//screw holes in side panel
	translate([-panelWidth / 2 + 8, panelHeight / 2 - 32, 0]) cylinder(d=7, h=panelThickness, center=true);
	translate([panelWidth / 2 - 8, panelHeight / 2 - 32, 0]) cylinder(d=7, h=panelThickness, center=true);
}
