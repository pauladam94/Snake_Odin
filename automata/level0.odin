package main

import "core:fmt"

load_level0 :: proc() {
	level_id := 0
	r: f32 = 40.
	space: f32 = 400.

	ids: [dynamic]EntityHandle
	defer delete(ids)

	for i in 0 ..= 4 {
		handle := new_entity()
		append(&ids, handle)
		set_component(handle, NodeComponent{})
		set_component(
			handle,
			PositionComponent {
				{f32(i % 2) * space + r, f32(i / 2) * space + r},
				{0, 0},
				{0, 0},
				0,
			},
		)
		set_component(handle, levels_bound[level_id])
		set_component(handle, CircleComponent{r})
	}

	set_component(ids[0], ConnectionComponent{{"a", ids[1]}})
	set_component(ids[1], ConnectionComponent{{"a", ids[2]}, {"b", ids[4]}})
	set_component(ids[2], ConnectionComponent{{"a", ids[3]}, {"b", ids[1]}})
	set_component(ids[3], ConnectionComponent{{"a", ids[1]}})
	set_component(ids[4], ConnectionComponent{{"b", ids[1]}})

	player := new_entity()
	set_component(player, PlayerComponent{ids[0]})
}
