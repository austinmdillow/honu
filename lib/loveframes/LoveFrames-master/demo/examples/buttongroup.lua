local example = {}
example.title = "Button Group"
example.category = "Object Demonstrations"

function example.func(loveframes, centerarea)

	local frame = loveframes.Create("frame")
	frame:SetName("Button Group with image")
	frame:CenterWithinArea(unpack(centerarea))

	local button1 = loveframes.Create("button", frame)
	button1:SetWidth(200)
	button1:SetText("Folder 1")
    button1:SetImage("resources/folder.png")
	button1:SetPos(50, 30)
    button1.groupIndex = 1

	local button2 = loveframes.Create("button", frame)
	button2:SetWidth(200)
	button2:SetText("Folder 2")
    button2:SetImage("resources/folder.png")
	button2:SetPos(50, 60)
    button2.groupIndex = 1

	local button3 = loveframes.Create("button", frame)
	button3:SetWidth(200)
	button3:SetText("File 1")
    button3:SetImage("resources/file.png")
	button3:SetPos(50, 90)
    button3.groupIndex = 2

	local button4 = loveframes.Create("button", frame)
	button4:SetWidth(200)
	button4:SetText("File 2")
    button4:SetImage("resources/file.png")
	button4:SetPos(50, 120)
    button4.groupIndex = 2

end

return example
