package main

import "core:fmt"
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

load_level_0 :: proc(node_entry: EntityHandle) -> (nodes_out: []EntityHandle) {
	using ecs
	level_id := 0

	ids: [dynamic]EntityHandle
	defer delete(ids)

	for i in 0 ..= 4 {
		handle := new_entity()
		append(&ids, handle)
		nodes[handle] = NodeComponent{}
		positions[handle] =
			{
				f32(i % 2) * spacing_base + radius_base,
				f32(i / 2) * spacing_base + radius_base,
			} +
			levels_bound[level_id].min
		bounds[handle] = levels_bound[level_id]
		radiuses[handle] = radius_base
	}

	connections[node_entry] = ConnectionComponent{{"a", ids[0]}}

	append_connection(ids[0], {"a", ids[1]})
	append_connection(ids[1], {"a", ids[2]})
	append_connection(ids[1], {"b", ids[4]})
	append_connection(ids[2], {"a", ids[3]})
	append_connection(ids[2], {"b", ids[1]})
	append_connection(ids[3], {"a", ids[1]})
	append_connection(ids[4], {"b", ids[1]})

	// BOSS
	boss := new_entity()
	fmt.println("IDS[4]:", ids[4], ecs.positions[ids[4]])
	bosses[boss] = BossComponent{ids[4]}
	healths[boss] = HealthComponent{100, 100}
	positions[boss] = ecs.positions[ids[4]]


	fmt.printf("Loading level {} DONE\n", level_id)
	nodes_out = {ids[4]}
	return
}

load_level_1 :: proc(node_entry: EntityHandle) {
	using ecs
	level_id := 1

	ids: [dynamic]EntityHandle
	defer delete(ids)

	for i in 0 ..= 4 {
		handle := new_entity()
		append(&ids, handle)

		nodes[handle] = NodeComponent{}
		positions[handle] =
			{
				f32(i % 2) * spacing_base + radius_base,
				f32(i / 2) * spacing_base + radius_base,
			} +
			levels_bound[level_id].min
		bounds[handle] = levels_bound[level_id]
		radiuses[handle] = radius_base
	}

	append_connection(node_entry, {"e", ids[0]})

	append_connection(ids[0], {"a", ids[1]})
	append_connection(ids[1], {"a", ids[2]})
	append_connection(ids[1], {"b", ids[4]})
	append_connection(ids[2], {"a", ids[3]})
	append_connection(ids[2], {"b", ids[1]})
	append_connection(ids[3], {"a", ids[1]})
	append_connection(ids[4], {"b", ids[1]})


	fmt.printf("Loading level {} DONE\n", level_id)
	// player := new_entity()
	// set_component(player, PlayerComponent{ids[0]})
}
