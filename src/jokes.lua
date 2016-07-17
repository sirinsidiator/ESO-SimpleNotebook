local GetRandomElement = SimpleNotebook.GetRandomElement

local jokes = {
    "What's the best way to convince even the most pompous Altmer that you have a good point? Stab them in the chest with it.",
    "What do you get when you cross a Nord, a Dunmer, and an Argonian? Violently Murdered! Blood for the Pact!",
    "What is the thinnest book in the world? Redguard Heroes of the War of Betony.",
}

local function GetJoke()
    return GetRandomElement(jokes)
end

SimpleNotebook.GetJoke = GetJoke