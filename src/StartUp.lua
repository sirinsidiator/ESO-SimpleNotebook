SimpleNotebook = {}

local function GetRandomElement(array)
    local random = math.random() * #array
    local index = 1 + math.floor(random)
    return array[index]
end

local function GetKeys(array)
    local keys = {}
    for key in pairs(array) do
        keys[#keys + 1] = key
    end
    table.sort(keys)
    return keys
end

SimpleNotebook.GetRandomElement = GetRandomElement

EVENT_MANAGER:RegisterForEvent("SimpleNotebook", EVENT_ADD_ON_LOADED, function(eventType, addonName)
    if addonName ~= "SimpleNotebook" then return end
    EVENT_MANAGER:UnregisterForEvent("SimpleNotebook", EVENT_ADD_ON_LOADED)

    local GetJoke = SimpleNotebook.GetJoke

    SLASH_COMMANDS["/joke"] = function()
        StartChatInput(GetJoke(), CHAT_CHANNEL_SAY)
    end

    EVENT_MANAGER:RegisterForEvent("SimpleNotebook", EVENT_PLAYER_ACTIVATED, function()
        d(GetJoke())
    end)

    local saveData = ZO_SavedVars:NewAccountWide("SimpleNotebook_Data", 1)
    local notes = saveData.notes or {}
    saveData.notes = notes

    SLASH_COMMANDS["/remember"] = function(input)
        local keyword, message = input:match("(.-) (.-)$")
        notes[keyword] = message
    end

    SLASH_COMMANDS["/remind"] = function(keyword)
        if(keyword == "") then
            local keys = GetKeys(notes)
            df("Existing keywords: %s", table.concat(keys, ", "))
        else
            d(notes[keyword])
        end
    end

    SLASH_COMMANDS["/forget"] = function(keyword)
        if(keyword == "") then
            d("Deleted all notes.")
            notes = {}
            saveData.notes = notes
        else
            df("Deleted %s", keyword)
            notes[keyword] = nil
        end
    end
end)
