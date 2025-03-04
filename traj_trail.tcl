set sel [atomselect top "name 2"]  ;# Select rod with name "2"
set numframes [molinfo top get numframes]

set xpos {}  
set ypos {}  
set zpos {}

# Store positions for all frames
for {set i 0} {$i < $numframes} {incr i} {
    $sel frame $i  ;# Move to the current frame
    lappend xpos [lindex [$sel get x] 0]
    lappend ypos [lindex [$sel get y] 0]
    lappend zpos [lindex [$sel get z] 0]
}

proc draw_trajectory {} {
    global xpos ypos zpos numframes

    # Create directories
    set output_dir "movie_frames"
    file mkdir $output_dir  

    # Loop through frames
    for {set i 1} {$i < $numframes} {incr i} {
        animate goto $i  ;# Move to the current frame
        
        draw delete all  ;# Clear previous drawings
        draw color blue  ;# Set color to blue
        
        # Draw thick trajectory using cylinders when the distance is less than 40
        for {set j 1} {$j <= $i} {incr j} {
            set x1 [lindex $xpos [expr {$j-1}]]
            set y1 [lindex $ypos [expr {$j-1}]]
            set z1 [lindex $zpos [expr {$j-1}]]
            
            set x2 [lindex $xpos $j]
            set y2 [lindex $ypos $j]
            set z2 [lindex $zpos $j]

            # Calculate Euclidean distance
            set dx [expr {$x2 - $x1}]
            set dy [expr {$y2 - $y1}]
            set dz [expr {$z2 - $z1}]
            set distance [expr {sqrt($dx*$dx + $dy*$dy + $dz*$dz)}]

            # Draw if the distance is less than 40
            if {$distance < 40.0} {
                draw cylinder "$x1 $y1 $z1" "$x2 $y2 $z2" radius 0.2 resolution 10
            }
        }

        # Render as .tga using TachyonInternal
        set framefile_tga [format "%s/frame%04d.ppm" $output_dir $i]
        render TachyonInternal $framefile_tga

        after 50  ;# Small delay for smooth animation
    }

    puts "Rendering completed! Frames saved in $output_dir"
}

# Run the function to draw and render frames
draw_trajectory
