package main

import "core:fmt"
import "core:math"
import "core:mem"
import "core:strings"
import "core:time"
import rl "vendor:raylib"

Letter :: string

draw_links_node :: proc(begin: Vec2, end: Vec2, rb, re: f32, letter: string) {
	color := rl.BLACK
	thick: f32 = 3
	dir := normalize(end - begin)
	ortho := orthogonal(dir)

	cos_pi_2 := math.sqrt(f32(2.)) / 2

	prec_begin := begin + (ortho + dir) * cos_pi_2 * rb
	mid := 2 * max(rb, re) * ortho + (end + begin) / 2
	prec_end := end + (ortho - dir) * cos_pi_2 * re

	// Creation of C Array
	ps: []Vec2 = []Vec2{prec_begin, mid, prec_end}
	points: [^]Vec2 = raw_data(ps[:])
	rl.DrawSplineBezierQuadratic(points, 3, thick, color)

	incident_angle := normalize(end - mid)
	// incident_angle = ortho - dir
	rl.DrawTriangle(
		prec_end,
		prec_end -
		(thick * 4) * normalize(incident_angle) -
		(thick * 2) * orthogonal(incident_angle),
		prec_end -
		(thick * 4) * normalize(incident_angle) +
		(thick * 2) * orthogonal(incident_angle),
		color,
	)
	// Drawing the text of the transition
	s: cstring = strings.clone_to_cstring(letter)
	defer delete_cstring(s)

	mid = mid * 0.8 + 0.2 * (end + begin) / 2

	rl.DrawTextPro(
		font,
		s,
		mid - rl.MeasureTextEx(font, s, font_size, text_spacing) / 2,
		{0, 0},
		0,
		font_size,
		text_spacing,
		rl.BLACK,
	)
}

main :: proc() {
	when ODIN_DEBUG {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)
		defer {
			if len(track.allocation_map) > 0 {
				fmt.eprintf(
					"=== %v allocations not freed: ===\n",
					len(track.allocation_map),
				)
				for _, entry in track.allocation_map {
					fmt.eprintf(
						"- %v bytes @ %v\n",
						entry.size,
						entry.location,
					)
				}
			}
			if len(track.bad_free_array) > 0 {
				fmt.eprintf(
					"=== %v incorrect frees: ===\n",
					len(track.bad_free_array),
				)
			}
		}
		mem.tracking_allocator_destroy(&track)
	}

	defer delete_ecs()

	// INITIAL NODE
	begin_node := new_entity()
	ecs.nodes[begin_node] = NodeComponent{}
	ecs.positions[begin_node] = PositionComponent{0, 0}
	ecs.radiuses[begin_node] = 50

	// PLAYER
	player := new_entity()
	ecs.players[player] = PlayerComponent{begin_node}
	ecs.healths[player] = HealthComponent{90, 100}
	ecs.positions[player] = ecs.positions[begin_node]

	out: []EntityHandle = load_level_0(begin_node)
	load_level_1(out[0])

	init_game()

	for !rl.WindowShouldClose() {
		// UPDATE
		//--------
		dt = rl.GetFrameTime()
		system_update()
		camera_controls_update()
		camera_focus_player(player)

		// DRAW
		//------
		rl.BeginDrawing()
		rl.BeginMode2D(camera)

		rl.ClearBackground(rl.WHITE)
		levels_draw_bound()
		system_draw()

		rl.EndMode2D()

		// STATIC DRAWING
		controls_info_draw()
		when ODIN_DEBUG {performance_info_draw()}
		when ODIN_DEBUG {ecs_debug_draw()}

		rl.EndDrawing()
	}

	rl.CloseWindow()
}
