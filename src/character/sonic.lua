local builder = {}

function builder:createSonic(parent)

    local ip = "res/img/"

    local hojaSonicConfig =
    {
        width = 40,
        height = 40,
        numFrames = 60
    }

    local sonicAnim =
    {
        {
            name = "esperarDerecha",
            start = 1,
            count = 1,
            time = 16,
            loopCount = 0
        },

        {
            name = "esperarIzquierda",
            start = 11,
            count = 1,
            time = 16,
            loopCount = 0
        },

        {
            name = "correrDerecha",
            start = 21,
            count = 8,
            time = 600,
            loopCount = 0
        },

        {
            name = "correrIzquierda",
            start = 31,
            count = 8,
            time = 600,
            loopCount = 0
        },

        {
            name = "saltarDerecha",
            start = 41,
            count = 10,
            time = 1200,
            loopCount = 1
        },

        {
            name = "saltarIzquierda",
            start = 51,
            count = 10,
            time = 1200,
            loopCount = 1
        },
    }

    local hojaSonic = graphics.newImageSheet( ip.."sonic.png", hojaSonicConfig )
    local sonic = display.newSprite(parent, hojaSonic, sonicAnim )

    function sonic:addBody(physics)
        physics.addBody( self, "dynamic", {bounce=0.0 } )
    end

    function sonic:saltar()
        if(self.sequence == "esperarIzquierda" or self.sequence == "correrIzquierda") then
            self:setSequence("saltarIzquierda")
        else
            self:setSequence("saltarDerecha")
        end
        sonic:play()

        sonic:applyLinearImpulse(0, -0.1, self.x, self.y)
    end

    function sonic:parar()
        self:setLinearVelocity(0, 0)

        if(self.sequence == "saltarIzquierda") then
            self:setSequence("esperarIzquierda")
        else
            self:setSequence("esperarDerecha")
        end

        self:play()
    end

    function sonic:correr(dir)
        self:setLinearVelocity(0,0)

        if(dir == "L") then
            self:applyLinearImpulse(-0.05, 0, self.x, self.y)
            self:setSequence("correrIzquierda")
        else
            self:applyLinearImpulse(0.05, 0, self.x, self.y)
            self:setSequence("correrDerecha")
        end

        self:play()
    end

    function sonic:esperar(dir)
        if(dir == "L") then
            self:setSequence("esperarIzquierda")
        else
            self:setSequence("esperarDerecha")
        end

        sonic:play()
    end

    function sonic:liberar(dir)
        if(self.sequence == "correrIzquierda" and dir == "L") then
            self:setLinearVelocity(0, 0)
            self:esperar(dir)
        elseif(self.sequence == "correrDerecha" and dir == "R") then
            self:setLinearVelocity(0, 0)
            self:esperar(dir)
        end
    end

    return sonic

end

return builder
