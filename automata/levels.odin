package main

import rl "vendor:raylib"

levels_draw_bound :: proc() {
	a := rl.Rectangle{}
	thickness: f32 = 10
	for bound in levels_bound {
		rl.DrawRectangleLinesEx(
			rl.Rectangle {
				bound.min.x - thickness,
				bound.min.y - thickness,
				bound.max.x - bound.min.x + thickness * 2,
				bound.max.y - bound.min.y + thickness * 2,
			},
			thickness,
			rl.BLACK,
		)
	}
}
