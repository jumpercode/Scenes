-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

LASTSCENE = "MAIN"

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

composer.gotoScene( "src.scene.s1" )
