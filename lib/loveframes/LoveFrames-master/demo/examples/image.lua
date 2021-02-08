local example = {}
example.title = "Image"
example.category = "Object Demonstrations"

function example.func(loveframes, centerarea)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Image")
	frame:SetSize(138, 340)
	frame:CenterWithinArea(unpack(centerarea))
		
	local image = loveframes.Create("image", frame)
	image:SetImage("resources/magic.png")
	image:SetPos(5, 30)
	image:SetSize(128, 120)
		
	local panel = loveframes.Create("panel", frame)
	panel:SetPos(5, 160)
	panel:SetSize(128, 170)
		
	local text1 = loveframes.Create("text", panel)
	text1:SetPos(5, 5)
	text1:SetText("Orientation: ")
		
	local slider1 = loveframes.Create("slider", panel)
	slider1:SetPos(5, 20)
	slider1:SetWidth(118)
	slider1:SetMinMax(0, loveframes.Round(math.pi * 2, 5))
	slider1:SetDecimals(5)
	slider1.OnValueChanged = function(object)
		image:SetOrientation(object:GetValue())
	end
		
	text1.Update = function(object, dt)
		local value = slider1:GetValue()
		local max = slider1:GetMax()
		local progress = value/max
		local final = loveframes.Round(360 * progress)
		object:SetText("Orientation: " ..final)
	end
		
	local text2 = loveframes.Create("text", panel)
	text2:SetPos(5, 40)
	text2:SetText("Scale")
		
	local slider2 = loveframes.Create("slider", panel)
	slider2:SetPos(5, 55)
	slider2:SetWidth(118)
	slider2:SetMinMax(.5, 2)
	slider2:SetValue(1)
	slider2:SetDecimals(5)
	slider2.OnValueChanged = function(object)
		image:SetScale(object:GetValue(), object:GetValue())
	end
		
	text2.Update = function(object, dt)
		object:SetText("Scale: " ..slider2:GetValue())
	end
		
	local text3 = loveframes.Create("text", panel)
	text3:SetPos(5, 75)
	text3:SetText("Offset")
		
	local slider3 = loveframes.Create("slider", panel)
	slider3:SetPos(5, 90)
	slider3:SetWidth(118)
	slider3:SetMinMax(0, 50)
	slider3:SetDecimals(5)
	slider3.OnValueChanged = function(object)
		image:SetOffset(object:GetValue(), object:GetValue())
	end
		
	text3.Update = function(object, dt)
		object:SetText("Offset: " ..slider3:GetValue())
	end
		
	local text4 = loveframes.Create("text", panel)
	text4:SetPos(5, 110)
	text4:SetText("Shear")
		
	local slider4 = loveframes.Create("slider", panel)
	slider4:SetPos(5, 125)
	slider4:SetWidth(118)
	slider4:SetMinMax(0, 40)
	slider4:SetDecimals(5)
	slider4.OnValueChanged = function(object)
		image:SetShear(object:GetValue(), object:GetValue())
	end
		
	text4.Update = function(object, dt)
		object:SetText("Shear: " ..slider4:GetValue())
	end
	
    local checkbox5 = loveframes.Create("checkbox", panel)
	checkbox5:SetText("Stretched")
	checkbox5:SetPos(5, 150)
	checkbox5.OnChanged = function(object, value)
		image.stretch = value
	end

end

return example

