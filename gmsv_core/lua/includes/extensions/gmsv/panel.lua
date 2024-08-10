local ErrorNoHaltWithStack = ErrorNoHaltWithStack
local isfunction = isfunction
local pcall = pcall
local vgui_GetAll = vgui.GetAll

local PANEL = FindMetaTable("Panel")
local PANEL_IsVisible = PANEL.IsVisible

local Second = false

timer.Create("Panel_SlowThink", 0.5, 0, function()
	local Success, ErrorMessage
	local Panels = vgui_GetAll()

	for i = 1, #Panels do
		local CurrentPanel = Panels[i]
		if not PANEL_IsVisible(CurrentPanel) then continue end

		-- SlowThink every half second
		if isfunction(CurrentPanel.SlowThink) then
			Success, ErrorMessage = pcall(CurrentPanel.SlowThink, CurrentPanel)

			if not Success then
				ErrorNoHaltWithStack(ErrorMessage)
			end
		end

		-- SlowerThink every half second
		if Second and isfunction(CurrentPanel.SlowerThink) then
			Success, ErrorMessage = pcall(CurrentPanel.SlowerThink, CurrentPanel)

			if not Success then
				ErrorNoHaltWithStack(ErrorMessage)
			end
		end
	end

	-- Tell the next iteration where we are
	Second = not Second
end)
