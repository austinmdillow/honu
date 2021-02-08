local example = {}
example.title = "Tabs"
example.category = "Object Demonstrations"

function example.func(loveframes, centerarea)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Tabs")
	frame:SetSize(500, 300)
	frame:CenterWithinArea(unpack(centerarea))
		
	local tabs = loveframes.Create("tabs", frame)
	tabs:SetPos(5, 30)
	tabs:SetSize(490, 265)
		
	local imagelist = loveframes.GetDirectoryContents("resources/food/")
	local images = {}
	for i, v in ipairs(imagelist) do
		if v.extension == "png" then table.insert(images, v.fullpath) end
	end
	
	for i=1, 20 do
		local image = images[math.random(1, #images)]
		local panel = loveframes.Create("panel")
		panel.Draw = function()
		end
		local text = loveframes.Create("text", panel)
		text:SetText("Tab " ..i)
		text:SetAlwaysUpdate(true)
		text.Update = function(object, dt)
			object:Center()
		end
		tabs:AddTab("Tab " ..i, panel, "Tab " ..i, image)
	end
	
end

return example