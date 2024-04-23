local distance, animationDelay = 5, 50
local invalidTilestates = { TILESTATE_PROTECTIONZONE, TILESTATE_HOUSE, TILESTATE_FLOORCHANGE, TILESTATE_TELEPORT, TILESTATE_BLOCKSOLID, TILESTATE_BLOCKPATH }
local effect = CONST_ME_DASH

function executeMove(p, pos)
    local player = Player(p)
    player:getPosition():sendMagicEffect(effect)
    player:teleportTo(pos)
end

function stopMove(p)
    local player = Player(p)
    player:getPosition():sendMagicEffect(CONST_ME_NODASH)
end

function onCastSpell(player, var)
    local stop, pos, dir = false, getThingPos(player), getPlayerLookDir(player)
    local moves = {}
    for i = 1, distance do
        local nextPos = { x = pos.x + (dir == 1 and i or dir == 3 and -i or 0), y = pos.y + (dir == 0 and -i or dir == 2 and i or 0), z = pos.z}

        local tile = nextPos and Tile(nextPos)
        if not tile then
            return false
        end

        for _, tilestate in pairs(invalidTilestates) do
            if tile:hasFlag(tilestate) then
                player:sendCancelMessage("Cannot dash here.")
                stop = true
                break
            end
        end

        if stop then
            break
        else
            table.insert(moves, nextPos)
        end
    end

    for i = 1, #moves do
        if i == 1 then
            player:getPosition():sendMagicEffect(effect)
            player:teleportTo(moves[i])
        else
            addEvent(executeMove, (animationDelay * i) - animationDelay, player:getId(), moves[i])
        end
    end

    addEvent(stopMove, (animationDelay * #moves) - animationDelay, player:getId())

    return true
end