package main

import rl "vendor:raylib"

width :: 1000
height :: 1000
font_size :: 40
dt: f32 = 0
camera: rl.Camera2D
font: rl.Font
text_spacing :: font_size / 2

ecs: ECS
