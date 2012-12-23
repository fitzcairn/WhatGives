--
-- Global definitions for the WhatGives addon
--

-- Main Scope Table --
WhatGives = {
   -- Constants
   Constants = {
      DEBUG = debug_print,
      NONE  = "NONE",
   },

   -- Slash Command Handlers
   SlashCmdHandlers = {
   },

   -- WoW statistics of interest, in normalized/localized form.
   Stats = {
      _G["ITEM_MOD_AGILITY_SHORT"],
      _G["ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT"],
      _G["ITEM_MOD_ATTACK_POWER_SHORT"],
      _G["ITEM_MOD_BLOCK_RATING_SHORT"],
      _G["ITEM_MOD_BLOCK_VALUE_SHORT"],
      _G["ITEM_MOD_CRIT_MELEE_RATING_SHORT"],
      _G["ITEM_MOD_CRIT_RANGED_RATING_SHORT"],
      _G["ITEM_MOD_CRIT_RATING_SHORT"],
      _G["ITEM_MOD_CRIT_SPELL_RATING_SHORT"],
      _G["ITEM_MOD_CRIT_TAKEN_MELEE_RATING_SHORT"],
      _G["ITEM_MOD_CRIT_TAKEN_RANGED_RATING_SHORT"],
      _G["ITEM_MOD_CRIT_TAKEN_RATING_SHORT"],
      _G["ITEM_MOD_CRIT_TAKEN_SPELL_RATING_SHORT"],
      _G["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"],
      _G["ITEM_MOD_DEFENSE_SKILL_RATING_SHORT"],
      _G["ITEM_MOD_DODGE_RATING_SHORT"],
      _G["ITEM_MOD_EXPERTISE_RATING_SHORT"],
      _G["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"],
      _G["ITEM_MOD_HASTE_MELEE_RATING_SHORT"],
      _G["ITEM_MOD_HASTE_RANGED_RATING_SHORT"],
      _G["ITEM_MOD_HASTE_RATING_SHORT"],
      _G["ITEM_MOD_HASTE_SPELL_RATING_SHORT"],
      _G["ITEM_MOD_HEALTH_REGENERATION_SHORT"],
      _G["ITEM_MOD_HEALTH_REGEN_SHORT"],
      _G["ITEM_MOD_HEALTH_SHORT"],
      _G["ITEM_MOD_HIT_MELEE_RATING_SHORT"],
      _G["ITEM_MOD_HIT_RANGED_RATING_SHORT"],
      _G["ITEM_MOD_HIT_RATING_SHORT"],
      _G["ITEM_MOD_HIT_SPELL_RATING_SHORT"],
      _G["ITEM_MOD_HIT_TAKEN_MELEE_RATING_SHORT"],
      _G["ITEM_MOD_HIT_TAKEN_RANGED_RATING_SHORT"],
      _G["ITEM_MOD_HIT_TAKEN_RATING_SHORT"],
      _G["ITEM_MOD_HIT_TAKEN_SPELL_RATING_SHORT"],
      _G["ITEM_MOD_INTELLECT_SHORT"],
      _G["ITEM_MOD_MANA_REGENERATION_SHORT"],
      _G["ITEM_MOD_MANA_SHORT"],
      _G["ITEM_MOD_MASTERY_RATING_SHORT"],
      _G["ITEM_MOD_MELEE_ATTACK_POWER_SHORT"],
      _G["ITEM_MOD_PARRY_RATING_SHORT"],
      _G["ITEM_MOD_POWER_REGEN0_SHORT"],
      _G["ITEM_MOD_POWER_REGEN1_SHORT"],
      _G["ITEM_MOD_POWER_REGEN2_SHORT"],
      _G["ITEM_MOD_POWER_REGEN3_SHORT"],
      _G["ITEM_MOD_POWER_REGEN4_SHORT"],
      _G["ITEM_MOD_POWER_REGEN5_SHORT"],
      _G["ITEM_MOD_POWER_REGEN6_SHORT"],
      _G["ITEM_MOD_RANGED_ATTACK_POWER_SHORT"],
      _G["ITEM_MOD_RESILIENCE_RATING_SHORT"],
      _G["ITEM_MOD_SPELL_DAMAGE_DONE_SHORT"],
      _G["ITEM_MOD_SPELL_HEALING_DONE_SHORT"],
      _G["ITEM_MOD_SPELL_PENETRATION_SHORT"],
      _G["ITEM_MOD_SPELL_POWER_SHORT"],
      _G["ITEM_MOD_SPIRIT_SHORT"],
      _G["ITEM_MOD_STAMINA_SHORT"],
      _G["ITEM_MOD_STRENGTH_SHORT"],
   }
}