package main

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

EntityHandle :: int

Components :: struct {
	// linkto:      [dynamic]Maybe(LinkTo),
	bosses:          map[EntityHandle](BossComponent),
	bounds:          map[EntityHandle](BoundComponent),
	connections:     map[EntityHandle](ConnectionComponent),
	colors:          map[EntityHandle](ColorFillComponent),

	// TRY
	new_connections: map[EntityHandle](NewConnectionComponent),
	// TRY
	healths:         map[EntityHandle](HealthComponent),
	hovers:          map[EntityHandle](HoverComponent),
	nodes:           map[EntityHandle](NodeComponent),
	particules:      map[EntityHandle](ParticleComponent),
	players:         map[EntityHandle](PlayerComponent),
	positions:       map[EntityHandle](PositionComponent),
	radiuses:        map[EntityHandle](RadiusComponent),
	random_moves:    map[EntityHandle](RandomMoveComponent),
	shakers:         map[EntityHandle](ShakerComponent),
	transitions:     map[EntityHandle](TransitionComponent),
	timers:          map[EntityHandle](TimerComponent),
	timers_finished: map[EntityHandle](TimerFinishedComponent),
}
ECS :: struct {
	using components: Components,
	// All entities
	entities:         [dynamic]EntityHandle,
}

new_id :: proc() -> (new_id: EntityHandle) {
	new_id = static_id
	static_id += 1
	return
}

new_entity :: proc() -> (id: EntityHandle) {
	id = new_id()
	append(&ecs.entities, id)
	return
}

delete_entity :: proc(id: EntityHandle) {
	using ecs

	delete_key(&bosses, id)
	delete_key(&bounds, id)
	delete_key(&connections, id)
	delete_key(&colors, id)
	delete_key(&healths, id)
	delete_key(&hovers, id)
	delete_key(&nodes, id)
	delete_key(&players, id)
	delete_key(&positions, id)
	delete_key(&particules, id)
	delete_key(&radiuses, id)
	delete_key(&random_moves, id)
	delete_key(&shakers, id)
	delete_key(&transitions, id)
	delete_key(&timers, id)

	for handle, i in entities {
		if id == handle {
			unordered_remove(&entities, i)
		}
	}
	fmt.println("Deleted Entity: ", id)
}

delete_ecs :: proc() {
	using ecs
	for id in connections {
		delete(connections[id])
	}

	delete(bosses)
	delete(bounds)
	delete(connections)
	delete(colors)
	delete(healths)
	delete(hovers)
	delete(nodes)
	delete(players)
	delete(positions)
	delete(particules)
	delete(radiuses)
	delete(random_moves)
	delete(shakers)
	delete(transitions)
	delete(timers)

	delete(entities)
}

ecs_debug_draw :: proc() {
	using ecs

	if rl.IsKeyPressed(.UP) do show_id += 1
	if rl.IsKeyPressed(.DOWN) do show_id -= 1

	show_id_exists: bool
	for id in entities {
		if id == show_id do show_id_exists = true
	}
	DrawTxt(fmt.aprintf("{}", entities), {width / 2, 0})

	x: f32 = width - 300
	spacing: f32 = 20
	DrawTxt(fmt.aprintf("Id: {}", show_id), {x, spacing * 1})
	if !show_id_exists do return
	if show_id in bosses {
		DrawTxt(fmt.aprintf("Boss: {}", bosses[show_id].at), {x, spacing * 2})
	}
	if show_id in hovers {
		DrawTxt(fmt.aprintf("Hovers: {}", hovers[show_id]), {x, spacing * 3})
	}
	DrawTxt(
		fmt.aprintf(
			"begin:{} end:{}",
			transitions[show_id].begin,
			transitions[show_id].end,
		),
		{x, spacing * 4},
	)

	DrawTxt(fmt.aprintf("Timer: {}", timers[show_id].t), {x, spacing * 5})
}
