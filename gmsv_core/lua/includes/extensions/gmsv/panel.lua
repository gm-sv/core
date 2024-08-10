local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local isfunction = isfunction
local pcall = pcall
local vgui_GetAll = vgui.GetAll

local PANEL = FindMetaTable("Panel")

local PANEL_IsVisible = PANEL.IsVisible

timer.Create("Panel_SlowThink", 1, 0, function()
	local Success, ErrorMessage
	local Panels = vgui_GetAll()

	for i = 1, #Panels do
		local CurrentPanel = Panels[i]
		if not PANEL_IsVisible(CurrentPanel) then continue end
		if not isfunction(CurrentPanel.SlowThink) then continue end

		Success, ErrorMessage = pcall(CurrentPanel.SlowThink, CurrentPanel)

		if not Success then
			ErrorNoHaltWithStack(ErrorMessage)
		end
	end
end)
