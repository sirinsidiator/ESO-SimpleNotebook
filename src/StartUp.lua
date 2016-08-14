SimpleNotebook = {}

local ADDON_NAME = "SimpleNotebook"

local function Print(message, ...)
    df("[%s] %s", ADDON_NAME, message:format(...))
end

local function GetRandomElement(array)
    local random = math.random() * #array
    local index = 1 + math.floor(random)
    return array[index]
end

local keywordColor = ZO_ColorDef:New("0094FF")
local function AugmentKeyword(keyword)
    keyword = string.format("|H%d:%s|h%s|h", LINK_STYLE_DEFAULT, ADDON_NAME, keyword)
    return keywordColor:Colorize(keyword)
end

local function ForEach(table, func)
    for i, key in ipairs(table) do
        table[i] = func(key)
    end
end

SimpleNotebook.GetRandomElement = GetRandomElement

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, function(eventType, addonName)
    if addonName ~= ADDON_NAME then return end
    EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)

    local GetJoke = SimpleNotebook.GetJoke
    local Storage = SimpleNotebook.Storage

    SLASH_COMMANDS["/joke"] = function()
        StartChatInput(GetJoke(), CHAT_CHANNEL_SAY)
    end

    EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED, function()
        Print(GetJoke())
    end)

    local saveData = ZO_SavedVars:NewAccountWide("SimpleNotebook_Data", 1)
    local storage = Storage:New(saveData)

    SLASH_COMMANDS["/remember"] = function(input)
        local keyword, message = input:match("(.-) (.-)$")
        if(keyword and message and keyword ~= "" and message ~= "") then
            storage:SetNote(keyword, message)
            Print("Storing note for keyword %s", AugmentKeyword(keyword))
        else
            Print("Could not store note. Invalid input")
        end
    end

    SLASH_COMMANDS["/remind"] = function(keyword)
        if(keyword == "") then
            if(storage:HasNotes()) then
                local keys = storage:GetKeys()
                ForEach(keys, AugmentKeyword)
                Print("Existing keywords: %s", table.concat(keys, ", "))
            else
                Print("Nothing stored yet")
            end
        elseif(not storage:HasNote(keyword)) then
            Print("No note stored for keyword %s", AugmentKeyword(keyword))
        else
            Print(storage:GetNote(keyword))
        end
    end

    SLASH_COMMANDS["/forget"] = function(keyword)
        if(keyword == "") then
            Print("Deleted all notes")
            storage:DeleteAllNotes()
        else
            Print("Deleted %s", AugmentKeyword(keyword))
            storage:DeleteNote(keyword)
        end
    end

    LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, function(link, button, keyword, linkStyle, linkType)
        if(linkType == ADDON_NAME) then
            StartChatInput(string.format("/remind %s", keyword))
            return true
        end
    end)

    local window = SimpleNotebookWindow
    local properties = saveData.window
    if(properties) then
        window:ClearAnchors()
        window:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, properties.x, properties.y)
        window:SetDimensions(properties.width, properties.height)
    else
        local x, y = window:GetScreenRect()
        local width, height = window:GetDimensions()
        properties = {
            x = x,
            y = y,
            width = width,
            height = height
        }
        saveData.window = properties
    end

    window:SetHandler("OnMoveStop", function(control)
        local x, y = control:GetScreenRect()
        properties.x = x
        properties.y = y
    end)
    window:SetHandler("OnResizeStop", function(control)
        local width, height = control:GetDimensions()
        properties.width = width
        properties.height = height
    end)

    SLASH_COMMANDS["/simplenotebook"] = function()
        window:SetHidden(not window:IsHidden())
    end
end)
