local example = {}
example.title = "Image Button"
example.category = "Object Demonstrations"

function example.func(loveframes, centerarea)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Image Button")
	frame:SetSize(138, 163)
	frame:CenterWithinArea(unpack(centerarea))
		
	local imagebutton = loveframes.Create("imagebutton", frame)
	imagebutton:SetImage("resources/magic.png")
	imagebutton:SetPos(5, 30)
	imagebutton:SizeToImage()
	imagebutton:Center()
	
end

return example
