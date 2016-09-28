--------------------------------------------------------------------------------
--	INICIO
--------------------------------------------------------------------------------

local composer = require( "composer" )
composer.removeScene( "src.scene." .. LASTSCENE )

LASTSCENE = "s3"
local scene = composer.newScene()

--------------------------------------------------------------------------------
--	ESPACIO LIBRE
--------------------------------------------------------------------------------

local debug

--------------------------------------------------------------------------------
--	EVENTOS DE ESCENA
--------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view

	local options =
	{
		parent = sceneGroup,
		text = event.params.mensaje,
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = display.contentWidth,
		font = native.systemFontBold,
		fontSize = 80,
		align = "center"
	}

	debug = display.newText( options )
	debug:setFillColor( 1, 0, 0 )

end


function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		--

	elseif ( phase == "did" ) then
        --

	end
end


function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        --

	elseif ( phase == "did" ) then
        --

	end
end


function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


--------------------------------------------------------------------------------
--	CONECTAR EVENTOS DE ESCENA
--------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

--------------------------------------------------------------------------------
--	RETORNAR ESCENA
--------------------------------------------------------------------------------

return scene
