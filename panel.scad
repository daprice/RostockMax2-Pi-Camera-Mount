/*
PiPlate for Rostock Max
© 2016 Dale Price daprice@mac.com

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
include <lib/PiHole/PiHole.scad> //used for the raspberry pi mount

difference() {
	//basic shape of romax side panel
	roundedBox([panelWidth, panelHeight, panelThickness],2.5,true);
	
	//screw holes in side panel
	translate([-panelWidth / 2 + 8, panelHeight / 2 - 32, 0]) cylinder(d=7, h=panelThickness, center=true);
	translate([panelWidth / 2 - 8, panelHeight / 2 - 32, 0]) cylinder(d=7, h=panelThickness, center=true);
}
