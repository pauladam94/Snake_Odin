package main

import "core:fmt"
import rl "vendor:raylib"

init_game :: proc() {
	fmt.println("\nFont loaded with success")
	rl.SetTargetFPS(60)

	rl.InitWindow(width, height, "Hello")
	// font = rl.LoadFontEx("./assets/FiraCode-Retina.ttf", font_size, nil, 256)
	font = rl.LoadFont("")
	rl.SetConfigFlags(rl.ConfigFlags{rl.ConfigFlag.MSAA_4X_HINT})


	camera_init()



}
