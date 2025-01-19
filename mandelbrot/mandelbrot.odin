package main

import "core:fmt"
import rl "vendor:raylib"

/*
Point (a , b) :
	x_0 = y_0 = 0
	x_n+1 = x_n^2 - y_n^2 + a
	y_n+1 = 2 * x_n * y_n^2 + b

	- noir si x_n et y_n converge
	- blanc sinon (si une des deux diverge)

Condition :
	Si il existe n tel que, x_n^2 + y_n^2 >= 4
	Alors l'une des deux diverge.
*/
mandelbrot :: proc(a, b: f32, n: i32) -> bool {
	x: f32 = 0
	y: f32 = 0
	for i in 0 ..= n {
		if x * x + y * y >= 4 {return false}
		x = x * x - y * y + a
		y = 2 * x * y + b
	}
	return true
}

main :: proc() {
	frame := 0
	w: f32 : 1000
	h: f32 : 1000
	prec: f32 : 400
	rl.InitWindow(i32(w), i32(h), "")
	for !rl.WindowShouldClose() {
		fmt.println("frame : ", frame)
		frame += 1
		rl.ClearBackground(rl.WHITE)
		rl.BeginDrawing()
		for i in 0 ..= w {
			for j in 0 ..= h {
				if mandelbrot(4 * (i / w) - 2, 4 * (j / w) - 2, 100) {
					rl.DrawRectangleRec({i, j, 1, 1}, rl.BLACK)
				}
			}
		}
		rl.EndDrawing()
	}
	rl.CloseWindow()
}
