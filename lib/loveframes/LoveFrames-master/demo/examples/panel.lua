local example = {}
example.title = "Panel"
example.category = "Object Demonstrations"

function example.func(loveframes, centerarea)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Panel")
	frame:SetSize(210, 85)
	frame:CenterWithinArea(unpack(centerarea))
		
	local panel = loveframes.Create("panel", frame)
	panel:SetPos(5, 30)
	
end

return example