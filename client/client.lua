local robbedNPCs = {}
local animalModels = Config.AnimalModels

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
        local _, currentWeapon = GetCurrentPedWeapon(playerPed, true)

        if aiming and DoesEntityExist(entity) and IsEntityAPed(entity) and not IsPedAPlayer(entity) and currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
            local model = GetEntityModel(entity)
            local isAnimal = false
            
            for _, animalModel in pairs(animalModels) do
                if model == GetHashKey(animalModel) then
                    isAnimal = true
                    break
                end
            end

            if not isAnimal then
                local npcNetId = NetworkGetNetworkIdFromEntity(entity)
                
                if not robbedNPCs[npcNetId] then
                    Citizen.Wait(3000) -- Wartezeit bevor der Raub startet
                    
                    if not IsEntityAPed(entity) or not DoesEntityExist(entity) then
                        return
                    end
                    
                    robbedNPCs[npcNetId] = true
                    FreezeEntityPosition(entity, true)
                    Citizen.Wait(1500)

                    local shouldSurrender = math.random() < Config.SurrenderChance
                    
                    if shouldSurrender then
                        TaskHandsUp(entity, 5000, playerPed, -1, true)
                        Citizen.Wait(3000)
                        TriggerServerEvent('npc:dropMoney', npcNetId, math.random(Config.MinMoney * 100, Config.MaxMoney * 100) / 100, false)
                        TriggerServerEvent('npc:playGiveAnim', npcNetId)
                    else
                        SetPedFleeAttributes(entity, 0, true)
                        SetBlockingOfNonTemporaryEvents(entity, false)
                        ClearPedTasks(entity)
                        TaskSmartFleePed(entity, playerPed, 200.0, -1, false, false)
                    end

                    Citizen.Wait(3000)
                    FreezeEntityPosition(entity, false)
                end
            end
        end
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
            FreezeEntityPosition(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            SetPedCanRagdoll(npc, false)
            SetPedFleeAttributes(npc, 0, false)
            SetPedCombatAttributes(npc, 0, false)
            ClearPedTasksImmediately(npc)
            NPC_GIVEANIM(npc)
        end
    end
end)

function NPC_GIVEANIM(npc)
    RequestAnimDict(Config.GiveMoneyAnimDict)
    while not HasAnimDictLoaded(Config.GiveMoneyAnimDict) do
        Citizen.Wait(1)
    end
    TaskPlayAnim(npc, Config.GiveMoneyAnimDict, Config.GiveMoneyAnim, 4.0, 4.0, 2500, 10, 0, false, false, false, false)
end

RegisterNetEvent('npc:makeNpcFlee')
AddEventHandler('npc:makeNpcFlee', function(npcNetId)
    local npc = NetworkGetEntityFromNetworkId(npcNetId)
    if DoesEntityExist(npc) then
        SetPedFleeAttributes(npc, 0, true)
        SetBlockingOfNonTemporaryEvents(npc, false)
        ClearPedTasks(npc)
        TaskSmartFleePed(npc, GetPlayerPed(-1), 200.0, -1, false, false)
    end
end)