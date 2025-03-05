Config = {}

Config.SurrenderChance = 0.3 -- 30% -- find your own smooth-point

Config.MinMoney = 0.01 -- min reward 
Config.MaxMoney = 0.18 -- max reward

Config.WeaponChance = 0.6 -- 60% -- find your own smooth-point

Config.GiveMoneyAnimDict = 'script_rc@chrb@ig1_visit_clerk'
Config.GiveMoneyAnim = 'arthur_gives_money_player'

Config.Notification = { -- translations
    AlreadyRobbed = {'failed', 'You have already robbed this person!', 'generic_textures', 'cross', 4000},
    MoneyDropped = {'success', 'Loot: $%.2f', 'generic_textures', 'tick', 4000},
    NPCFighting = {'failed', 'The person is not cooperating!', 'generic_textures', 'cross', 4000}
}
