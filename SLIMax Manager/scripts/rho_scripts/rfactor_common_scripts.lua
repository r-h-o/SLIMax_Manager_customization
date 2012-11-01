-- rFactor 1/2 Custom Scripts - SLIMax Manager Scripts v1.8
-- Copyright ©2012 by r(h)o - All Rights Reserved.
-- last change by r(h)o - 2012-11-01

-- ================================
-- CONSTANTS

-- function indexes
rhoFunctionSelectedLeft  = 1
rhoFunctionSelectedRight = 1

-- some helper values for repeated keystrokes
rhoPitFunction = 3
rhoPitRepeatedIndexes = {}
rhoPitRepeatedIndexes[5] = true
rhoPitRepeatedIndexes[6] = true

-- functions associated to switches
-- switch 2 will start with PIT menu
rhoFunctionsLeft  = { 1, 2, 3, 4, 5, 6, 7 }
rhoFunctionsRight = { 3, 2, 1, 4, 5, 6, 7 }

-- association button-function (soldering order)
rhoButtonsLeft  = {}
rhoButtonsLeft [13] = 1
rhoButtonsLeft [32] = 2
rhoButtonsLeft [31] = 3
rhoButtonsLeft [11] = 4
rhoButtonsLeft [12] = 5
rhoButtonsLeft [30] = 6
rhoButtonsRight = {}
rhoButtonsRight[ 3] = 1
rhoButtonsRight[ 4] = 2
rhoButtonsRight[ 6] = 3
rhoButtonsRight[ 5] = 4
rhoButtonsRight[29] = 5
rhoButtonsRight[16] = 6

-- message to be displayed on digits panels
-- corresponds to various possible menus
rhoProgramMsg = {
	" main ",
	" chat ",
	"  pit ",
	"  hud ",
	" extra",
	"  box ",
	" other",
}

-- mapping between buttons ordinals (from top to bottom of wheel) and functions
-- I defined the following functions in rFactor (slipro profile):
-- A - LCD mode
-- B - LCD up
-- C - LCD down
-- D - Boost -
-- E - request pit
-- F - Boost +
-- G - hw plugin
-- H - LDC -
-- I - AI
-- J - pit display
-- K - Brake bias +
-- L - Brake bias -
-- M - extra info
-- N - headlights
-- O - TC override
-- P - passenger select
-- Q - reset FFB
-- R - standard display
-- S - horn
-- T - vehicle status
-- U - LDC +
-- V - chat
-- X - starter
-- Y - standings display
-- W - driver hot swap
-- Z - ignition
-- 1 - race info
-- 2 - auto clutch
-- , - Launch control
-- TAB - Vehicle labels
-- F1..F9 - chats 1..9 (6 is ping)
-- F10 - yes
-- F11 - no
-- F12 - screenshot

rhoMapButtonMain = {
	"E",
	"Q",
	"J",
	"T",
	"TAB",
	"Y",
}

rhoMapButtonChat = {
	"F1",
	"F2",
	"F3",
	"F4",
	"F5",
	"F6",
}

rhoMapButtonPit = {
	"B",
	"C",
	"U",
	"H",
	"U", -- to be repeated 5 times
	"H", -- to be repeated 5 times
}

rhoMapButtonHud = {
	"A",
	"R",
	"M",
	"2",
	"2",
	"I",
}

rhoMapButtonExtra = {
	"W",
	"P",
	"O",
	",",
	"N",
	"1",
}

rhoMapButtonBox = {
	"Z",
	"X",
	"S",
	"Z",
	"X",
	"S",
}

rhoMapButtonOther = {
	"F10",
	"F11",
	"V",
	"F12",
	"F12",
	"G",
}

-- all buttons mappings
rhoMapButtons = {}
rhoMapButtons[1] = rhoMapButtonMain
rhoMapButtons[2] = rhoMapButtonChat
rhoMapButtons[3] = rhoMapButtonPit
rhoMapButtons[4] = rhoMapButtonHud
rhoMapButtons[5] = rhoMapButtonExtra
rhoMapButtons[6] = rhoMapButtonBox
rhoMapButtons[7] = rhoMapButtonOther


-- ================================
-- additional lua extension module dll


-- ================================
-- additional scripts file
require "scripts/rho_scripts/utils"

-- ================================
-- custom globals


-- ================================
-- custom functions

-- ================================
-- custom events

function custom_deviceReport(devType)
	-- type your script here (just before sending report to the device )
	return 2
end

function custom_ospMethodEvent(idx)
	-- type your custom Optimal Shift Points (OSP) method here
	return 2
end

function custom_shiftLightsMethodEvent(idx)
	-- type your custom shiftlights method here
	return 2
end

function custom_shiftLightsBU0710Event(idx)
	-- type your custom shiftlights method for BU0710 device only here
	return 2
end

function custom_spdLmtMethodEvent(idx)
	-- type your custom speedlimiter method here
	return 2
end

function custom_gearEvent(gear)
	-- type your custom gear event script here
	return 2
end

function custom_enterSessionEvent(devType)
	-- type your custom script on session start, here
	return 2
end

function custom_exitSessionEvent(devType)
	-- type your custom script on session ending, here
	return 2
end


-- param deviceIdx = (see mDeviceType table)
-- param ctrlType = type of ctrl, switch (0) or button (1)
-- param ctrlPos = ctrl index, switch from 1 to 6 and button from 1 to n 
-- param value = ctrl value, button down (>0) or up (==0) and switch from 1 to 12 
-- return 0 to give the control to SLIMax Mgr
-- return 1 to force the update of device
function custom_controlsEvent(deviceIdx, ctrlType, ctrlPos, value, funcIndex)
	-- uncomment for debugging into the console
	local dev = mDeviceType[deviceIdx]
	-- print("Dev: " .. deviceIdx .. " Type: " .. ctrlType .. " Pos: " .. ctrlPos .. " Val: " .. value .. " Func: " .. funcIndex)

	-- function switch management
	if dev == "SLI-PRO" and ctrlType == 0 then
		if ctrlPos == 1 then
			-- I save the switch position to know in what menu I am
			-- because of solderings, the right switch is #1
			rhoFunctionSelectedRight = value
			-- print("Right function: " .. rhoFunctionSelectedRight)
			return 1
		elseif ctrlPos == 2 then
			-- I save the switch position to know in what menu I am
			-- because of solderings, the left switch is #2
			rhoFunctionSelectedLeft = value
			-- print("Left function: " .. rhoFunctionSelectedLeft)
			return 1
		end
	end

	-- buttons management
	if dev == "SLI-PRO" and ctrlType == 1 and value > 0 then
		-- button pressed
		-- tries to retrieve the ordinal of this button if it is on the left
		local funcs_index = rhoButtonsLeft[ctrlPos]
		if funcs_index ~= nil then
			-- print("Func. left: " .. funcs_index)
			local funcs = rhoFunctionsLeft[rhoFunctionSelectedLeft]
			return rho_send_keystroke(funcs, funcs_index)
		end
		-- tries to retrieve the ordinal of this button if it is on the right
		funcs_index = rhoButtonsRight[ctrlPos]
		if funcs_index ~= nil then
			-- print("Func. right: " .. funcs_index)
			local funcs = rhoFunctionsRight[rhoFunctionSelectedRight]
			return rho_send_keystroke(funcs, funcs_index)
		end
	end
	
	return 2
end

function custom_leftDigitsEvent(swPosition)
	local info = rho_menu_info(rhoFunctionsLeft[rhoFunctionSelectedLeft])
	SetLeftDigits(info)
	return 1
end

function custom_rightDigitsEvent(swPosition)
	local info = rho_menu_info(rhoFunctionsRight[rhoFunctionSelectedRight])
	SetRightDigits(info)
	return 1
end
