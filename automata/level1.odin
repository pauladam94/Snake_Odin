package main

import "core:fmt"

load_level_1 :: proc(node_entry: EntityHandle) {
	level_id := 1

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
