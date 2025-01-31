package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

timer_update :: proc(id: EntityHandle) {
	timer := &ecs.timers[id]
	if timer.t >= 1 {
		delete_key(&ecs.timers, id)
		ecs.timers_finished[id] = TimerFinishedComponent{}
		delete_entity(id)
	} else {
		timer.t += dt / timer.duration
	}
}

update_position_in_transition :: proc(
	pos: ^PositionComponent,
	t: ^TransitionComponent,
) {

}
