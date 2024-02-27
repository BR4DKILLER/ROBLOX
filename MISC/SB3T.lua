local TagItem = function(Item, Name)
   local Tag = Instance.new("BoolValue")
   Tag.Name = Name
   Tag.Parent = Item
   return true
end

local CheckTag = function(Item, Name)
   if Item:FindFirstChild(Name) then
      return true
   end
   return false
end

local LogDroppedItem = function(Data, Valid)
   if Valid then
      Valid = "Valid"
   else
      Valid = "Invalid"
   end
   warn(Data.Name, "- Price", tostring(Data.Price), "- Level", tostring(Data.Level), "-", Valid)
   return true
end

return TagItem, CheckTag, LogDroppedItem
