-- loading

repeat wait() until game.IsLoaded
repeat wait() until game.Players.LocalPlayer

-- runtime

local RunTime = loadstring(game:HttpGet("https://raw.githubusercontent.com/BR4DKILLER/ROBLOX/main/AIM-VIEWER/FUNCTIONS"))()
local Toggle = RunTime["Toggle"]

--[[ BELOW IS JUST DOCUMENTATION
Toggle("Enabled") will Enable & Disable the Aim Viewer.
Toggle("Target", Player - > Object) Will change the Aim Viewer's target.
Toggle("Debug") Will Enable debug mode.

The rest is handled normally, if you wish to use this then please credit me. This will work for Da Hood/Hood Modded although i do not condone exploiting on either for a bad purpose.
]]--
