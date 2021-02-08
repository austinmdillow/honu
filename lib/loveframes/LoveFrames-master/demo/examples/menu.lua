local example = {}
example.title = "Menu"
example.category = "Object Demonstrations"

function example.func(loveframes, centerarea)
	
	local frame = loveframes.Create("frame")
	frame:SetName("Menu")
	frame:CenterWithinArea(unpack(centerarea))
	
	local text = loveframes.Create("text", frame)
	text:SetText("Right click this frame to see an \n example of the menu object")
	text:Center()
	
	
	local submenu3 = loveframes.Create("menu")
	submenu3:AddOption("Option 1", false, function() end)
	submenu3:AddOption("Option 2", false, function() end)
		
	local submenu2 = loveframes.Create("menu")
	submenu2:AddOption("Option 1", "resources/food/FishFillet.png", function() end)
	submenu2:AddOption("Option 2", "resources/food/FishSteak.png", function() end)
	submenu2:AddOption("Option 3", "resources/food/Shrimp.png", function() end)
	submenu2:AddOption("Option 4", "resources/food/Sushi.png", function() end)
		
	local submenu1 = loveframes.Create("menu")
	submenu1:AddSubMenu("Option 1", "resources/food/Cookie.png", submenu3)
	submenu1:AddSubMenu("Option 2", "resources/food/Fish.png", submenu2)
		
	local menu = loveframes.Create("menu")
	menu:AddOption("Option A", "resources/food/Eggplant.png", function() end)
	menu:AddOption("Option B", "resources/food/Eggs.png", function() end)
	menu:AddDivider()
	menu:AddOption("Option C", "resources/food/Cherry.png", function() end)
	menu:AddOption("Option D", "resources/food/Honey.png", function() end)
	menu:AddDivider()
	menu:AddSubMenu("Option E", false, submenu1)
	menu:SetVisible(false)
	
	frame.menu_example = menu
	text.menu_example = menu
	
end

return example
