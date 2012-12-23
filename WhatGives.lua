-- Name: WhatGives
-- Revision: $Rev$
-- Author(s): Fitzcairn (fitz.wowaddon@gmail.com)
-- Description: SSimple tool to show what equipped items award what stat.
-- Dependencies: FitzUtils
-- License: GPL v2 or later.
--
--
-- Copyright (C) 2010-2011 Fitzcairn of Uldaman US
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--

--
-- Module Constants
--

-- Upvalues, for convienience
local UTIL       = FitzUtils;
local L          = WhatGives.Text;
local HANDLERS   = WhatGives.SlashCmdHandlers;
local STATS      = WhatGives.Stats;

-- Module-level constants
local ABOUT      = ""
local ITEMS      = {}
local BUTTONS    = {};
local SELECTED   = nil;
local TOOLTIP    = nil;
local EMPTY_TEXT = L["Highlight items with..."]

-- Local binds for speed.
local _INSERT    = table.insert
local _SORT      = table.sort
local _LOWER     = string.lower


--
-- DEBUG
--

-- Disable/enable debug output
UTIL:Debug(true)


--
-- Slash Commands
--

-- Helper to color help text
local function ColorCmdTxt(txt)
   return "|cFF3D64FF"..txt.."|r"
end

-- Helper to create help output from the command table.
local function HelpCmdHelper(cmd_tbl, s, prefix)
   prefix = prefix or ""
   for cmd,v in pairs(cmd_tbl) do
      if v.help then
         print(table.concat( { s..ColorCmdTxt(prefix..cmd),
                               s.." "..v.help },
                            "\n"))
      else
         print(HelpCmdHelper(v, s, cmd.." "))
      end
   end
end

-- Handlers for all slash command functionality.
HANDLERS = {
   [L["show"]] = {
      help = "Show WhatGives in the character frame.",
      run  = function() WhatGivesMenu:Show() end,
   },
   [L["hide"]] = {
      help = L["Hide WhatGives in the character frame."],
      run  = function() WhatGivesMenu:Hide() end,
   },
   [L["about"]] = {
      help = L["Some information about this addon."],
      run  = function() print(ABOUT) end,
   },
   [L["help"]] = {
      help = L["Display this help text4."],
      run  = nil,
   },
}

-- Dispatch, based off of ideas in "World of Warcraft Programmng 2nd Ed"
-- These variables are set in global scope.
SLASH_WHATGIVES1 = L["/whatgives"]
SLASH_WHATGIVES2 = L["/wg"]

local function HandleSlashCmd(msg, tbl)
   local cmd, param = string.match(msg, "^(%w+)%s*(.*)$")
   cmd = cmd or ""
   local e = tbl[cmd:lower()]
   if not e or cmd == L["help"] then
      -- Not recognized, output slash command help
      print(ColorCmdTxt(SLASH_WHATGIVES1))
      print(ColorCmdTxt(SLASH_WHATGIVES2))
      HelpCmdHelper(HANDLERS, "      ")
   elseif e.run then
      e.run(param)
   else
      HandleSlashCmd(param or "", e)
   end
end

-- Register commands.
SlashCmdList["WHATGIVES"] = function (msg) HandleSlashCmd(msg, HANDLERS) end


--
-- Character Frame Interaction
--

local function ItemShow(button)
   button.border:Show()
end

local function ItemHide(button)
   button.border:Hide()
end

local function CreateButtonBorder(button)
   -- TODO: Create sparkly border!
   local border = button:CreateTexture(nil, "OVERLAY")
   border:SetWidth(67)
   border:SetHeight(67)
   border:SetPoint("CENTER", button)
   border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
   border:SetBlendMode("ADD")
   border:SetVertexColor(1, 0, 0, 0.85)
   border:Hide()
   button.border = border
end

-- Get stats for gems currently socketed in the item
-- Fills stats argument
local function GetItemGemStats(itemLink, stats)
   local socketNum = 1
   local done = false
   while not done do
      local gemName, gemLink = GetItemGem(itemLink, socketNum)
      if gemLink then
     GetItemStats(gemLink, stats)
     socketNum = socketNum + 1
      else
     done = true
      end
   end
end

-- Scan the tooltip for this item to get the full list of stats.
-- Fills in the stats argument.
local function GetStatsFromTooltip(unit, slotId, stats)
   local stats = {}
   if not TOOLTIP then
      TOOLTIP = CreateFrame(
     'GameTooltip', 'WhatGivesTooltip', UIParent, 'GameTooltipTemplate')
   end
   TOOLTIP:SetOwner(UIParent, 'ANCHOR_NONE')
   TOOLTIP:SetInventoryItem(unit, slotId)

   -- Parse tooltip contents
   local lineNum = 1
   local done = false
   while not done do
      local frame = _G["WhatGivesTooltipTextLeft"..lineNum]
      lineNum = lineNum + 1
      if frame then
     local ttText = frame:GetText()
     if ttText then
        ttText = _LOWER(ttText)
        -- Lines can have multiple stats; hence we loop completely.
        for i,k in ipairs(STATS) do
           if strfind(ttText, _LOWER(k), 1, true) then
          stats[k] = 1
           end
        end
     else
        done = true
     end
      else
     done = true
      end
   end

   TOOLTIP:Hide()
   return stats
end

-- Update map of stat -> [button]
-- Returns: map of localized stat name -> value for the item
local function UpdateAndReturnMap(button, unit, slotId)
   local stats = {}
   local itemLink = GetInventoryItemLink(unit, slotId)
   if not itemLink then
      return stats
   end

   BUTTONS[button] = 1

   -- Get base stats into stats
   for k,v in pairs(GetItemStats(itemLink)) do
      stats[_G[k]] = 1 -- Get localized string
   end

   -- Scan the tooltip to get all reforge, gem, enchant bonuses.
   for k,v in pairs(GetStatsFromTooltip(unit, slotId)) do
      stats[k] = 1 -- Stat already in localized form
   end

   -- Update global state.
   for stat, value in pairs(stats) do
      if not ITEMS[stat] then
     ITEMS[stat] = {button}
      else
     _INSERT(ITEMS[stat], button)
      end
   end
   return stats
end

-- Update map and highlight button if necessary.
local function UpdateFromItemSlotButton(button, unit)
   local slotId = button:GetID()
   if (slotId >= INVSLOT_FIRST_EQUIPPED and
       slotId <= INVSLOT_LAST_EQUIPPED) then
      if not button.border then
         CreateButtonBorder(button)
      end
      local stats = UpdateAndReturnMap(button, unit, slotId)
      -- If this item gives the currently selected stat, highlight it.
      if SELECTED and stats[SELECTED] then
         ItemShow(button)
      else
         ItemHide(button)
      end
   end
end


--
-- Init -- Called only after "ADDON_LOADED" event fires
--

local function Init(frame)
   UTIL:Print("Initing. . . ")
   local version = GetAddOnMetadata("WhatGives","Version")
   local title   =  L["WhatGives"].." v"..version
   ABOUT = ColorCmdTxt(title.. L[", by Fitzson of Uldaman US"])
   UTIL:Print("Initialized!")
   print(ColorCmdTxt(L["WhatGives loaded successfully!  Type /wg for options."]))
end


--
-- Dropdown
--

-- Create the drowndown menu
CreateFrame(
   "Button", "WhatGivesMenu", _G["CharacterFrame"], "UIDropDownMenuTemplate")

local function MenuOnClick(self, arg1)
   UIDropDownMenu_SetSelectedID(WhatGivesMenu, self:GetID())
   SELECTED = arg1
   for button,_ in pairs(BUTTONS) do
      ItemHide(button)
   end
   if SELECTED then
      if ITEMS[SELECTED] then
         for i,button in ipairs(ITEMS[SELECTED]) do
            ItemShow(button)
         end
      end
   else
      -- Clear the dropdown text
      UIDropDownMenu_SetText(WhatGivesMenu, EMPTY_TEXT)
   end
end

local function MenuInitialize(self, level)
   local info = UIDropDownMenu_CreateInfo()
   local _addItem = function(txt, val, func)
      info = UIDropDownMenu_CreateInfo()
      info.text = txt
      info.value = val
      info.arg1 = val
      info.func = func
      UIDropDownMenu_AddButton(info, level)
   end

   -- Add something to clear selection
   _addItem(L["None"], nil, MenuOnClick)

   -- Sort the map of items by stat (key).
   local stats = {}
   for k,v in pairs(ITEMS) do
      _INSERT(stats, k)
   end
   _SORT(stats, function(a, b) return a < b end)

   -- Output a ordered list of stats
   for i,k in ipairs(stats) do
      _addItem(k, k, MenuOnClick)
   end
end

-- Place dropdown within character frame
WhatGivesMenu:ClearAllPoints()
WhatGivesMenu:SetPoint("BOTTOM", _G["CharacterModelFrame"], "BOTTOM", 0, 15)
WhatGivesMenu:Show()
UIDropDownMenu_Initialize(WhatGivesMenu, MenuInitialize)
UIDropDownMenu_SetWidth(WhatGivesMenu, 160);
UIDropDownMenu_SetButtonWidth(WhatGivesMenu, 184)
UIDropDownMenu_SetText(WhatGivesMenu, EMPTY_TEXT)
UIDropDownMenu_JustifyText(WhatGivesMenu, "LEFT")


--
-- Hook into the WoW UI
--

local function ClearAllData()
   wipe(ITEMS)
end

-- OnHide, clear the stat table for re-building next time.
WhatGivesMenu:SetScript(
   "OnHide",
   function(self)
      ClearAllData()
   end)

-- Load the addon through an event on that dropdown.
WhatGivesMenu:SetScript(
   "OnEvent",
   function (self, event, addon)
      if event == "ADDON_LOADED" and addon == "WhatGives" then
         Init(self)
      elseif event == "EQUIPMENT_SWAP_FINISHED" then
         ClearAllData()
         -- Refresh data for all buttons.
         for button,_ in pairs(BUTTONS) do
            UpdateFromItemSlotButton(button, "player")
         end
      end
   end)
WhatGivesMenu:RegisterEvent("ADDON_LOADED")
WhatGivesMenu:RegisterEvent("EQUIPMENT_SWAP_FINISHED")

-- Button updates are triggered by PaperDollFrame_OnShow().
hooksecurefunc(
   "PaperDollItemSlotButton_Update",
   function (button)
      UpdateFromItemSlotButton(button, "player")
   end)
