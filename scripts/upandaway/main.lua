--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

-- This just enables syntax conveniences.
BindTheMod()



GetPlayer = GLOBAL.GetPlayer
SaveIndex = GLOBAL.SaveIndex

local CFG = TUNING.UPANDAWAY

modrequire 'strings'


local function evergreens_ret(inst)
	inst:AddTag"evergreen_ret"
	
	if GetPlayer().goneUp == true then
		print "Testing goneUp."
	end	
	
end

local function onUp(inst)

		SetHUDPause(true)
		--Define the new world objects we are placing.
		local beanstalk = SpawnPrefab("beanstalk")

		--Define the old world objects we are replacing.
		local evergreens_ret = TheSim:FindFirstEntityWithTag("evergreen_ret")
		
		--Make sure that the player climbed the beanstalk.
		if GetPlayer().goneUp == true and GetPlayer().goneUpRemember == false then
			
			--Place the new world objects.			
			beanstalk.Transform:SetPosition(evergreens_ret.Transform:GetWorldPosition())
			
			--Remove the old world objects.
			evergreens_ret:Remove()
		end	
		
		SetHUDPause(false)
		GetPlayer().goneUpRemember = true
end

AddPrefabPostInit('evergreen', evergreens_ret)	 

--Changes the title displayed on the main menu.
local function UpdateMainScreen(self)
	self.updatename:SetString("Up and Away")
end
AddGlobalClassPostConstruct("screens/mainscreen", "MainScreen", UpdateMainScreen)

--Changes "activate" to "talk to" for "shopkeeper".
AddSimPostInit(function(inst)
	local oldactionstringoverride = inst.ActionStringOverride
	function inst:ActionStringOverride(bufaction)
		if bufaction.action == GLOBAL.ACTIONS.ACTIVATE and bufaction.target and bufaction.target.prefab == "shopkeeper" then
			return "Talk to"
		end
		if oldactionstringoverride then
			return oldactionstringoverride(inst, bufaction)
		end
	end
end)



--Changes "activate" to "climb down" for "beanstalk_exit".
AddSimPostInit(function(inst)
	local oldactionstringoverride = inst.ActionStringOverride
	function inst:ActionStringOverride(bufaction)
		if bufaction.action == GLOBAL.ACTIONS.ACTIVATE and bufaction.target and bufaction.target.prefab == "beanstalk_exit" then
			return "Climb Down"
		end
		if oldactionstringoverride then
			return oldactionstringoverride(inst, bufaction)
		end
	end
end)
