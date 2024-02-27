local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Version = 1

function decodeChar(hex)
	return string.char(tonumber(hex,16))
end
 
function decodeString(str)
	local output, t = string.gsub(str,"%%(%x%x)",decodeChar)
	return output
end

local SystemFolder = ReplicatedStorage:WaitForChild(decodeString("%53%79%73%74%65%6D%73"))
local ShopModule = SystemFolder:WaitForChild(decodeString("%53%68%6F%70%73"))
local BuyRemote = ShopModule:WaitForChild(decodeString("%42%75%79"))
local ItemModule = require(game.ReplicatedStorage.Systems.Items)
local ItemList = ItemModule.GetItemList()

local CheckLevel = function(ItemName)
   local ValidCats = {decodeString("%4D%61%74%65%72%69%61%6C"), decodeString("%4D%6F%75%6E%74")}
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
   if Item:FindFirstChild(decodeString("%53%70%65%65%64")) then
      Speed = (30 + Item:FindFirstChild(decodeString("%53%70%65%65%64")).Value)
   end
   return {
    Name = Item.Name, 
    Price = Item:GetAttribute(decodeString("%50%72%69%63%65")), 
    Owner = Item:GetAttribute(decodeString("%4F%77%6E%65%72")),
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

local ServerHop = function(BlockLimit)
   local RandomUser = GetRandomUser()
   local URI_Blocked = ("https://accountsettings.roblox.com/v1/users/get-detailed-blocked-users")
   local Req_Blocked = syn.request({
        Url = URI_Blocked,
        Method = "GET"
   })
   local BlockedData;
   local Success, Error = pcall(function(...)
        BlockedData = game:GetService("HttpService"):JSONDecode(Req_Blocked.Body)
   end)
   if Success then
      local UBSuccess, UBError = pcall(function(...)
         if BlockedData.total >= BlockLimit then
            for i, v in pairs(BlockedData.blockedUsers) do
               syn.request({
	         Url = "https://accountsettings.roblox.com/v1/users/" .. tostring(v.userId) .. "/unblock",
	         Method = "POST"
	       })
	    end
         end
      end)
      if UBSuccess then
         warn("Unblocked all Users!")
      end
   elseif not Success then
      warn("Error Unblocking all Users:", Error)
   end
   if RandomUser ~= false then
      local URI = ("https://accountsettings.roblox.com/v1/users/"  .. tostring(RandomUser.UserId) .. "/block")
      local Req = syn.request({
        Url = URI,
        Method = "POST"
      })
   end
   game:GetService("TeleportService"):Teleport(game.PlaceId)
end

local BuyItem = function(Item)
   BuyRemote:FireServer(Item)
end

return ReturnItemData, CheckLevel, BuyItem, ServerHop, Version
