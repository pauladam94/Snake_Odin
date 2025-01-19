package main

import "core:fmt"
import "core:math"
import "core:mem"
import "core:strings"
import "core:time"
import rl "vendor:raylib"

Vec2 :: rl.Vector2
Letter :: string
Node :: i32
NodeType :: enum {
	ATTACK,
	IDLE,
}
Transition :: struct {
	begin:  Node,
	letter: Letter,
	end:    Node,
}
Automata :: struct {
	nodes:           [dynamic]Node,
	nodes_radius:    [dynamic]f32,
	nodes_positions: [dynamic]Vec2,
	current:         Node,
	evil:            Node,
	transition:      [dynamic]Transition,
}

length :: proc(v: Vec2) -> f32 {
	return math.sqrt(v.x * v.x + v.y * v.y)
}
normalize :: proc(v: Vec2) -> Vec2 {
	return v / length(v)
}
orthogonal :: proc(v: Vec2) -> Vec2 {
	return normalize(Vec2{-v.y, v.x})
}

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

automata_next_state :: proc(a: ^Automata, c: string) {
	for transition in a.transition {
		if transition.begin == a.current && transition.letter == c {
			a.current = transition.end
			return
		}
	}
}

automata_draw :: proc(a: Automata) {
	col: rl.Color
	for pos, i in a.nodes_positions {
		rl.DrawCircleV(pos, a.nodes_radius[i], rl.GREEN)
		if i32(i) == a.current {
			rl.DrawTriangle(
				pos + {10, 0},
				pos + {-10, -10},
				pos + {-10, 10},
				rl.RED,
			)
		}
	}
	for t in a.transition {
		r_begin := a.nodes_radius[t.begin]
		r_end := a.nodes_radius[t.end]
		begin := a.nodes_positions[t.begin]
		end := a.nodes_positions[t.end]

		draw_links_node(begin, end, r_begin, r_end, t.letter)
	}
}

automata_init :: proc(
	nodes: []Node,
	transition: []Transition,
) -> (
	a: Automata,
) {
	id := new_entity()

	for t in transition {
		append(&a.transition, t)
	}
	for n in nodes {
		append(&a.nodes, n)
	}
	if len(a.nodes) > 0 {
		a.current = a.nodes[0]
	} else {
		fmt.println("Automata must have at least one node")
	}

	r: f32 = 40.
	space: f32 = 400.
	for node, i in a.nodes {
		append(&a.nodes_radius, r)
		x: f32 = f32(i % 2) * space + r
		y: f32 = f32(i / 2) * space + r
		append(&a.nodes_positions, Vec2{x, y})
	}
	return
}
automata_delete :: proc(a: Automata) {
	delete(a.transition)
	delete(a.nodes)
	delete(a.nodes_radius)
	delete(a.nodes_positions)
}
automata_weight :: proc(a: ^Automata) -> (weight: f32 = 0) {
	l0: f32 = 300
	k: f32 = 10
	mu: f32 = math.pow(k, 6)
	for t in a.transition {
		begin := a.nodes_positions[t.begin]
		end := a.nodes_positions[t.end]
		weight += k * math.abs(length(end - begin) - l0)
	}
	for p1 in a.nodes_positions {
		for p2 in a.nodes_positions {
			if p1 != p2 {
				weight += mu / length(p1 - p2)
			}
		}
	}
	return
}
automata_gradient_move :: proc(a: ^Automata) {
	delta: f32 = 0.2
	epsilon: f32 = 0.1
	w0, w1: f32 = 0, 0
	grad: f32 = 0
	for id in a.nodes {
		p := &a.nodes_positions[id]
		r := a.nodes_radius[id]
		p.x += delta
		w0 = automata_weight(a)
		p.x -= 2 * delta
		w1 = automata_weight(a)
		p.x += delta
		grad = (w0 - w1) / (2 * delta)
		p.x -= grad * epsilon
		if (p.x >= width - r) {p.x = width - r}
		if (p.x <= r) {p.x = r}

		p.y += delta
		w0 = automata_weight(a)
		p.y -= 2 * delta
		w1 = automata_weight(a)
		p.y += delta
		grad = (w0 - w1) / (2 * delta)
		p.y -= grad * epsilon
		if (p.y >= height - r) {p.y = height - r}
		if (p.y <= r) {p.y = r}
	}
}
automata_update :: proc(a: ^Automata) {
	switch {
	case rl.IsKeyPressed(rl.KeyboardKey.A):
		automata_next_state(a, "a")
	case rl.IsKeyPressed(rl.KeyboardKey.B):
		automata_next_state(a, "b")
	case rl.IsKeyPressed(rl.KeyboardKey.C):
		automata_next_state(a, "c")
	}
	automata_gradient_move(a)
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

	a := automata_init(
		{0, 1, 2, 3, 4},
		{
			Transition{0, "a", 1},
			Transition{1, "a", 2},
			Transition{2, "a", 3},
			Transition{2, "b", 1},
			Transition{3, "a", 1},
			Transition{1, "b", 4},
			Transition{4, "b", 1},
		},
	)
	defer automata_delete(a)

	init_game()
	for !rl.WindowShouldClose() {

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		automata_draw(a)
		rl.EndDrawing()

		automata_update(&a)
	}
	rl.CloseWindow()
}
