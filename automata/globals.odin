package main

import rl "vendor:raylib"

// WINDOW
width :: 1000
height :: 1000
font_size :: 40

// DELTA TIME
dt: f32

// CAMERA
camera: rl.Camera2D
camera_speed: f32 = 200

// TEXT
font: rl.Font
text_spacing :: font_size / 2

// ECS
ecs: ECS

// LEVELS
levels_bound: []BoundComponent = {
	{{0, 0}, {1000, 1000}},
	{{2000, 2000}, {2200, 2200}},
}
