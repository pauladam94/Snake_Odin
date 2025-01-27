package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

position :: proc(pos: Vec2) -> PositionComponent {
	return PositionComponent{pos, {0, 0}, pos, 1, false}
}

position_update :: proc(pos: ^PositionComponent) {
	if pos.transition == 1 {
		pos.pos = pos.end
	}
	if pos.in_transition {
		if pos.transition >= 1 {
			pos.in_transition = false
			pos.transition = 1
		} else {
			pos.transition += dt / transition_duration
			t := pos.transition
			pos.pos = pos.begin * (1 - t) + pos.end * t
		}
	}
}
