extends VideoPlayer

#Tells us aspect ratio
var aspect_ratio = 16.0/9.0

func _ready():
	
	#Finds the size of the viewport
	var vsize = get_viewport_rect().size
	#Gets the colorrect to the size of the ciewport
	get_parent().get_node("ColorRect").set_size(vsize)
	#How tall and how wide it is and would figure it out and if the video is not tall enough it sqqueezes it
	if vsize.y < vsize.x / aspect_ratio:
		set_size(Vector2(vsize.y * aspect_ratio, vsize.y))
		set_position(Vector2( (vsize.x - vsize.y * aspect_ratio) / 2, 0))
	else:
		set_size(Vector2(vsize.x, vsize.x / aspect_ratio))
		set_position(Vector2(0, (vsize.y - vsize.x / aspect_ratio)))
		
		
