local jokes = {
    "What's the best way to convince even the most pompous Altmer that you have a good point? Stab them in the chest with it.",
    "What do you get when you cross a Nord, a Dunmer, and an Argonian? Violently Murdered! Blood for the Pact!",
    "What is the thinnest book in the world? Redguard Heroes of the War of Betony.",
}

local function GetRandomElement(array)
    local random = math.random() * #array
    local index = 1 + math.floor(random)
    return array[index]
end

SLASH_COMMANDS["/joke"] = function()
    StartChatInput(GetRandomElement(jokes), CHAT_CHANNEL_SAY)
end
