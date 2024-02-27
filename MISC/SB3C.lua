local MainModule = {}

local ValidPrice = function(Price, MaxPrice)
    return (MaxPrice >= Price)
end

local ValidSpeed = function(Speed, MinSpeed)
    return (Speed >= MinSpeed)
end

local ValidLevel = function(Level, MinLevel)
    return (Level >= MinLevel)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DropFolder = ReplicatedStorage:WaitForChild("Drops")

MainModule.ScanItems = function(Settings,BuyList,PurchaseFunction,LogFunction,HopFunction,TagFunction,CheckTagFunction,LogDroppedFunction,GIDFunction,DisableHopping)
    if DisableHopping == nil then
        DisableHopping = false
    end
    for index, item in pairs(DropFolder:GetChildren()) do
        local item_data = GIDFunction(item)
        local item_found = false
        local item_valid = true
        local item_log = false

        if not CheckTagFunction(item, "DLogged") then
            TagFunction(item, "DLogged")
            item_log = true
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
                        item_found = true
                        if data.IsMount then
                            if not ValidSpeed(item_data.MountSpeed, data.MininumMountSpeed) then
                                item_valid = false
                            end
                        end
                        if not ValidPrice(item_data.Price, data.MaxPrice) then
                            item_valid = false
                        end
                        if item_valid then
                            PurchaseFunction(item)
                            LogFunction(item, tostring(item), tostring(item_data.Price))
                        end
                    end
                end

                if not item_found then
                    item_valid = false
                end
            end

            if item_log then
                warn(item_data, item_valid)
                LogDroppedFunction(item_data, item_valid)
            end
        end
    end
    if (Settings.MininumPlayerCount > #game.Players:GetPlayers()) and not DisableHopping then
        HopFunction()
    end
end

return MainModule
