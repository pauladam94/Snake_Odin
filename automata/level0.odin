package main

import "core:fmt"

load_level_0 :: proc(node_entry: EntityHandle) -> (nodes_out: []EntityHandle) {
	level_id := 0

	ids: [dynamic]EntityHandle
	defer delete(ids)

	for i in 0 ..= 4 {
		handle := new_entity()
		append(&ids, handle)
		set_component(handle, NodeComponent{})
		set_component(
			handle,
			position(
				{
					f32(i % 2) * spacing_base + radius_base,
					f32(i / 2) * spacing_base + radius_base,
				} +
				levels_bound[level_id].min,
			),
		)
		set_component(handle, levels_bound[level_id])
		set_component(handle, CircleComponent{radius_base})
	}

	set_component(node_entry, ConnectionComponent{{"a", ids[0]}})

	append_connection(ids[0], {"a", ids[1]})
	append_connection(ids[1], {"a", ids[2]})
	append_connection(ids[1], {"b", ids[4]})
	append_connection(ids[2], {"a", ids[3]})
	append_connection(ids[2], {"b", ids[1]})
	append_connection(ids[3], {"a", ids[1]})
	append_connection(ids[4], {"b", ids[1]})

	// BOSS
	boss := new_entity()
	fmt.println("IDS[4]:", ids[4], ecs.positions[ids[4]].?)
	set_component(boss, BossComponent{ids[4]})
	set_component(boss, HealthComponent{10, 20})
	set_component(boss, position(ecs.positions[ids[4]].?))


	fmt.printf("Loading level {} DONE\n", level_id)
	nodes_out = {ids[4]}
	return
}
