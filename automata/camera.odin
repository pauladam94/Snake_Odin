package main

import "core:fmt"
import rl "vendor:raylib"

camera_update :: proc() {
	if rl.IsKeyDown(.DOWN) do	camera.target.y += camera_speed * dt
	if rl.IsKeyDown(.UP) do camera.target.y -= camera_speed * dt
	if rl.IsKeyDown(.RIGHT) do camera.target.x += camera_speed * dt
	if rl.IsKeyDown(.LEFT) do camera.target.x -= camera_speed * dt

	camera.zoom += rl.GetMouseWheelMove() * 0.05
}

camera_init :: proc() {
	camera.zoom = 1
	camera.offset = {0, 0}
	camera.target = {0, 0}
	camera.rotation = 0
}
