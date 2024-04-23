-- Q1
-- Pass the playerId in TFS 1.4 to recreate the player through addEvent, instead of the player directly
-- Added check in releaseStorage to make sure that the id received is for a player
-- Unsure if the storage key, value is relevant so didn't touch it
local function releaseStorage(player)
    local p = Player(player)
    if p and p:isPlayer() then
        p:setStorageValue(1000, -1)
    end
end
    
function onLogout(player)
    local pid = player:getId()
    if player:getStorageValue(1000) == 1 then
        addEvent(releaseStorage, 1000, pid)
    end
    return true
end

-- Q2
-- Added a check to make sure the result is valid
-- Added the loop to go the queried results
function printSmallGuildNames(memberCount)
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    if resultId ~= false then
        repeat
            local guildName = result.getString(resultId, "name")
            print(guildName)
        until not result.next(resultId)
        result.free(resultId)
    end
end

-- Q3
-- Removes a member by name from the same party as player with playerId
-- Recreating player from name is assumed to be possible in TFS 1.4
-- Also assumes player comparison is defined, rather than comparing by just name
-- Removes the only the first match, assumes there is only one match
-- Returns false if player is not valid, player is not in a party or no members of given name in party (possible for sanity check in calling code)
function removeMemberFromParty(playerId, membername)
    player = Player(playerId)
    if not player or not player:isPlayer() then
        return false
    end

    local party = player:getParty()
    if not party then
        return false
    end
    
    for _, member in ipairs(party:getMembers()) do
        if member == Player(membername) then
            party:removeMember(Player(membername))
            return true
        end
    end

    return false
end
