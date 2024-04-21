-- Q1 - Fix or improve the implementation of the below methods

function onLogout(player)
    -- Juan Pablo: Null check for the player variable
    if not player then
        return true
    end
    
    -- Juan Pablo: I create a local variable for the player
    local p = player
    if p:getStorageValue(1000) == 1 then
        -- Juan Pablo: It's preferable to declare the function locally, if it's only going to be used here.
        local function releaseStorage()
            p:setStorageValue(1000, -1)
        end
        addEvent(releaseStorage, 1000)
    end
    return true
end

-- Q2 - Fix or improve the implementation of the below method

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    -- Juan Pablo: I renamed the variable for the results to better represent a set, instead of a single value.
    local resultIds = db.storeQuery(string.format(selectGuildQuery, memberCount))

    -- Juan Pablo: The result set must be iterated through.
    while(resultIds ~= false and resultIds:hasNext()) do
        local guildName = resultIds:getString("name")
        print(guildName)
    end
    -- Juan Pablo: a variable result was trying to be accessed whilst not being defined.
    -- I asume this was a mistake and was refering to resultIds

    -- Juan Pablo: I closed the result set after the loop.
    resultIds:close()
end



-- Q3 - Fix or improve the name and the implementation of the below method

-- Juan Pablo: It's not entirely clear if this method's purpose is to remove a player from it's party or to remove another member from a player's party.
    -- Juan Pablo: I will asume the second one. I'll provide a better solution for the first option below.
-- Juan Pablo: Another general comment about this method. The fact that we have a getParty function in player could mean either a search on a DB for the party that has the player Id or that the player has a reference to it's own party.
    -- Juan Pablo: If it's the second case (the player having a reference to the party), we would have a circular dependence between the two. This can lead to the code being less flexible to future changes.
function removeMemberFromPlayerParty(playerId, memberName)
    
    -- Juan Pablo: We could have a method that returns a party based on a playerId, probably getting it from a DB query.
    player = Player(playerId)
    local party = player:getParty()

    -- Juan Pablo: I added a null check for the player's party.
    if not party then
        return
    end
    
    -- Juan Pablo: I removed the unnecesary instanciation for a player in the name check and in the remove method on every iteration.
    -- Juan Pablo: Removing based on name can lead to problems in the future, we should probably use an id instead (See method below)
    for key,member in pairs(party:getMembers()) do
        if member:getName() == memberName then
            party:removeMember(member)
            print(member:getName() .. " was removed from the party")
            -- Juan Pablo: Breaking loop if the player is found.
            break
        end
    end
end

-- Juan Pablo: If what we want to do is remove the player from the party, we can do it this way.
function removeMemberFromParty(playerId)
    player = Player(playerId)
    local party = player:getParty()

    if not party then
        return
    end
    
    -- Juan Pablo: Since we have the player's id, we can use it to remove the player from the party
    party:removeMember(player)
    print(player:getName() .. " was removed from the party")
end

-- Juan Pablo: We can even add a method for removal where we receive the party directly
function removeMemberFromParty(playerId, party)

    if not party then
        return
    end
    
    -- Juan Pablo: Since we have the player's id, we can use it to remove the player from the party.
    -- Juan Pablo: This prevents an unnecesary player from being instantiated.
    if party:hasPlayer(playerId) then
        party:removeMemberById(playerId)
        print(player:getName() .. " was removed from the party")
        return
    end
    print(player:getName() .. " is not a member of the party")
end