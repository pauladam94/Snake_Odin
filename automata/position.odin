package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

timer_update :: proc(id: EntityHandle) {
	timer := &ecs.timers[id]
	if timer.t >= 1 {
		delete_entity(id)
		// delete_key(&ecs.timers, id)
	} else {
		timer.t += dt / timer.duration
	}
}

update_position_in_transition :: proc(
	pos: ^PositionComponent,
	t: ^TransitionComponent,
) {

}
