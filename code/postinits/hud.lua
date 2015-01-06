if IsSingleplayer() then
	TheMod:AddClassPostConstruct("screens/playerhud", function(hud)
		if Pred.IsCloudLevel() then
			_G.scheduler:ExecuteInTime(0, function()
				local Text = require "widgets/text"

				local alphawarning
				local controls = hud.controls
				if controls then
					alphawarning = controls.alphawarning
					if not alphawarning and controls.top_root then
						alphawarning = controls.top_root:AddChild(Text(_G.TITLEFONT, 40))
						alphawarning:SetRegionSize(400, 50)
						alphawarning:SetPosition(0, -28, 0)
					end
				end
				if alphawarning then
					alphawarning:SetString("Up and Away is a work in progress!")
					alphawarning:Show()
				end
			end)
		end
	end)
end
