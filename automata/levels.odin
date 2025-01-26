package main

import rl "vendor:raylib"

levels_draw_bound :: proc() {
	a := rl.Rectangle{}
	for bound in levels_bound {
		rl.DrawRectangleLinesEx(
			rl.Rectangle {
				bound.min.x,
				bound.min.y,
				bound.max.x - bound.min.x,
				bound.max.y - bound.min.y,
			},
			10,
			rl.BLACK,
		)
	}
}
