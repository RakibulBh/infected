local status : StringValue = game:GetService("ReplicatedStorage").Status

local module = {}

module.Intermission = function (GAME_TIME)
	for i = GAME_TIME, 1, -1 do
		status.Value = i
		wait(1)
	end
end

module.ChooseMap = function (maps)
	local randomNum = math.random(1, #maps)
	local randomMap = maps[randomNum]
	if randomMap then
		return randomMap
	end
end

return module
