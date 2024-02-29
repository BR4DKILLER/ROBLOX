local MainModule = {}
local Version = 1.2
local Time = 0

local ValidPrice = function(Price, MaxPrice)
    return (MaxPrice >= Price)
end

local ValidSpeed = function(Speed, MinSpeed)
    return (Speed >= MinSpeed)
end

local ValidLevel = function(Level, MinLevel)
    return (Level >= MinLevel)
end

local IsMinute = function()
   local Minutes = (Time / 60)
   if (Minutes % 1) == 0 then
      return true, Minutes
   end
   return false, Mintues
end

local GetClient_DeveloperConsole = function()
   local UI;
   if game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster") then
      UI = game:GetService("CoreGui"):WaitForChild("DevConsoleMaster"):WaitForChild("DevConsoleWindow"):WaitForChild("DevConsoleUI")
   else
      game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
      UI = game:GetService("CoreGui"):WaitForChild("DevConsoleMaster"):WaitForChild("DevConsoleWindow"):WaitForChild("DevConsoleUI")
   end
   if not UI:FindFirstChild("MainView") then
      game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
   end
   local MainView = UI:WaitForChild("MainView", 5)
   if MainView == nil then
      return false
   end
   return MainView
end

local OpenDevConsole = function()
   local MainView = GetClient_DeveloperConsole() 
   if MainView == false then
      MainView = GetClient_DeveloperConsole()
   end
   if MainView == false then
      return
   end
   local MainClient = MainView:WaitForChild("ClientLog")
   if MainClient ~= nil then
      wait()
      local MainClient = MainView.ClientLog
      local AutoScroll = coroutine.create(function(...)
          while true do 
             local YCoordinate = (MainClient.CanvasSize.Y.Offset - MainClient.AbsoluteSize.Y)
             local XCoordinate = 0
             local Vector = Vector2.new(XCoordinate, YCoordinate)
             MainClient.CanvasPosition = Vector 
             wait() 
          end
      end)
      coroutine.resume(AutoScroll)
   else
      return
   end
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
        local item_one = false

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
                item_one = true
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

            if item_log and not item_one then
                LogDroppedFunction(item_data, item_valid)
            elseif item_one then
                LogDroppedFunction(item_data, item_one)
            end
        end
    end
    if (Settings.MininumPlayerCount > #game.Players:GetPlayers()) and not DisableHopping then
        HopFunction()
    end
end

MainModule.HopTimer = function(Settings, HopFunction)
    if not Settings.HopSettings.HopTimer then return end
    local Minutes = (60 * Settings.HopSettings.HopAfter)
    warn("Hop-Timer started! -", tostring(Minutes / 60), "Minute(s) Remain.")
    local Timer_Thread = coroutine.create(function(...)
        if Settings.HopSettings.HopTimer then
            while true do
                wait(1)
                Time = Time + 1
                local IsMin, Min = IsMinute()
                if IsMin then warn("Hop-Timer:", tostring(Min), "Minute(s) Passed.") end
                if Time >= (60 * Settings.HopSettings.HopAfter) then
                   break
                end
            end
            HopFunction()
        end
    end)
    coroutine.resume(Timer_Thread)
end

MainModule.ResetTimer = function()
    Time = 0
    warn("Reset Hop Timer! - ITEM FOUND")
end

MainModule.OpenDeveloperConsole = OpenDevConsole

return MainModule, Version
