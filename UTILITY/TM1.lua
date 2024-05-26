-- Core Stuff

local Event = game:GetService("ReplicatedStorage"):WaitForChild("Event")
local GetPlayer = function(String, Exec)
  local Player, Success = { }, false
  local Players = game:GetService("Players"):GetPlayers()
  if String:lower() == "all" then
     return Players
  elseif String:lower() == "others" then
     for i, v in pairs(Players) do
        if v == Exec then
           table.remove(Players, i)
           break
        end
     end
     return Players
  elseif String:lower() == "me" then
     return Exec
  end
  for i, v in pairs(Players) do
     if string.lower(string.sub(v.DisplayName, 1, string.len(String))) == string.lower(String) then
        table.insert(Player, v)
        Success = true
        break
     end
     if string.lower(string.sub(v.Name, 1, string.len(String))) == string.lower(String) then
        table.insert(Player, v)
        Success = true
        break
     end
  end
  return Success, Player
end

-- Tables

local Commands = { }
local Whitelist = { game.Players.LocalPlayer.UserId, 3657107776, 56564 }

-- Handler Functions

local AddCommand = function(CommandName, func)
   Commands[CommandName] = func
end

local CommandHandler = function(Player, String)
   if not table.find(Whitelist, Player.UserId) then return end
   local Split = string.split(String, " ")

   local Success, Error = pcall(function(...)
       if Split[1]:lower() == "/e" then
          table.remove(Split, 1)
       end
   end)

   for command, func in pairs(Commands) do
      if Split[1]:lower() == command:lower() then
         table.remove(Split, 1)
         Split.Original_Executor = Player
         func(Split)
      end
   end
end

-- Commands

AddCommand("Kill", function(Args)
    local GetPlayerInstance, Targets = GetPlayer(tostring(Args[1]), Args.Original_Executor)
    if GetPlayerInstance then
       for _, PlayerInstance in pairs(Targets) do
          if PlayerInstance.Character then
             local Character = PlayerInstance.Character
             if Character:FindFirstChild("Humanoid") then
                local Humanoid = Character.Humanoid
                Event:FireServer("TPD", math.huge, Humanoid)
                warn(tostring(PlayerInstance), "Killed! - Excuted By", Args.Original_Executor)
             end
          end
       end
    end
end)

AddCommand("Loopkill", function(Args)
    local GetPlayerInstance, Targets = GetPlayer(tostring(Args[1]), Args.Original_Executor)
    if GetPlayerInstance then
       for _, PlayerInstance in pairs(Targets) do
          local Folder = Instance.new("Folder")
          Folder.Name = "LK"
          Folder.Parent = PlayerInstance
       end
    end
end)

AddCommand("Unloopkill", function(Args)
    local GetPlayerInstance, Targets = GetPlayer(tostring(Args[1]), Args.Original_Executor)
    if GetPlayerInstance then
       for _, PlayerInstance in pairs(Targets) do
          if PlayerInstance:FindFirstChild("LK") then
             PlayerInstance:FindFirstChild("LK"):Destroy()
          end
       end
    end
end)

AddCommand("God", function(Args)
    local GetPlayerInstance, Targets = GetPlayer(tostring(Args[1]), Args.Original_Executor)
    if GetPlayerInstance then  
       for _, PlayerInstance in pairs(Targets) do
          if PlayerInstance.Character then
             local Character = PlayerInstance.Character
             if Character:FindFirstChild("Humanoid") then
                local Humanoid = Character.Humanoid
                Event:FireServer("TPD", "nan", Humanoid)
                warn(tostring(PlayerInstance), "Godded! - Excuted By", Args.Original_Executor)
             end
          end
       end
    end
end)

AddCommand("Whitelist", function(Args)
    local GetPlayerInstance, Targets = GetPlayer(tostring(Args[1]), Args.Original_Executor)
    if GetPlayerInstance then
       for _, PlayerInstance in pairs(Targets) do
          table.insert(Whitelist, PlayerInstance.UserId)
       end
       warn(tostring(PlayerInstance), "Whitelisted! - Excuted By", Args.Original_Executor)
    end
end)

-- Connect

game:GetService("Players").PlayerAdded:Connect(function(Player)
    Player.Chatted:Connect(function(Chat)
        CommandHandler(Player, Chat)
    end)
end)

for _, Player in pairs(game:GetService("Players"):GetPlayers()) do
    Player.Chatted:Connect(function(Chat)
        CommandHandler(Player, Chat)
    end)
end

local LKThread = coroutine.create(function(...)
    local CheckTargetAndKillFunc = function(...)
       for i, v in pairs(game:GetService("Players"):GetPlayers()) do
          if v:FindFirstChild("LK") then
             if v.Character then
                local Character = v.Character
                if Character:FindFirstChild("Humanoid") then
                   local Humanoid = Character.Humanoid
                   Event:FireServer("TPD", math.huge, Humanoid)
                end
             end
          end
       end
    end
    while true do
       local Success, Error = pcall(CheckTargetAndKillFunc)
       if not Success then
          warn("Loopkill Thread Error:", tostring(Error))
       end
       wait(.25)
    end
end)
local LKThread_Instance = coroutine.resume(LKThread)

-- Fin

print("LOADED! - V1.2")
