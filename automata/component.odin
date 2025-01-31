package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

// Health bar of a given entity
HealthComponent :: struct {
	value: f32,
	max:   f32,
}
RandomMoveComponent :: struct {
	timer: EntityHandle,
}
// Entity that are linked to another entity (position)
FixedAtComponent :: struct {}
// Entity that is a boss
BossComponent :: struct {
	at: EntityHandle,
}
// Entity that is a player
PlayerComponent :: struct {
	at: EntityHandle,
}
ConnectionComponent :: [dynamic]Connection
Connection :: struct {
	letter:  string,
	link_to: EntityHandle,
}
// Try
NewConnectionComponent :: struct {
	begin:  EntityHandle,
	letter: string,
	end:    EntityHandle,
}
ShakerComponent :: struct {
	timer: EntityHandle,
}
NodeComponent :: struct {}
ColorFillComponent :: rl.Color
RadiusComponent :: f32
PositionComponent :: Vec2
HoverComponent :: struct {}
TransitionComponent :: struct {
	begin: EntityHandle,
	end:   EntityHandle,
	timer: EntityHandle,
}
TimerComponent :: struct {
	t:        f32, // between 0 and 1
	duration: f32,
}
TimerFinishedComponent :: struct {}
ParticleComponent :: struct {}
BoundComponent :: struct {
	min: Vec2,
	max: Vec2,
}

append_connection :: proc(id: EntityHandle, connection: Connection) {
	using ecs
	if id in connections {
		append(&connections[id], connection)
	} else {
		connections[id] = {connection}
	}
}

// Operation on Component
next_state :: proc(
	connection: ConnectionComponent,
	letter: string,
) -> (
	player: EntityHandle,
	ok: bool,
) {
	for con in connection {
		if con.letter == letter {
			player = con.link_to
			ok = true
			return
		}
	}
	ok = false
	return
}

spring_force :: proc(l, l0, k: f32) -> f32 {
	return k * math.abs(l - l0)
}

nodes_weight :: proc(entity: EntityHandle) -> (weight: f32) {
	using ecs
	l0: f32 = 300
	k: f32 = 10
	mu: f32 = math.pow(k, 6)
	// All connections from entity
	if connections_entity, ok := connections[entity]; ok {
		for t in connections_entity {
			begin := positions[entity]
			end := positions[t.link_to]
			weight += spring_force(l = length(end - begin), l0 = l0, k = k)
		}
	}
	// All connection to entity
	for id, connections_id in connections {
		for t in connections_id {
			if t.link_to == entity {
				begin := positions[id]
				end := positions[entity]
				weight += spring_force(l = length(end - begin), l0 = l0, k = k)
			}
		}
	}
	for id1, p1 in positions {
		if id1 in nodes {
			for id2, p2 in positions {
				if id2 in nodes && p1 != p2 && id1 != id2 {
					weight += mu / length(p1 - p2)
				}
			}
		}
	}

	return
}
