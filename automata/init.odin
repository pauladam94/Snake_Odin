package main

import "core:fmt"
import rl "vendor:raylib"

init_game :: proc() {
	// rl.SetTargetFPS(target_fps)

	rl.InitWindow(width, height, "Hello")
	// font = rl.LoadFontEx("./assets/FiraCode-Retina.ttf", font_size, nil, 256)
	font = rl.LoadFont("") // Load the default raylib font
	rl.SetConfigFlags(rl.ConfigFlags{rl.ConfigFlag.MSAA_4X_HINT})
	
	camera_init()
}
