package main

import "core:math"
import rl "vendor:raylib"

Vec2 :: rl.Vector2

length :: proc(v: Vec2) -> f32 {
	return math.sqrt(v.x * v.x + v.y * v.y)
}
normalize :: proc(v: Vec2) -> Vec2 {
	return v / length(v)
}
orthogonal :: proc(v: Vec2) -> Vec2 {
	return normalize(Vec2{-v.y, v.x})
}

