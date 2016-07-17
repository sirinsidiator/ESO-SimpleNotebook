SimpleNotebook = {}

local function GetRandomElement(array)
    local random = math.random() * #array
    local index = 1 + math.floor(random)
    return array[index]
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
end)
