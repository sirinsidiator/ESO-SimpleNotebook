local Storage = ZO_CallbackObject:Subclass()
SimpleNotebook.Storage = Storage

function Storage:New(saveData)
    local storage = ZO_CallbackObject.New(self)
    storage.notes = saveData.notes or {}
    saveData.notes = storage.notes
    return storage
end

function Storage:GetKeys()
    local keys = {}
    for key in pairs(self.notes) do
        keys[#keys + 1] = key
    end
    table.sort(keys)
    return keys
end

function Storage:HasNotes()
    return next(self.notes) ~= nil
end

function Storage:GetNote(key)
    return self.notes[key]
end

function Storage:HasNote(key)
    return self.notes[key] ~= nil
end

function Storage:SetNote(key, note)
    local keyExists = self:HasNote(key)
    self.notes[key] = note
    if(not keyExists) then
        self:FireCallbacks("OnKeysUpdated")
    end
end

function Storage:DeleteNote(key)
    local keyExists = self:HasNote(key)
    self.notes[key] = nil
    if(keyExists) then
        self:FireCallbacks("OnKeysUpdated")
    end
end

function Storage:DeleteAllNotes()
    local hadNotes = self:HasNotes()
    ZO_ClearTable(self.notes)
    if(hadNotes) then
        self:FireCallbacks("OnKeysUpdated")
    end
end
