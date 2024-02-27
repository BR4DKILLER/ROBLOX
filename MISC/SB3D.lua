local Items = {}

Items.AddItem = function(ItemName, MaxPrice, IsMount, MininumMountSpeed)
   if IsMount == nil then
      IsMount = false
   end
   if MininumMountSpeed == nil then
      MininumMountSpeed = 39
   end
   Items[ItemName] = {
    ["MaxPrice"] = MaxPrice,
    ["IsMount"] = IsMount,
    ["MininumMountSpeed"] = MininumMountSpeed
   }
   return Items[ItemName]
end

return Items
