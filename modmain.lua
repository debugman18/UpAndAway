local _G = GLOBAL
local assert, error = _G.assert, _G.error

---

modimport 'lib/use.lua'
use 'lib.timing'

---

local ElapsedTime = GetSingletonTimeMeasurer()

---

TheMod = use 'start_wicker'

---

modimport "assets.lua"
modimport "prefabfiles.lua"

--RemapSoundEvent("dontstarve/music/music_FE", "upandaway/music/music_FE")

---

TheMod:Say("Running main...")
TheMod:Run("main")

---

--------------

TheMod:Say( ("Finished loading in %.3f seconds."):format(ElapsedTime()) )

AddPrefabPostInit("world_network", function(inst)
	inst:AddComponent("climbingmanager")
end)
