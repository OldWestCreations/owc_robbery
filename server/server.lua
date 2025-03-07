local VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

local npcHasDroppedMoney = {}

local animalModels = Config.AnimalModels

RegisterNetEvent('npc:dropMoney')
AddEventHandler('npc:dropMoney', function(npcNetId, amount, shouldAttack)
    local src = source
    local npc = NetworkGetEntityFromNetworkId(npcNetId)
    
    if DoesEntityExist(npc) and not IsPedAPlayer(npc) then
        local model = GetEntityModel(npc)
        
        local isAnimal = false
        for _, animalModel in pairs(animalModels) do
            if model == GetHashKey(animalModel) then
                isAnimal = true
                break
            end
        end
        
        if isAnimal then
            return
        end
        
        local npcId = tostring(npcNetId)
        
        if npcHasDroppedMoney[npcId] then
            TriggerClientEvent('vorp:NotifyLeft', src, Config.Notification.AlreadyRobbed[1], Config.Notification.AlreadyRobbed[2], Config.Notification.AlreadyRobbed[3], Config.Notification.AlreadyRobbed[4])
            return 
        end
        
        npcHasDroppedMoney[npcId] = true 
        
        FreezeEntityPosition(npc, true)
        Citizen.Wait(3000)
        FreezeEntityPosition(npc, false)
        
        if shouldAttack then
            GiveWeaponToPed(npc, GetHashKey("WEAPON_REVOLVER_CATTLEMAN"), 6, false, true)
            TaskCombatPed(npc, GetPlayerPed(src), 0, 16)
            TriggerClientEvent('vorp:NotifyLeft', src, Config.Notification.NPCFighting[1], Config.Notification.NPCFighting[2], Config.Notification.NPCFighting[3], Config.Notification.NPCFighting[4])
            return
        end
        
        local user = VorpCore.getUser(src)
        if not user then return end

        local character = user.getUsedCharacter
        if not character then return end

        character.addCurrency(0, amount)
        TriggerClientEvent('vorp:NotifyLeft', src, Config.Notification.MoneyDropped[1], ('Betrag: $%.2f'):format(amount), Config.Notification.MoneyDropped[3], Config.Notification.MoneyDropped[4])
    end
end)

RegisterNetEvent('npc:playGiveAnim')
AddEventHandler('npc:playGiveAnim', function(npcNetId)
    local npc = NetworkGetEntityFromNetworkId(npcNetId)
    
    if DoesEntityExist(npc) and not IsPedAPlayer(npc) then
        local model = GetEntityModel(npc)
        
        local isAnimal = false
        for _, animalModel in pairs(animalModels) do
            if model == GetHashKey(animalModel) then
                isAnimal = true
                break
            end
        end
        
        if not isAnimal then
            TriggerClientEvent('npc:playGiveAnim', -1, npcNetId)
        end
    end
end)

RegisterNetEvent('npc:makeNpcFlee')
AddEventHandler('npc:makeNpcFlee', function(npcNetId)
    local npc = NetworkGetEntityFromNetworkId(npcNetId)
    
    if DoesEntityExist(npc) then
        SetPedFleeAttributes(npc, 0, true)
        SetPedFleeBehaviorOnCombatLoss(npc, true)
        
        Citizen.Wait(500)
        TaskReactAndFleePed(npc, GetPlayerPed(-1))
    end
end)
