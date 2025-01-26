package main


camera_update :: proc() {

}

camera_init :: proc() {
	camera.zoom = 1
	camera.offset = {0, 0}
	camera.target = {0, 0}
	camera.rotation = 0
}
