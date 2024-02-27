local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SystemFolder = ReplicatedStorage:WaitForChild("%53%79%73%74%65%6D%73")
local ShopModule = SystemFolder:WaitForChild("%53%68%6F%70%73")
local BuyRemote = ShopModule:WaitForChild("%42%75%79")
local ItemModule = require(game.ReplicatedStorage.Systems.Items)
local ItemList = ItemModule.GetItemList()

local CheckLevel = function(ItemName)
   local ValidCats = {"%4D%61%74%65%72%69%61%6C", "%4D%6F%75%6E%74"}
   if ItemList[tostring(ItemName)] ~= nil then
      local Category = tostring(ItemList[tostring(ItemName)].Category)
      if table.find(ValidCats, Category) then
         return 40
      end
      return ItemList[tostring(ItemName)].Level
   end
   return 0
end

local ReturnItemData = function(Item)
   Speed = 0
   if Item:FindFirstChild("%53%70%65%65%64") then
      Speed = (30 + Item:FindFirstChild("%53%70%65%65%64").Value)
   end
   return {
    Name = Item.Name, 
    Price = Item:GetAttribute("%50%72%69%63%65"), 
    Owner = Item:GetAttribute("%4F%77%6E%65%72"),
    MountSpeed = Speed,
    Level = CheckLevel(Item)
   }
end

local GetRandomUser = function()
   local Selectable = {}
   local Client = Players.LocalPlayer
   for i, v in pairs(game.Players:GetPlayers()) do
      if v ~= Client then
         table.insert(Selectable, v)
      end
   end
   if #Selectable ~= 0 then
      return Selectable[math.random(1, #Selectable)]
   else
      return false
   end
end

local ServerHop = function()
   local RandomUser = GetRandomUser()
   if RandomUser ~= false then
      local URI = ("https://accountsettings.roblox.com/v1/users/"  .. tostring(RandomUser.UserId) .. "/block")
      local Req = syn.request({
        Url = URI,
        Method = "POST"
      })
   end
   game:GetService("TeleportService"):Teleport(game.PlaceId)
end

return ReturnItemData, CheckLevel, ServerHop
