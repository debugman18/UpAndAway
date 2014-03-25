--[[
-- Throws an item from a container or inventory, as in loot dropping.
--
-- @param item The item to be thrown.
--]]
function ThrowItemFromContainer(item)
	local vertspeed = 10
	local horspeed = 3


	local containercmp = item:IsValid() and item.components.inventoryitem and item.components.inventoryitem:GetContainer()
	if not containercmp then return end

	containercmp:DropItem(item)

	local container = containercmp.inst


	local angle = 2*math.pi*math.random()
	local dx, dz = math.cos(angle), math.sin(angle)

	local pt = Point(container.Transform:GetWorldPosition())
	if container.Physics then
		pt = pt + Vector3(dx, 0, dz)*(container.Physics:GetRadius() or 1)
	end
	if item.Physics then
		pt = pt + Vector3(dx, 0, dz)*(item.Physics:GetRadius() or 1)
	end

	item.Transform:SetPosition(pt:Get())


	if item.Physics then
		item.Physics:SetVel(horspeed*dx, vertspeed, horspeed*dz)

		item:DoTaskInTime(1, function() 
			if not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) then
				if not item:IsOnValidGround() then
					local fx = SpawnPrefab("splash_ocean")
					local pos = item:GetPosition()
					fx.Transform:SetPosition(pos.x, pos.y, pos.z)
					if item:HasTag("irreplaceable") then
						item.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())
					else
						item:Remove()
					end
				end
			end
		end)
	end
end

return _M
