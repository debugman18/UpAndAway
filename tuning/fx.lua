-- Delay until the start of state effects (such as lightning).
CLOUD_AMBIENT.FX_TRANSITION_DELAY = 1.5*CLOUD_AMBIENT.COLOUR_TRANSITION_TIME
-- Time between lightning strikes, as a range (min, max).
CLOUD_AMBIENT.LIGHTNING_DELAY = {2, 8}
-- Distance from the player for a lightning strike, as a range (min, max).
CLOUD_AMBIENT.LIGHTNING_DISTANCE = {2, 10}


CLOUD_LIGHTNING.COLOUR = Point(0.5, 0.7, 0.7)
CLOUD_LIGHTNING.LIFETIME = 0.6
CLOUD_LIGHTNING.RADIUS = 2
CLOUD_LIGHTNING.LIGHT_INTENSITY = 0.9
-- Period to update the light intensity (which decreases until 0).
CLOUD_LIGHTNING.UPDATE_PERIOD = 1/20


CLOUD_MIST.DENSITY = 1/30
CLOUD_MIST.GROUND_HEIGHT = 0.8
