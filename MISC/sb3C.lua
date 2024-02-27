local MainModule = { }

local ValidPrice = function(Price, MaxPrice)
   return (MaxPrice >= Price)
end

local ValidSpeed = function(Speed, MinSpeed)
   return (Speed >= MinSpeed)
end

local ValidLevel = function(Level, MinLevel)
   return (Level >= MinLevel)
end
  
MainModule.ScanItems = function(Settings, BuyList, PurchaseFunction, LogFunction, HopFunction)
   for index, item in pairs(DropFolder:GetChildren()) do
      local item_data = GetItemData(item)
      local item_valid = true    
      if not CheckTag(item, "DLogged") then
         TagItem(item, "DLogged")
         LogDroppedItem(item_data)
      end
      if not ValidLevel(item_data.Level, Settings.MininumItemLevel) then
         item_valid = false
      end
      if item_valid then
         if item_data.Price == 0 then
            item_valid = false
         end
         if item_data.Price == 1 then
            PurchaseFunction(item)
            LogFunction(item, item_data.Name, tostring(item_data.Price))
            item_valid = false
         end
         if item_valid then
            for i, data in pairs(BuyList) do
               if i:lower() == item_data.Name:lower() then
                  if data.IsMount then
                     if not ValidSpeed(item_data.MountSpeed, data.MininumMountSpeed) then
                        item_valid = false
                     end
                     if item_valid then
                        PurchaseFunction(item)
                        LogFunction(item, tostring(item), tostring(item_data.Price))
                     end
                  end
               end
            end
         end
      end
   end
   if (Settings.MininumPlayerCount > #game.Players:GetPlayers()) then
      HopFunction()
   end
end

return MainModule
