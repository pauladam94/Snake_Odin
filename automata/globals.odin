package main

import rl "vendor:raylib"

// FLOAT APPROX
eps: f32 = 0.001

// WINDOW
width :: 1000
height :: 1000
font_size :: 40

// DELTA TIME
dt: f32
transition_duration: f32 = 0.5

// CAMERA
camera: rl.Camera2D
camera_speed: f32 = 500

// TEXT
font: rl.Font
text_spacing :: font_size / 2

// ECS
ecs: ECS

// LEVELS
levels_bound: []BoundComponent = {
	{{100, 100}, {1100, 1100}},
	{{2000, 2000}, {2500, 2800}},
}

// VISUALS
health_bar_width: f32 : 40
radius_base: f32 : 30
spacing_base: f32 : 400
