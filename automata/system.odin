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

		if has_position {
			// position_update(pos)
		}

		if has_player {
			switch {
			case rl.IsKeyPressed(.A):
				st, ok := next_state(connections[player.at].?, "a")
				set_component(id, st)
			case rl.IsKeyPressed(.B):
				st, ok := next_state(connections[player.at].?, "b")
				set_component(id, st)
			case rl.IsKeyPressed(.C):
				st, ok := next_state(connections[player.at].?, "c")
				set_component(id, st)
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
			grad = (w0 - w1) / (2 * delta)
			p.x -= grad * epsilon

			p.y += delta
			w0 = nodes_weight(id)
			p.y -= 2 * delta
			w1 = nodes_weight(id)
			p.y += delta
			grad = (w0 - w1) / (2 * delta)
			p.y -= grad * epsilon
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
		if has_player {
			pos2 := positions[player.at].?
			rl.DrawTriangle(
				pos2.pos + {10, 0},
				pos2.pos + {-10, -10},
				pos2.pos + {-10, 10},
				rl.RED,
			)
		}
	}
}

draw_circle :: proc(circle: CircleComponent, pos: PositionComponent) {
	rl.DrawCircleV(pos, circle.radius, rl.GREEN)
}
