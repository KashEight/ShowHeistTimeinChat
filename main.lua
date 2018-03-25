local g_time = "00:00"
local receive_message_original = HUDChat.receive_message

if RequiredScript == "lib/managers/hud/hudchat" then
    function HUDChat:receive_message(name, ...)
        local heisttime = managers.game_play_central and managers.game_play_central:get_heist_timer() or 0
		local hours = math.floor(heisttime / (60*60))
		local minutes = math.floor(heisttime / 60) % 60
		local seconds = math.floor(heisttime % 60)
        
		if hours > 0 then
			g_time = string.format("%d:%02d:%02d", hours, minutes, seconds)
		else
			g_time = string.format("%02d:%02d", minutes, seconds)
        end

        name = g_time .. " " .. name

        receive_message_original(self, name, ...)
    end
end