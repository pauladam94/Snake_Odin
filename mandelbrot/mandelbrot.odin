package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

length :: proc(v: [2]f64) -> f64 {
	return math.sqrt(v.x * v.x + v.y * v.y)
}
normalize :: proc(v: [2]f64) -> [2]f64 {
	return v / length(v)
}
orthogonal :: proc(v: [2]f64) -> [2]f64 {
	return normalize([2]f64{-v.y, v.x})
}

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
mandelbrot :: proc(c: complex128, n: i32) -> bool {
	v: complex128
	for i in 0 ..= n {
		if real(v) + imag(v) >= 4 {return false}
		v = v * v + c
	}
	return true
}

world_pos :: proc(i, j, w, h: f64, min, max: [2]f64) -> complex128 {
	return complex(
		max.x * i / w + min.x * (1 - i / w),
		max.y * j / w + min.y * (1 - j / w),
	)
}

main :: proc() {
	w: f64 : 500
	h: f64 : 500
	min: [2]f64 = {-2, -2}
	max: [2]f64 = {2, 2}
	prec: f64 : 400
	delta: f64 = 0.1

	rl.InitWindow(i32(w), i32(h), "")
	for !rl.WindowShouldClose() {
		rl.ClearBackground(rl.WHITE)
		rl.BeginDrawing()
		for i in 0 ..= w {
			for j in 0 ..= h {
				if mandelbrot(world_pos(i, j, w, h, min, max), 100) {
					rl.DrawRectangleRec({f32(i), f32(j), 1, 1}, rl.BLACK)
				}
			}
		}
		rl.EndDrawing()

		if rl.IsKeyDown(rl.KeyboardKey.UP) {
			pos: [2]f64 =
				{f64(rl.GetMousePosition().x), f64(rl.GetMousePosition().y)} /
				w

			min += normalize(pos - min) * delta
			max += normalize(pos - max) * delta
		}
	}
	rl.CloseWindow()
}
