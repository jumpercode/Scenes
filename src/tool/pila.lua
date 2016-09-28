local builder = {}

function builder:createPila (texto)

    local stack =
    {
        last = "jump",
        pila = {{"jump", 0}},
        debug = texto
    }

    function stack:pop()
        return table.remove(self.pila, 1)
    end

    function stack:tamPila()
        return table.getn(self.pila)
    end

    function stack:getPilaCmd()
        return self.pila[1][1]
    end

    function stack:setPilaCmd(cmd)
        self.pila[1][1] = cmd
    end

    function stack:getPilaTime()
        return self.pila[1][2]
    end

    function stack:apilar(cmd)

        if(self:tamPila() == 0) then
            table.insert( self.pila, 1, cmd )
        else
            if(cmd[1] == "clear" and self:getPilaCmd() ~= "clear") then
                table.insert( self.pila, 1, cmd )
            else
                if(self:getPilaCmd() == "jump") then
                    if(cmd[1] ~= "D_a") then
                        if(self:tamPila() == 1) then
                            table.insert( self.pila, 2, cmd )
                        else
                            if(self.pila[2][1] ~= cmd[1]) then
                                table.insert( self.pila, 2, cmd )
                            end
                        end
                    end
                else
                    if(cmd[1] ~= self:getPilaCmd()) then
                        table.insert( self.pila, 1, cmd )
                    end
                end
            end
        end

    end

    function stack:desapilar(ops)
        idx = 0
        for i,v in ipairs(self.pila) do
            local stop = false
            for j,o in ipairs(ops) do
                if(v[1] == o) then
                    stop = true
                    break
                end
            end

            if(stop) then
                idx = i
                break
            end
        end

        if(idx > 0) then
            table.remove( self.pila, idx )
        end
    end

    function stack:verPila()
        dbg = ""
        for i,v in ipairs(self.pila) do
            dbg = dbg .. v[1].." "..v[2].."\n"
        end
        dbg = dbg .. "===> " .. self.last .. " <===\n"
        self.debug.text = dbg
    end

    return stack

end

return builder
