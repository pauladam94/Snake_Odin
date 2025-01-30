package main

import rl "vendor:raylib"

performance_info_draw :: proc() {
	rl.DrawFPS(width - 100, height - 20)
}
