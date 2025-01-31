package main

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

system_update :: proc() {
	// fmt.println("entities:", ecs.entities)
	using ecs

	if rl.IsKeyPressed(.L) {
		for id in bounds {
			if bounds[id].min == levels_bound[0].min {
				bounds[id] = BoundComponent{{0, 0}, {3000, 3000}}
			}
		}
		levels_bound[0] = BoundComponent{{0, 0}, {3000, 3000}}
	}

	for id in entities {
		// Delete entity with health less that 0
		if id in healths {
			if healths[id].value <= 0 {
				fmt.println("No more health")
				delete_entity(id)
			}
		}

		// Particule with no more transition should be deleted
		if id in particules && id not_in transitions {
			fmt.println("Delete Particule")
			delete_entity(id)
		}

		// Transition with no more timer should be deleted
		if id in transitions && transitions[id].timer not_in timers {
			// End of timer for a particule
			if id in particules {
				t := transitions[id]
				if t.end in healths {
					health := &healths[t.end]
					health.value -= 10
				}
			}
			delete_key(&transitions, id)
		}
		// Update all timers
		if id in timers do timer_update(id)

		if id in transitions &&
		   id in positions &&
		   transitions[id].timer in timers {
			transition := transitions[id]
			t := timers[transition.timer].t
			pos := &positions[id]
			pos^ =
				positions[transition.begin] * (1 - t) +
				positions[transition.end] * t
		}
		if id in bosses && id in positions && id not_in transitions {
			positions[id] = positions[bosses[id].at]
		}
		if id in players && id in positions && id not_in transitions {
			positions[id] = positions[players[id].at]
		}
		if id in players && id in positions && id not_in transitions {
			for key in all_keys {
				if rl.IsKeyPressed(key) {
					current_node := players[id].at
					next_node, ok := next_state(
						connections[current_node],
						keymap[key],
					)
					if ok {
						players[id] = PlayerComponent{next_node}

						transi_timer := new_entity()
						transitions[id] = TransitionComponent {
							begin = current_node,
							end   = next_node,
							timer = transi_timer,
						}
						timers[transi_timer] = TimerComponent {
							duration = 1,
						}

						// Launch particule to all bosses
						for id_boss in bosses {
							particule_id := new_entity()
							particules[particule_id] = ParticleComponent{}
							colors[particule_id] = rl.RED
							radiuses[particule_id] = 10
							positions[particule_id] = PositionComponent{}

							particule_timer := new_entity()
							timers[particule_timer] = TimerComponent {
								duration = 0.5,
							}
							transitions[particule_id] = TransitionComponent {
								begin = current_node,
								end   = id_boss,
								timer = particule_timer,
							}
						}
						// don't look at other inputs
						break
					} else {
						shaker_timer := new_entity()
						timers[shaker_timer] = TimerComponent {
							duration = 1,
						}
						shakers[players[id].at] = ShakerComponent {
							timer = shaker_timer,
						}
					}
				}
			}
		}

		if id in nodes && id in positions && id in radiuses {
			pos := &positions[id]
			r := radiuses[id]

			delta: f32 = 0.2
			epsilon: f32 = 10 * dt // 0.1
			w0, w1: f32 = 0, 0
			grad: f32 = 0
			pos.x += delta
			w0 = nodes_weight(id)
			pos.x -= 2 * delta
			w1 = nodes_weight(id)
			pos.x += delta
			// if w0 == NaN or w1 == NaN {} // Fix error with that
			grad = (w0 - w1) / (2 * delta)
			pos.x -= grad * epsilon

			pos.y += delta
			w0 = nodes_weight(id)
			pos.y -= 2 * delta
			w1 = nodes_weight(id)
			pos.y += delta
			grad = (w0 - w1) / (2 * delta)
			pos.y -= grad * epsilon
		}

		if id in positions && id in bounds && id in radiuses {
			r := radiuses[id]
			pos := &positions[id]
			bound := bounds[id]
			if pos.x <= bound.min.x + r do pos.x = bound.min.x + r
			if pos.y <= bound.min.y + r do pos.y = bound.min.y + r
			if pos.x >= bound.max.x - r do pos.x = bound.max.x - r
			if pos.y >= bound.max.y - r do pos.y = bound.max.y - r
			positions[id] = pos^
		}

		if id in positions && id in shakers {
			positions[id] += {
				rand.float32_range(-3, 3),
				rand.float32_range(-3, 3),
			}
		}

		if id in shakers && shakers[id].timer not_in timers {
			delete_key(&shakers, id)
		}

		// Check for hover of an element
		if id in radiuses && id in positions {
			fmt.println(rl.GetScreenToWorld2D(rl.GetMousePosition(), camera))
			if length(
				   rl.GetScreenToWorld2D(rl.GetMousePosition(), camera) -
				   positions[id],
			   ) <
			   radiuses[id] {
				hovers[id] = HoverComponent{}
			} else {
				delete_key(&hovers, id)
			}
		}

		if id in random_moves && random_moves[id].timer not_in timers {
			delete_key(&random_moves, id)
		}

		if id in bosses && id not_in random_moves {
			// Boss do a random moove
			current_node := bosses[id].at
			next_node := rand.choice(connections[current_node][:]).link_to

			fmt.println("Boss MOVE :", current_node, "-", next_node)
			// Timer before next move
			random_move_timer := new_entity()
			timers[random_move_timer] = TimerComponent {
				duration = 5,
			}
			random_moves[id] = RandomMoveComponent {
				timer = random_move_timer,
			}

			// Transition for next position
			bosses[id] = BossComponent{next_node}
			transi_timer := new_entity()
			timers[transi_timer] = TimerComponent {
				duration = 3,
			}
			transitions[id] = TransitionComponent {
				begin = current_node,
				end   = next_node,
				timer = transi_timer,
			}
		}
	}
}
system_draw :: proc() {
	using ecs
	for id in entities {
		if id in healths && id in positions {
			pos := positions[id]
			health := healths[id]
			rl.DrawRectangleLinesEx(
				rl.Rectangle {
					pos.x - health_bar_width / 2,
					pos.y + 40,
					health_bar_width,
					10,
				},
				2.,
				rl.BLACK,
			)
			rl.DrawRectangleRec(
				rl.Rectangle {
					pos.x - health_bar_width / 2,
					pos.y + 40,
					health_bar_width * health.value / health.max,
					10,
				},
				rl.BLACK,
			)
		}
		if id in radiuses && id in positions {
			r := radiuses[id] + 10 if id in hovers else 0
			// color := colors[id] if id in colors else rl.GREEN
			rl.DrawCircleLinesV(positions[id], r, rl.GREEN)
		}
		if id in nodes &&
		   id in connections &&
		   id in positions &&
		   id in radiuses {
			for connection in connections[id] {
				draw_links_node(
					positions[id],
					positions[connection.link_to],
					radiuses[id],
					radiuses[connection.link_to],
					connection.letter,
				)
			}
		}
		if id in bosses && id in positions {
			pos := positions[id]
			rl.DrawTriangle(
				pos + {+20, +00},
				pos + {-10, -15},
				pos + {-10, 15},
				rl.RED,
			)
			rl.DrawTriangle(
				pos + {-20, +00},
				pos + {+10, +15},
				pos + {+10, -15},
				rl.RED,
			)
		}
		if id in players && id in positions {
			pos := positions[id]
			rl.DrawTriangle(
				pos + {10, 0},
				pos + {-10, -10},
				pos + {-10, 10},
				rl.BLUE,
			)
		}
	}
}
