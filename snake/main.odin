package main

import "core:fmt"
import "core:time"
import "core:math"

import rl "vendor:raylib"

DIR :: enum {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

main :: proc() {
	width :: 1000
	height :: 1000
	size :: 40

	rl.InitWindow(width, height, "Hello")

	fruit: [2]i32 = {3, 3}
	pos: [2]i32 = {0, 0}
	speed: i32 = 1
	dir: DIR = DIR.DOWN

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		rl.DrawRectangle(pos[0], pos[1], size, size, rl.GREEN)
		rl.EndDrawing()

		switch {
		case rl.IsKeyPressed(rl.KeyboardKey.UP):
			dir = DIR.UP
		case rl.IsKeyPressed(rl.KeyboardKey.DOWN):
			dir = DIR.DOWN
		case rl.IsKeyPressed(rl.KeyboardKey.RIGHT):
			dir = DIR.RIGHT
		case rl.IsKeyPressed(rl.KeyboardKey.LEFT):
			dir = DIR.LEFT
		}

		switch dir {
		case DIR.UP:
			pos.y -= speed
		case DIR.DOWN:
			pos.y += speed
		case DIR.RIGHT:
			pos.x += speed
		case DIR.LEFT:
			pos.x -= speed
		}
		pos.x = pos.x %% width
		pos.y = pos.y %% height

		time.sleep(1_000_000)
	}

	rl.CloseWindow()
}
