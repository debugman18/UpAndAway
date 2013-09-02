TheMod = GLOBAL.require("upandaway" .. '.wicker.init')(env)

-- This enables us to access configurations through TUNING.UPANDAWAY (for backwards compatibility)
TheMod:AddMasterKeyAlias("UPANDAWAY")
GLOBAL.assert( TUNING.UPANDAWAY )

TheMod:Run("worldgen_main")
