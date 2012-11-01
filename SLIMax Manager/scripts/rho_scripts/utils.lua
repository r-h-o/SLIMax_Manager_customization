-- rFactor 1/2 Custom Scripts - SLIMax Manager Scripts v1.8
-- Copyright ©2012 by r(h)o - All Rights Reserved.
-- last change by r(h)o - 2012-11-01

function rho_send_keystroke(funcs, funcs_index)
	-- sends keystroke corresponding to funcs_index inside funcs table
	local SetKeystroke_pause = 20
	local SLISleep_pause = 30
	if funcs ~= nil then
		local key = rhoMapButtons[funcs][funcs_index]
		-- I tried to retrieve the actual button function
		if key ~= nil then
			-- print("Key: " .. key)
			SetKeystroke(key, SetKeystroke_pause, "")
			SLISleep(SLISleep_pause)
			-- repetition on Pit menu
			if funcs == rhoPitFunction then -- 4th is Pit menu
				if rhoPitRepeatedIndexes[funcs_index] then
					-- 5th and 6th functions on Pit menu must be repeated 4 more times
					for i = 1, 4 do
						SetKeystroke(key, SetKeystroke_pause, "")
						SLISleep(SLISleep_pause)
					end
				end
			end
			return 1
		end
	end
	return 2
end



function rho_menu_info(menu_index)
	-- retrieves the menu name to be displayed on digits
	if menu_index ~= nil then
		local menu = rhoProgramMsg[menu_index]
		if menu ~= nil then
			return menu
		end
	end
	-- no menu to be displayed
	return "      "
end
