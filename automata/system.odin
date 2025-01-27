package main

import "core:fmt"
import rl "vendor:raylib"

system_update :: proc() {
	using ecs

	for id in entities {
		node, has_node := nodes[id].?
		circle, has_circle := circles[id].?
		pos, has_position := &positions[id].?
		connection, has_connection := connections[id].?
		player, has_player := players[id].?
		bound, has_bound := bounds[id].?
		boss, has_boss := bosses[id].?

		if has_position {
			position_update(pos)
		}
		if has_boss && has_position {
			pos.end = positions[boss.at].?
		}
		if has_player && has_position {
			pos.end = positions[player.at].?
			if !pos.in_transition {
				for key in all_keys {
					if rl.IsKeyPressed(key) {
						st, ok := next_state(
							connections[player.at].?,
							keymap[key],
						)
						if ok {
							set_component(id, st)
							pos.in_transition = true
							pos.transition = 0
							pos.begin = pos.pos
							pos.end = positions[st.at].?
						}
					}
				}
			}
		}

		if has_node && has_position && has_circle {
			delta: f32 = 0.2
			epsilon: f32 = 0.1
			w0, w1: f32 = 0, 0
			grad: f32 = 0
			p := pos
			r := circle.radius
			p.x += delta
			w0 = nodes_weight(id)
			p.x -= 2 * delta
			w1 = nodes_weight(id)
			p.x += delta
			// if w0 == NaN or w1 == NaN {} // Fix error with that
			grad = (w0 - w1) / (2 * delta)
			p.x -= grad * epsilon

			p.y += delta
			w0 = nodes_weight(id)
			p.y -= 2 * delta
			w1 = nodes_weight(id)
			p.y += delta
			grad = (w0 - w1) / (2 * delta)
			p.y -= grad * epsilon

			pos.end = p.pos
		}

		if has_position && has_bound && has_circle {
			r := circle.radius
			if pos.x <= bound.min.x + r do pos.x = bound.min.x + r
			if pos.y <= bound.min.y + r do pos.y = bound.min.y + r
			if pos.x >= bound.max.x - r do pos.x = bound.max.x - r
			if pos.y >= bound.max.y - r do pos.y = bound.max.y - r
			set_component(id, pos^)
		}
	}
}
system_draw :: proc() {
	using ecs
	for id in entities {
		node, has_node := nodes[id].?
		circle, has_circle := circles[id].?
		pos, has_position := positions[id].?
		connection, has_connection := connections[id].?
		player, has_player := players[id].?
		boss, has_boss := bosses[id].?
		bound, has_bound := bounds[id].?
		health, has_health := healths[id].?

		if has_health && has_position {
			rl.DrawRectangleLinesEx(
				rl.Rectangle {
					pos.x - health_bar_width / 2,
					pos.y + 30,
					health_bar_width,
					10,
				},
				2.,
				rl.BLACK,
			)
			rl.DrawRectangleRec(
				rl.Rectangle {
					pos.x - health_bar_width / 2,
					pos.y + 30,
					health_bar_width * health.value / health.max,
					10,
				},
				rl.BLACK,
			)
		}
		if has_circle && has_node && has_position {
			draw_circle(circle, pos)
		}

		if has_node && has_connection && has_position && has_circle {
			for con in connection {
				pos2 := positions[con.link_to].?
				circle2 := circles[con.link_to].?
				draw_links_node(
					pos,
					pos2,
					circle.radius,
					circle2.radius,
					con.letter,
				)
			}
		}
		if has_boss && has_position {
			rl.DrawTriangle(
				pos.pos + {+20, +00},
				pos.pos + {-10, -15},
				pos.pos + {-10, 15},
				rl.RED,
			)
			rl.DrawTriangle(
				pos.pos + {-20, +00},
				pos.pos + {+10, +15},
				pos.pos + {+10, -15},
				rl.RED,
			)
		}
		if has_player && has_position {
			rl.DrawTriangle(
				pos.pos + {10, 0},
				pos.pos + {-10, -10},
				pos.pos + {-10, 10},
				rl.BLUE,
			)
		}
	}
}

draw_circle :: proc(circle: CircleComponent, pos: PositionComponent) {
	rl.DrawCircleLinesV(pos, circle.radius, rl.GREEN)
}
