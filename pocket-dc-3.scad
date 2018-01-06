
panels_thickness = 10;
slots = 6;
board_gap = 32;
aux_compart_w = 68;
strip_d = 4;
shelf_w = 120;
shelf_d = 120;
shelf_h = 4;
bracket = [5 , shelf_d, 5 ];

shelf2 = [ aux_compart_w, 140, 4 ];

panel_w = panels_thickness;
panel_h = (slots)*(board_gap)+6;
panel_d = 160;
strip = [20, 4, panel_h];

top_cover = [ shelf_w+panel_w*3+aux_compart_w, panel_d+strip_d, panel_w ];

bottom_base = top_cover;

shelf = [shelf_w, shelf_d, shelf_h];
panel_left = [panel_w, panel_d, panel_h];
inter_panel = [panel_w, 100, panel_h];
panel_right = [panel_w, panel_d+strip[1], panel_h];

pwu = [ 102, 51, 21];
pwu_gap = 2;
switch =[158, 101, 25];
switch_gap = 2;


module rjsocket() {
    import("rj45.stl");
}

module OrangePIOne() {
    scale([1.2,1.2,1.23]) {
        import("Orange-pi-one.stl");
    }
}

module make_shelf(x, y, z, shelf) {
    translate([x,y,z]) cube(shelf);
}

module make_bracket(x,y,z, bracket) {
    translate([x, y, z]) color([1,1,1]) cube(bracket);
}    



// create brackets and shelves
for (nz=[0:slots-1]) {
    // top brackets
    make_bracket(panel_w, panel_d-shelf_d,  bracket[2] + bottom_base[2] + nz*board_gap-bracket[2], bracket);
    make_bracket(panel_w, panel_d-shelf_d,  bracket[2] + bottom_base[2] + shelf[2]+bracket[2] + nz*board_gap- bracket[2], bracket);
    make_bracket(shelf_w+panel_w-bracket[0], panel_d-shelf_d,  bracket[2] + bottom_base[2] + nz*board_gap-bracket[2], bracket);
    make_bracket(shelf_w+panel_w-bracket[0], panel_d-shelf_d,  bracket[2] + bottom_base[2] + shelf[2]+bracket[2] + nz*board_gap-bracket[2], bracket);
    make_shelf(panel_w, panel_d - shelf_d, bottom_base[2] + bracket[2] + (nz)*board_gap , shelf);

}    

// bottom base
translate([0,0,0]) cube(bottom_base);
//left panel
translate([0,0,panel_w]) cube(panel_left);
// inter-panel
translate([shelf_w+panel_w,30,panel_w]) cube(inter_panel);
// top cover
translate([0,0,panel_h+top_cover[2]]) cube(top_cover);

// strips
translate([0, panel_d, bottom_base[2]]) cube(strip);
translate([shelf_w+panel_left[0]*2-strip[0], panel_d, bottom_base[2]]) cube(strip);

// right panel
translate([bottom_base[0]-panel_right[0], 0, panel_w]) cube(panel_right);

// 2 x 1Gbit switches
translate([168,30, bottom_base[2]]) rotate([0,-90,0]) cube(switch);
translate([155,28, bottom_base[2]+10+30]) rotate([0,270,90]) color([0,1,0]) rjsocket();

// 2 x PWU
translate([200,30, 8 ]) rotate([0,-90,0]) cube(pwu);

module make_board(y) { 
     translate([30, 40, bottom_base[2]+shelf[2]+y+5 ]) 
         rotate([90,0,90]) 
             color([1,0.5,0]) OrangePIOne();
}

for (nz=[0:slots-1]) {
    make_board(nz * board_gap);
}
echo("width: ", panel_h+bottom_base[2]+top_cover[2]);
echo("width: ", bottom_base[0]);


