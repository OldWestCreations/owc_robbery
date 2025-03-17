local VORPcore = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

local Inventory = exports.vorp_inventory:vorp_inventoryApi()
local T = Translation.Langs[Lang] 

local robbedPeds = {}

RegisterServerEvent('npcrobbery:attemptRobbery')
AddEventHandler('npcrobbery:attemptRobbery', function(pedID, model)
    local _source = source

    for _, blockedModel in pairs(Config.AnimalModels) do
        if model == GetHashKey(blockedModel) then
            return
        end
    end

    if robbedPeds[pedID] then
        TriggerClientEvent("npcrobbery:notifyAlreadyRobbed", _source)
    else
        robbedPeds[pedID] = true
        TriggerClientEvent("npcrobbery:startRobbery", _source, pedID)
    end
end)

RegisterServerEvent('npcrobbery:giveLoot')
AddEventHandler('npcrobbery:giveLoot', function(coords)
    local _source = source
    local User = VORPcore.getUser(_source)
    if not User then return end

    local Character = User.getUsedCharacter
    if not Character then return end

    local lootGiven = false

    if Config.canReceiveMoney and math.random(1, 100) <= Config.chanceGettingMoney then
        local amount = Config.money[math.random(1, #Config.money)]
        Character.addCurrency(0, amount)
        VORPcore.NotifyLeft(_source, T.notifytitle, 
            T.youGot .. string.format("%.2f", amount) .. T.currency, 
            "BLIPS", "blip_ambient_bounty_target", 3000, "COLOR_GREEN")
        lootGiven = true
    end

    if Config.canReceiveGold and math.random(1, 100) <= Config.chanceGettingGold then
        local amount = Config.gold[math.random(1, #Config.gold)]
        Character.addCurrency(1, amount)
        VORPcore.NotifyLeft(_source, T.notifytitle, 
            T.youGot .. string.format("%.2f", amount) .. T.nugget, 
            "BLIPS", "blip_ambient_bounty_target", 3000, "COLOR_GREEN")
        lootGiven = true
    end

    if Config.canReceiveItems and math.random(1, 100) <= Config.chanceGettingItem then
        local item = Config.items[math.random(1, #Config.items)]
        Inventory.addItem(_source, item.name, item.amount)
        VORPcore.NotifyLeft(_source, T.notifytitle, 
            T.youGot .. item.label, 
            "BLIPS", "blip_ambient_bounty_target", 3000, "COLOR_GREEN")
        lootGiven = true
    end

    if not lootGiven then
        VORPcore.NotifyLeft(_source, T.notifytitle, 
            T.nothingValuable, 
            "BLIPS", "blip_destroy", 3000, "COLOR_RED")
    end
end)
