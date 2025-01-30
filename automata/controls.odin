package main

import rl "vendor:raylib"

controls_info_draw :: proc() {
	rl.DrawTextPro(
		font,
		"[letter] to move to a new transition",
		{10, 10},
		{0, 0},
		0,
		20,
		2,
		rl.BLACK,
	)
	rl.DrawTextPro(
		font,
		"Mouse Scroll to zoom or unzoom",
		{10, 30},
		{0, 0},
		0,
		20,
		2,
		rl.BLACK,
	)
	// rl.DrawTextPro(
	// 	font,
	// 	"Up - Down - Right - Left to move the camera",
	// 	{10, 50},
	// 	{0, 0},
	// 	0,
	// 	20,
	// 	2,
	// 	rl.BLACK,
	// )
}
