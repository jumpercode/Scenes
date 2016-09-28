--------------------------------------------------------------------------------
--	INICIO
--------------------------------------------------------------------------------

local composer = require( "composer" )
composer.removeScene( "src.scene." .. LASTSCENE )

LASTSCENE = "s1"
local scene = composer.newScene()

--------------------------------------------------------------------------------
--	ESPACIO LIBRE
--------------------------------------------------------------------------------

local ip = "res/img/"
local akeys = {a=true, right=true, left=true}
local keys = {a=false, right=false, left=false}
local pila

local fondo
local p1
local p2
local debug
local sonic
local gameTimer

local physics = require( "physics" )
physics.start()

--- SENSORS OF EVENTS

local function onKeyEvent( event )
    if(akeys[event.keyName]) then
        if(keys[event.keyName]) then
            pila:apilar({"U_" .. event.keyName, system.getTimer()})
        else
            pila:apilar({"D_" .. event.keyName, system.getTimer()})
        end

        keys[event.keyName] = not(keys[event.keyName])

    end
end

local function onLocalCollision( self, event )
    if(pila:tamPila() > 0) then
        if(pila:getPilaCmd() == "jump" and (system.getTimer()-pila:getPilaTime()) > 300) then
            pila:apilar({"clear", system.getTimer()})
        end
    end
end

--- MIAN GAME LOOP (CONTROLLER & ACTUATORS)
local function gameLoop()

    local time = system.getTimer()

    pila:verPila()

    if(sonic.y > 600) then
        composer.gotoScene( "src.scene.s2", { time=800, effect="crossFade" } )
    end

    if(pila:tamPila() > 0) then

        if(pila:getPilaCmd() == "clear") then
            sonic:parar()
            pila:pop()
            pila:pop()
            pila.last = "clear"

        elseif(pila:getPilaCmd() == "D_left" and pila.last ~= "D_left") then
            pila:setPilaCmd("esperarIzquierda")
            sonic:esperar("L")
            pila.last = "D_left"

        elseif(pila:getPilaCmd() == "esperarIzquierda" and (time - pila:getPilaTime()) > 100 and pila.last ~= "esperarIzquierda") then
            pila:setPilaCmd("correrIzquierda")
            pila.last = "esperarIzquierda"

        elseif(pila:getPilaCmd() == "correrIzquierda" and pila.last ~= "correrIzquierda") then
            sonic:correr("L")
            pila.last = "correrIzquierda"

        elseif(pila:getPilaCmd() == "U_left" and pila.last ~= "U_left") then
            sonic:liberar("L")
            pila:desapilar({"D_left", "esperarIzquierda", "correrIzquierda"})
            pila:pop()

        elseif(pila:getPilaCmd() == "D_right" and pila.last ~= "D_right") then
            pila:setPilaCmd("esperarDerecha")
            sonic:esperar("R")
            pila.last = "D_right"

        elseif(pila:getPilaCmd() == "esperarDerecha" and (time - pila:getPilaTime()) > 100 and pila.last ~= "esperarDerecha") then
            pila:setPilaCmd("correrDerecha")
            pila.last = "esperarDerecha"

        elseif(pila:getPilaCmd() == "correrDerecha" and pila.last ~= "correrDerecha") then
            sonic:correr("R")
            pila.last = "correrDerecha"

        elseif(pila:getPilaCmd() == "U_right" and pila.last ~= "U_right") then
            sonic:liberar("R")
            pila:desapilar({"D_right", "esperarDerecha", "correrDerecha"})
            pila:pop()

        elseif(pila:getPilaCmd() == "D_a" and pila.last ~= "D_a") then
            pila:setPilaCmd("jump")
            pila.last = "D_a"

        elseif(pila:getPilaCmd() == "jump" and pila.last ~= "jump") then
            sonic:saltar()
            pila.last = "jump"

        elseif(pila:getPilaCmd() == "U_a" and pila.last ~= "U_a") then
            pila:pop()
        end

    end

end

--------------------------------------------------------------------------------
--	EVENTOS DE ESCENA
--------------------------------------------------------------------------------

function scene:create( event )

	local sceneGroup = self.view
    physics.pause()

    fondo = display.newImageRect(sceneGroup, ip.."fondo.png", 800, 600)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY

    p1 = display.newImageRect(sceneGroup, ip.."plataforma.png", 300, 50)
    p1.x = 170
    p1.y = display.contentCenterY

    p2 = display.newImageRect(sceneGroup, ip.."plataforma.png", 300, 50)
    p2.x = display.contentWidth-180
    p2.y = display.contentHeight-50

    debug = display.newText( sceneGroup, "", 100, 100, 200, 200, native.systemFont, 8 )
    debug:setFillColor( 1, 0, 0 )

    sonicBuilder = require("src.character.sonic")
    sonic = sonicBuilder:createSonic(sceneGroup)
    sonic.x = 170
    sonic.y = 0

    pilaBuilder = require("src.tool.pila")
    pila = pilaBuilder:createPila(debug)

    physics.addBody( p1, "static", { bounce=0.0 } )
    physics.addBody( p2, "static", { bounce=0.0 } )
    sonic:addBody(physics)

end


function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		--

	elseif ( phase == "did" ) then

        physics.start()

        p1.collision = onLocalCollision
        p1:addEventListener( "collision" )

        p2.collision = onLocalCollision
        p2:addEventListener( "collision" )

        Runtime:addEventListener( "key", onKeyEvent )

        gameTimer = timer.performWithDelay(16, gameLoop, 0)

        sonic:setSequence("saltarDerecha")
        sonic:play()

	end
end


function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		timer.cancel( gameTimer )

	elseif ( phase == "did" ) then

        Runtime:removeEventListener( "key", onKeyEvent )

        p1:removeEventListener( "collision" )
        p2:removeEventListener( "collision" )

        physics.pause()

	end
end


function scene:destroy( event )

	local sceneGroup = self.view

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
