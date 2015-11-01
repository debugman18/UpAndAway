local _G = GLOBAL
local assert, error = _G.assert, _G.error

---

modimport 'lib/use.lua'
use 'lib.timing'

---

local ElapsedTime = GetSingletonTimeMeasurer()

-- Hacky stuff to bomb-proof the worldgen. Do this before Wicker is initialized.
if postinitfns.PrefabPostInit == nil then
    postinitfns.PrefabPostInit = {}
end
 
HackPrefabPostInit = function(prefab, fn)
    if postinitfns.PrefabPostInit[prefab] == nil then
        postinitfns.PrefabPostInit[prefab] = {}
    end
    table.insert(postinitfns.PrefabPostInit[prefab], fn)
end

local AddPrefabPostInit = AddPrefabPostInit or HackPrefabPostInit

-- Being redundant here.
GLOBAL.getfenv(1).AddPrefabPostInit = AddPrefabPostInit

GLOBAL._UNA = {}
GLOBAL._UNA.AddPrefabPostInit = AddPrefabPostInit

---

TheMod = use 'start_wicker'
TheMod:Say( ("wicker finished loading in %.3f seconds."):format(ElapsedTime()) )

---

-- This enables us to access configurations through TUNING.UPANDAWAY (for backwards compatibility)
TheMod:AddMasterConfigurationKey("UPANDAWAY")
assert( TUNING.UPANDAWAY )

---

TheMod:Say("Running worldgen_main...")
TheMod:Run("worldgen_main")

------------------------------------------

------------------------------------------

local dt = ElapsedTime()
if TheMod:GetEnvironment().IsWorldgen() then
	TheMod:Say( ("Finished loading in %.3f seconds."):format(dt) )
end