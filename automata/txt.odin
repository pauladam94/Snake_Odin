package main

import "core:strings"
import rl "vendor:raylib"

DrawTxt :: proc(s: string, pos: Vec2, size: f32 = 20) {
	txt: cstring = strings.clone_to_cstring(s)
	defer delete(txt)
	defer delete(s)
	rl.DrawTextPro(font, txt, pos, {0, 0}, 0., size, 2., rl.BLACK)
}
