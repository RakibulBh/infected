local roundModule = require(script.RoundModule)
local maps = game:GetService("ServerStorage").Maps:GetChildren()
local status : StringValue = game:GetService("ReplicatedStorage").Status

roundModule.Intermission(5)

status.Value = "Choosing map..."
wait(2)
local chosenMap = roundModule.ChooseMap(maps)
status.Value = "Map chosen: "..chosenMap.Name
