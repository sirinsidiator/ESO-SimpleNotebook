local Storage = ZO_Object:Subclass()
SimpleNotebook.Storage = Storage

function Storage:New(saveData)
    local storage = ZO_Object.New(self)
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
    self.notes[key] = note
end

function Storage:DeleteNote(key)
    self.notes[key] = nil
end

function Storage:DeleteAllNotes()
    ZO_ClearTable(self.notes)
end
