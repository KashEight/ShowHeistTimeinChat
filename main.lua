local g_time = "00:00"

if RequiredScript == "lib/managers/hud/hudchat" then
    function HUDChat:receive_message(name, message, color, icon)
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

        local output_panel = self._panel:child("output_panel")
        local len = utf8.len(name) + 1
        local x = 0
        local icon_bitmap = nil
    
        if icon then
            local icon_texture, icon_texture_rect = tweak_data.hud_icons:get_icon_data(icon)
            icon_bitmap = output_panel:bitmap({
                y = 1,
                texture = icon_texture,
                texture_rect = icon_texture_rect,
                color = color
            })
            x = icon_bitmap:right()
        end
    
        local line = output_panel:text({
            halign = "left",
            vertical = "top",
            hvertical = "top",
            wrap = true,
            align = "left",
            blend_mode = "normal",
            word_wrap = true,
            y = 0,
            layer = 0,
            text = name .. ": " .. message,
            font = tweak_data.menu.pd2_small_font,
            font_size = tweak_data.menu.pd2_small_font_size,
            x = x,
            color = color
        })
        local total_len = utf8.len(line:text())
    
        line:set_range_color(0, len, color)
        line:set_range_color(len, total_len, Color.white)
    
        local _, _, w, h = line:text_rect()
    
        line:set_h(h)
        table.insert(self._lines, {
            line,
            icon_bitmap
        })
        line:set_kern(line:kern())
        self:_layout_output_panel()
    
        if not self._focus then
            local output_panel = self._panel:child("output_panel")
    
            output_panel:stop()
            output_panel:animate(callback(self, self, "_animate_show_component"), output_panel:alpha())
            output_panel:animate(callback(self, self, "_animate_fade_output"))
        end
    end
end